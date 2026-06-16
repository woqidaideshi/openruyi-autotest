# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y pcre2 2>/dev/null || true
    echo "TEARDOWN: removed pcre2"
fi
echo ""
