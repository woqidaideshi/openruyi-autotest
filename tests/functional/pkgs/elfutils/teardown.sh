# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y elfutils 2>/dev/null || true
    echo "TEARDOWN: removed elfutils"
fi
echo ""
