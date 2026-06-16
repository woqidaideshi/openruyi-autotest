# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y p11-kit 2>/dev/null || true
    echo "TEARDOWN: removed p11-kit"
fi
echo ""
