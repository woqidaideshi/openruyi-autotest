# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libgpg-error 2>/dev/null || true
    echo "TEARDOWN: removed libgpg-error"
fi
echo ""
