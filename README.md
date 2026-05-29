# hassh-wireshark-plugin

A Wireshark Lua plugin that computes HASSH fingerprints from SSH KEXINIT packets.

---

## What is HASSH

HASSH is an SSH fingerprinting method developed by Salesforce. It computes an MD5
hash of the algorithm lists negotiated during the SSH key-exchange initialization
(KEXINIT): key exchange algorithms, encryption ciphers, MAC algorithms, and
compression methods. The resulting fingerprint identifies specific SSH client and
server implementations regardless of source IP or port.

## Why this plugin

Wireshark 3.6 and later include native HASSH fields (`ssh.kex_hassh`,
`ssh.kex_hasshserver`), but this plugin backports the computation to any Wireshark
version that has Lua support enabled. It
also appends `[HASSH: <hash>]` or `[hasshServer: <hash>]` annotations to the Info
column for at-a-glance identification, and exposes the raw algorithm strings as
dedicated fields for deeper inspection and filtering.

## Prerequisites

Wireshark with Lua scripting enabled. To verify:

```
wireshark --version | grep -i lua
tshark --version | grep -i lua
```

The output should include a Lua version number (e.g., `with Lua 5.4.6`).

## Installation

**Linux / macOS**

```sh
./install.sh
```

**Windows**

```bat
install.bat
```

**Manual**

Copy `hassh.lua` and the `lib/` directory into your Wireshark personal plugins
folder, then restart Wireshark.

| Platform  | Plugins folder                                          |
|-----------|--------------------------------------------------------|
| Linux     | `~/.local/lib/wireshark/plugins/`                      |
| macOS     | `~/Library/Application Support/Wireshark/plugins/`    |
| Windows   | `%APPDATA%\Wireshark\plugins\`                         |

You can also find the path in Wireshark under Help → About Wireshark → Folders →
Personal Plugins.

## Usage

### Packet detail pane

Decoded fields appear in the **HASSH** subtree inside each SSH KEXINIT packet.

| Field                       | Description                                 |
|-----------------------------|---------------------------------------------|
| `hassh.fingerprint`         | MD5 of client KEXINIT algorithm lists       |
| `hassh.server_fingerprint`  | MD5 of server KEXINIT algorithm lists       |
| `hassh.algorithms`          | Raw algorithm string used for client hash   |
| `hassh.server_algorithms`   | Raw algorithm string used for server hash   |

Direction is determined by port: packets with `dst_port == 22` are treated as client
KEXINIT; packets with `src_port == 22` are treated as server KEXINIT. On
non-standard SSH ports (neither endpoint is 22), both `hassh.fingerprint` and
`hassh.server_fingerprint` are emitted on the same KEXINIT packet.

### Adding a HASSH column

1. Edit → Preferences → Columns
2. Click **+** to add a new column
3. Set **Type** to `Custom`
4. Set **Field name** to `hassh.fingerprint`
5. Repeat for `hassh.server_fingerprint` if desired

### Color rules

Import the included `colorfilters` file to highlight HASSH packets:

1. View → Coloring Rules → Import
2. Select the `colorfilters` file from this repository

Client KEXINIT packets will be highlighted in royal blue; server KEXINIT packets in
forest green.

### Display filter examples

Show only packets with a client HASSH fingerprint:

```
hassh.fingerprint
```

Match a specific client fingerprint:

```
hassh.fingerprint == "8a8ae540028bf433cd68356c1b9e8d5b"
```

Show both client and server HASSH packets:

```
hassh.fingerprint || hassh.server_fingerprint
```

Filter by raw algorithm string:

```
hassh.algorithms contains "curve25519-sha256"
```

## References

- [HASSH: Profiling SSH Clients and Servers](https://engineering.salesforce.com/open-sourcing-hassh-abed3ae5044c/) — Salesforce Engineering blog post introducing HASSH
- [RFC 4253 — The Secure Shell (SSH) Transport Layer Protocol](https://www.rfc-editor.org/rfc/rfc4253) — defines the KEXINIT message and algorithm negotiation
- [Wireshark Lua API Reference](https://www.wireshark.org/docs/wsdg_html_chunked/wsluarm.html) — official documentation for the Wireshark Lua dissector API
- [0x4D31/hassh-utils](https://github.com/0x4D31/hassh-utils) — HASSH database and utilities for fingerprint lookup and analysis
- [flier/hassh-rs](https://github.com/flier/hassh-rs) — Rust implementation of HASSH

## License

BSD 3-Clause. See [LICENSE](LICENSE).

The bundled `lib/md5.lua` is MIT licensed ([kikito/md5.lua](https://github.com/kikito/md5.lua)).
