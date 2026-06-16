# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y file 2>/dev/null || true
    echo "TEARDOWN: removed file"
fi
echo ""
