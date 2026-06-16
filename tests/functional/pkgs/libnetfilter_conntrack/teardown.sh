# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libnetfilter_conntrack 2>/dev/null || true
    echo "TEARDOWN: removed libnetfilter_conntrack"
fi
echo ""
