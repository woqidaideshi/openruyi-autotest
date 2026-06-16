# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y lz4 2>/dev/null || true
    echo "TEARDOWN: removed lz4"
fi
echo ""
