# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y cpio 2>/dev/null || true
    echo "TEARDOWN: removed cpio"
fi
echo ""
