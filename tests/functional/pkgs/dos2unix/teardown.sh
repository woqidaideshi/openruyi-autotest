# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y dos2unix 2>/dev/null || true
    echo "TEARDOWN: removed dos2unix"
fi
echo ""
