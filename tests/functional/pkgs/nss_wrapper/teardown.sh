# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nss_wrapper 2>/dev/null || true
    echo "TEARDOWN: removed nss_wrapper"
fi
echo ""
