# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y re2c 2>/dev/null || true
    echo "TEARDOWN: removed re2c"
fi
echo ""
