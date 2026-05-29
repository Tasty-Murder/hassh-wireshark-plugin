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
