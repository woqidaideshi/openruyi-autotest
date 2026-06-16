# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nss 2>/dev/null || true
    echo "TEARDOWN: removed nss"
fi
echo ""
