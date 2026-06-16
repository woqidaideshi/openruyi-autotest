rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install rpm-config-openruyi ===
INSTALLED_BY_TEST=0
if ! rpm -q rpm-config-openruyi 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y rpm-config-openruyi 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed rpm-config-openruyi"
    else
        echo "SKIP: rpm-config-openruyi not available in repos"
        exit 0
    fi
else
    echo "SETUP: rpm-config-openruyi already installed"
fi
