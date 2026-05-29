--[[
  hassh.lua - Wireshark Lua post-dissector computing HASSH SSH fingerprints.

  HASSH (client):
    hassh = MD5(kex ; enc_c2s ; mac_c2s ; comp_c2s)
  hasshServer (server):
    hasshServer = MD5(kex ; enc_s2c ; mac_s2c ; comp_s2c)

  Computed from SSH_MSG_KEXINIT packets. Direction is determined by TCP port:
  dst_port==22 => client KEXINIT (hassh); src_port==22 => server KEXINIT
  (hasshServer); neither => non-standard port, compute both.
]]--

-- Load the bundled MD5 implementation relative to this file's location.
local _src = debug.getinfo(1, "S").source:gsub("^@", "")
local _dir = _src:match("(.*[/\\])") or "./"
local md5 = dofile(_dir .. "lib/md5.lua")

-- Protocol and fields.
local hassh_proto = Proto("hassh", "HASSH SSH Fingerprinting")

local pf_fingerprint        = ProtoField.string("hassh.fingerprint", "HASSH")
local pf_server_fingerprint = ProtoField.string("hassh.server_fingerprint", "hasshServer")
local pf_algorithms         = ProtoField.string("hassh.algorithms", "HASSH Algorithms")
local pf_server_algorithms  = ProtoField.string("hassh.server_algorithms", "hasshServer Algorithms")

hassh_proto.fields = {
  pf_fingerprint,
  pf_server_fingerprint,
  pf_algorithms,
  pf_server_algorithms,
}

-- Field extractors for the SSH KEXINIT algorithm lists (must be at file scope).
local f_kex      = Field.new("ssh.kex_algorithms")
local f_enc_c2s  = Field.new("ssh.encryption_algorithms_client_to_server")
local f_enc_s2c  = Field.new("ssh.encryption_algorithms_server_to_client")
local f_mac_c2s  = Field.new("ssh.mac_algorithms_client_to_server")
local f_mac_s2c  = Field.new("ssh.mac_algorithms_server_to_client")
local f_comp_c2s = Field.new("ssh.compression_algorithms_client_to_server")
local f_comp_s2c = Field.new("ssh.compression_algorithms_server_to_client")

-- Return the .value of a FieldInfo, or "" if absent.
local function fval(fi)
  if fi == nil then return "" end
  local v = fi.value
  if v == nil then return "" end
  return tostring(v)
end

local function dissect(tvb, pinfo, tree)
  -- Only act on KEXINIT packets (those carrying the kex_algorithms field).
  local kex_fi = f_kex()
  if kex_fi == nil then
    return
  end

  local kex = fval(kex_fi)

  -- Wireshark populates both c2s and s2c lists on every KEXINIT regardless of
  -- direction, so direction must be derived from the TCP ports, not nil-ness.
  local do_client = false
  local do_server = false
  if pinfo.dst_port == 22 then
    do_client = true
  elseif pinfo.src_port == 22 then
    do_server = true
  else
    -- Non-standard port: cannot tell direction, emit both.
    do_client = true
    do_server = true
  end

  local subtree = tree:add(hassh_proto, "HASSH")

  if do_client then
    local algs = kex .. ";" ..
                 fval(f_enc_c2s()) .. ";" ..
                 fval(f_mac_c2s()) .. ";" ..
                 fval(f_comp_c2s())
    local hash = md5.sumhexa(algs)
    subtree:add(pf_fingerprint, hash)
    subtree:add(pf_algorithms, algs)
    pinfo.cols.info:append(" [HASSH: " .. hash .. "]")
  end

  if do_server then
    local algs = kex .. ";" ..
                 fval(f_enc_s2c()) .. ";" ..
                 fval(f_mac_s2c()) .. ";" ..
                 fval(f_comp_s2c())
    local hash = md5.sumhexa(algs)
    subtree:add(pf_server_fingerprint, hash)
    subtree:add(pf_server_algorithms, algs)
    pinfo.cols.info:append(" [hasshServer: " .. hash .. "]")
  end
end

function hassh_proto.dissector(tvb, pinfo, tree)
  local ok, err = pcall(dissect, tvb, pinfo, tree)
  if not ok then warn("hassh dissector error: " .. tostring(err)) end
end

register_postdissector(hassh_proto)
