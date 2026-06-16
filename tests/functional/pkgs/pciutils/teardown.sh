# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y pciutils 2>/dev/null || true
    echo "TEARDOWN: removed pciutils"
fi
echo ""
echo "All pciutils functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
