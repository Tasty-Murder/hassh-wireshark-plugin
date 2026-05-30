## [0.1.4] - 2026-05-29

### 🐛 Bug Fixes

- Revert allfields=true from register_postdissector
## [0.1.3] - 2026-05-29

### 🐛 Bug Fixes

- Pass allfields=true to register_postdissector to populate custom columns
## [0.1.2] - 2026-05-29

### 🐛 Bug Fixes

- Correct Wireshark field names for port direction in README
## [0.1.1] - 2026-05-29

### 🐛 Bug Fixes

- Correct native Wireshark HASSH field names in README
- *(ci)* Remove GITHUB_REPO from git-cliff-action to fix 403 on private repo

### ⚙️ Miscellaneous Tasks

- Add GitHub Actions release workflow
- Ignore CLAUDE.local.md
## [0.1.0] - 2026-05-29

### 🚀 Features

- Bundle kikito/md5.lua pure-Lua MD5 library
- Implement hassh.lua post-dissector for HASSH SSH fingerprinting
- Add install/uninstall scripts for Linux, macOS, and Windows

### 🐛 Bug Fixes

- Set executable bit on shell scripts, expand .gitignore
- Log pcall errors in hassh dissector instead of silently discarding
- Improve install/uninstall script robustness
- Improve README accuracy and completeness

### 📚 Documentation

- Add README and Wireshark colorfilters for HASSH plugin

### ⚙️ Miscellaneous Tasks

- Initial project skeleton for hassh-wireshark-plugin
