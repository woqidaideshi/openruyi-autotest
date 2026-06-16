# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y ca-certificates-mozilla 2>/dev/null || true
    echo "TEARDOWN: removed ca-certificates-mozilla"
fi
echo ""
