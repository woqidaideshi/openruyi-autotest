rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install systemd-timesyncd ===
INSTALLED_BY_TEST=0
if ! rpm -q systemd-timesyncd 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y systemd-timesyncd 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed systemd-timesyncd"
    else
        echo "SKIP: systemd-timesyncd not available in repos"
        exit 0
    fi
else
    echo "SETUP: systemd-timesyncd already installed"
fi
