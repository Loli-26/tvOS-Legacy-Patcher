cd ~/tvOS-Legacy-Patcher

cat << 'EOF' > deploy_tvos.sh
#!/bin/bash
set -e

echo "============================================================"
echo "  tvOS Legacy Patcher (tvLP) - Jailbreak-Free Deploy & Flash"
echo "============================================================"
echo "Select target Apple TV hardware:"
echo "  1) Apple TV HD (4th Gen)      [AppleTV5,3 | USB-C Connection]"
echo "  2) Apple TV 4K (1st Gen)      [AppleTV6,2 | Wireless / Network Pair]"
read -p "Enter choice [1-2]: " DEV_CHOICE

if [ "$DEV_CHOICE" == "1" ]; then
  TARGET_ID="AppleTV5,3"
  CONN_MODE="USB-C"
elif [ "$DEV_CHOICE" == "2" ]; then
  TARGET_ID="AppleTV6,2"
  CONN_MODE="Wireless Network (Xcode / Apple Configurator)"
else
  echo "[ERROR] Invalid selection."
  exit 1
fi

CUSTOM_IPSW="build_${TARGET_ID}/output/${TARGET_ID}_tvLP_Untethered.ipsw"

if [ ! -f "$CUSTOM_IPSW" ]; then
  echo "[MISSING] Built IPSW not found at: $CUSTOM_IPSW"
  echo "Run ./build_ipsw.sh first to generate the untethered restore bundle."
  exit 1
fi

echo ""
echo "[TARGET] $TARGET_ID ($CONN_MODE)"
echo "[BUNDLE] $CUSTOM_IPSW"
echo ""
echo "Choose deployment method:"
echo "  1) Automated CLI Flash via Apple Configurator (cfgutil)"
echo "  2) Automated Wireless/USB Push via Xcode devicectl"
echo "  3) Launch macOS Finder / Apple Configurator GUI Restore"
read -p "Enter deployment option [1-3]: " DEPLOY_OPT

case $DEPLOY_OPT in
  1)
    if command -v cfgutil >/dev/null 2>&1; then
      echo "[FLASHING] Pushing $CUSTOM_IPSW via Apple Configurator CLI..."
      cfgutil restore -I "$CUSTOM_IPSW"
    else
      echo "[MISSING] cfgutil not found. Open Apple Configurator > Install Automation Tools first."
    fi
    ;;
  2)
    if xcrun --find devicectl >/dev/null 2>&1; then
      echo "[SCANNING] Checking paired Apple TV devices..."
      xcrun devicectl list devices
      read -p "Paste Target Device Identifier (UUID): " DEV_UUID
      xcrun devicectl device install app --device "$DEV_UUID" "$CUSTOM_IPSW"
    else
      echo "[MISSING] Xcode devicectl not found. Install Xcode Command Line Tools."
    fi
    ;;
  3)
    echo "[LAUNCHING] Opening Apple Configurator / Finder restore target..."
    open -a "Apple Configurator" 2>/dev/null || open /System/Library/CoreServices/Finder.app
    echo "[GUIDE] Select your Apple TV, hold Option (⌥) + Click 'Restore Apple TV...', and pick:"
    echo "        $(pwd)/$CUSTOM_IPSW"
    ;;
  *)
    echo "[ERROR] Invalid deployment option."
    exit 1
    ;;
esac
EOF

chmod +x deploy_tvos.sh
