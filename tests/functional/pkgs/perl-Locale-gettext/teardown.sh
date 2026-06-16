# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y perl-Locale-gettext 2>/dev/null || true
    echo "TEARDOWN: removed perl-Locale-gettext"
fi
echo ""
