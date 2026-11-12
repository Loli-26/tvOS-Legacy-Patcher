
# tvOS Legacy Patcher (tvLP)

An open-source, **jailbreak-free** patcher framework designed to bring modern **tvOS** releases to dropped **Apple TV HD (`AppleTV5,3` / A8)** and **Apple TV 4K 1st Gen (`AppleTV6,2` / A10X)** hardware using untethered custom IPSW root patching, DeviceTree Board-ID spoofing (`AppleTV14,1`), and legacy Metal GPU framework injection.

## Core Design Principles
- **No Jailbreak Tools Required:** Zero tethered `checkm8` boot loops, no DFU exploit dependencies after initial restore, and no third-party jailbreak package managers.
- **Untethered Cold Boot:** Board-ID spoofs and legacy A8/A10X graphics drivers are baked directly into the custom IPSW restore image.
- **QEMU ARM64 Validation:** Test patched kernelcaches and DeviceTrees safely on macOS before flashing hardware.

## Supported Targets
- **Apple TV HD (4th Gen):** `AppleTV5,3` (`j42dap` / Apple A8 / 2GB RAM)
- **Apple TV 4K (1st Gen):** `AppleTV6,2` (`j105aap` / Apple A10X / 3GB RAM)

## Quick Start
```bash
chmod +x tvlp.sh
./tvlp.sh
```
EOF

git add . && git commit -m "Refactor architecture: zero jailbreak tools required, untethered IPSW patching" 2>/dev/null
