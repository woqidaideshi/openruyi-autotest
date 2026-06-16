# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gcc16 2>/dev/null || true
    echo "TEARDOWN: removed gcc16"
fi
echo ""
