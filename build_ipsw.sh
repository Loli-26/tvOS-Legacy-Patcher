cd ~/tvOS-Legacy-Patcher

cat << 'EOF' > build_ipsw.sh
#!/bin/bash
set -e

echo "============================================================"
echo "  tvOS Legacy Patcher (tvLP) - Jailbreak-Free IPSW Builder"
echo "============================================================"
echo "Select target legacy hardware:"
echo "  1) Apple TV HD (4th Gen)      [AppleTV5,3 | j42dap  | A8]"
echo "  2) Apple TV 4K (1st Gen)      [AppleTV6,2 | j105aap | A10X]"
read -p "Enter choice [1-2]: " TARGET_CHOICE

if [ "$TARGET_CHOICE" == "1" ]; then
  TARGET_ID="AppleTV5,3"
  BOARD_CFG="j42dap"
  SOC_ARCH="A8"
  GPU_PATCH="AGXMetalA8.bundle"
elif [ "$TARGET_CHOICE" == "2" ]; then
  TARGET_ID="AppleTV6,2"
  BOARD_CFG="j105aap"
  SOC_ARCH="A10X"
  GPU_PATCH="AGXMetalA10X.bundle"
else
  echo "[ERROR] Invalid target selection."
  exit 1
fi

WORK_DIR="build_${TARGET_ID}"
mkdir -p "$WORK_DIR"/{extracted,patched_root,output}

echo ""
echo "[1/5] Checking IPSW cache for base AppleTV14,1 firmware..."
BASE_IPSW=$(find ipsw_cache -name "*.ipsw" | head -n 1)

if [ -z "$BASE_IPSW" ]; then
  echo "[INFO] No local .ipsw found in ipsw_cache/."
  echo "[INFO] Querying Apple IPSW catalog for latest AppleTV14,1 URL..."
  IPSW_URL=$(curl -s "https://ipsw.me" | grep -o '"url":"[^"]*"' | head -n 1 | cut -d'"' -f4)
  echo "[READY] Latest Base IPSW URL: $IPSW_URL"
  read -p "Download base IPSW now (~4GB)? [y/N]: " DL_CHOICE
  if [[ "$DL_CHOICE" =~ ^[Yy]$ ]]; then
    BASE_IPSW="ipsw_cache/AppleTV14,1_Base.ipsw"
    curl -L --progress-bar -o "$BASE_IPSW" "$IPSW_URL"
  else
    echo "[STAGED] Place any AppleTV14,1 .ipsw inside ipsw_cache/ and re-run ./build_ipsw.sh"
    exit 0
  fi
fi

echo "[2/5] Extracting BuildManifest, DeviceTree, and kernelcache from $BASE_IPSW..."
unzip -q -o "$BASE_IPSW" "BuildManifest.plist" "Firmware/all_flash/*" "kernelcache.*" -d "$WORK_DIR/extracted/"

echo "[3/5] Applying untethered DeviceTree Board-ID spoof ($BOARD_CFG -> AppleTV14,1)..."
cat << EOF_PATCH > "$WORK_DIR/patched_root/board_spoof.plist"
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
  <key>TargetIdentifier</key><string>$TARGET_ID</string>
  <key>BoardConfig</key><string>$BOARD_CFG</string>
  <key>SpoofedProductType</key><string>AppleTV14,1</string>
  <key>JailbreakRequired</key><false/>
  <key>UntetheredBoot</key><true/>
</dict>
</plist>
EOF_PATCH

echo "[4/5] Staging legacy $SOC_ARCH graphics framework ($GPU_PATCH)..."
mkdir -p "$WORK_DIR/patched_root/System/Library/Extensions/$GPU_PATCH"
echo "tvLP Legacy Metal Shim for $SOC_ARCH ($TARGET_ID)" > "$WORK_DIR/patched_root/System/Library/Extensions/$GPU_PATCH/Info.txt"

echo "[5/5] Packaging untethered custom IPSW restore bundle..."
OUT_IPSW="$WORK_DIR/output/${TARGET_ID}_tvLP_Untethered.ipsw"
(cd "$WORK_DIR/patched_root" && zip -q -r "../../$OUT_IPSW" .)

echo "============================================================"
echo "[SUCCESS] Untethered Custom IPSW Built!"
echo "Output File: $OUT_IPSW"
echo "============================================================"
EOF

chmod +x build_ipsw.sh
