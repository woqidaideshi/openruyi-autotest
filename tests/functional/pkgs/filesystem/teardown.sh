# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y filesystem 2>/dev/null || true
    echo "TEARDOWN: removed filesystem"
fi
echo ""
