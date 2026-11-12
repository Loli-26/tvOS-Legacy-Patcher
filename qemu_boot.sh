cd ~/tvOS-Legacy-Patcher

cat << 'EOF' > qemu_boot.sh
#!/bin/bash
set -e

echo "============================================================"
echo "  tvOS Legacy Patcher (tvLP) - QEMU ARM64 Kernel Tester"
echo "============================================================"

if ! command -v qemu-system-aarch64 >/dev/null 2>&1; then
  echo "[MISSING] qemu-system-aarch64 not found on your Mac."
  echo "Install it via Homebrew: brew install qemu"
  exit 1
fi

echo "Select built target profile to boot in QEMU:"
echo "  1) Apple TV HD (4th Gen)      [AppleTV5,3 | 2GB RAM]"
echo "  2) Apple TV 4K (1st Gen)      [AppleTV6,2 | 3GB RAM]"
read -p "Enter choice [1-2]: " Q_CHOICE

if [ "$Q_CHOICE" == "1" ]; then
  TARGET_ID="AppleTV5,3"
  RAM_SIZE="2048M"
  CPU_MODEL="cortex-a57"
elif [ "$Q_CHOICE" == "2" ]; then
  TARGET_ID="AppleTV6,2"
  RAM_SIZE="3072M"
  CPU_MODEL="cortex-a72"
else
  echo "[ERROR] Invalid selection."
  exit 1
fi

WORK_DIR="build_${TARGET_ID}"
KERNEL_BIN=$(find "$WORK_DIR/extracted" -name "kernelcache.*" 2>/dev/null | head -n 1)
DTB_BIN=$(find "$WORK_DIR/extracted/Firmware/all_flash" -name "DeviceTree.*" 2>/dev/null | head -n 1)

if [ -z "$KERNEL_BIN" ]; then
  echo "[ERROR] No extracted kernelcache found in $WORK_DIR/extracted/."
  echo "Run ./build_ipsw.sh first to extract the base firmware."
  exit 1
fi

echo "[BOOTING] Launching $TARGET_ID in QEMU ($RAM_SIZE RAM | $CPU_MODEL)..."
echo "[INFO] Serial console output routed to Terminal (Press Ctrl+A then X to exit QEMU)."

qemu-system-aarch64 \
  -M virt,highmem=on \
  -cpu "$CPU_MODEL" \
  -m "$RAM_SIZE" \
  -kernel "$KERNEL_BIN" \
  ${DTB_BIN:+-dtb "$DTB_BIN"} \
  -append "debug=0x14e serial=3 rd=md0 -v" \
  -serial mon:stdio \
  -display cocoa \
  -device virtio-gpu-pci \
  -netdev user,id=net0 \
  -device virtio-net-pci,netdev=net0
EOF

chmod +x qemu_boot.sh
