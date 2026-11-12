cd ~/tvOS-Legacy-Patcher

cat << 'EOF' > CHANGELOG.md
# Changelog

All notable changes to **tvOS Legacy Patcher (tvLP)** are documented in this file.

## [v1.0.0] - 2026-11-11
### Added
- **Unified Jailbreak-Free Patcher Suite:** Bundled `tvlp.sh`, `build_ipsw.sh`, `qemu_boot.sh`, hardware profiles (`AppleTV5,3` & `AppleTV6,2`), and full documentation into a single release.
- **Untethered IPSW Root Patcher (`build_ipsw.sh`):** Automated `AppleTV14,1` firmware fetching, DeviceTree Board-ID spoofing (`j42dap` & `j105aap`), and legacy `AGXMetalA8` / `AGXMetalA10X` framework staging with zero jailbreak tools required.
- **QEMU ARM64 Kernel Tester (`qemu_boot.sh`):** Added virtualized `cortex-a57` (2GB RAM) and `cortex-a72` (3GB RAM) test runners with verbose serial logging (`debug=0x14e serial=3 -v`).
- **Complete Project Manual (`README.md`):** Added supported hardware matrix, quick-start instructions, and Finder / Apple Configurator restore steps.
EOF

