# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y authselect 2>/dev/null || true
    echo "TEARDOWN: removed authselect"
fi
echo ""
