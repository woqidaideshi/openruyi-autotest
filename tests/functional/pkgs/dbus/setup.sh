rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install dbus ===
INSTALLED_BY_TEST=0
if ! rpm -q dbus 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y dbus 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed dbus"
    else
        echo "SKIP: dbus not available in repos"
        exit 0
    fi
else
    echo "SETUP: dbus already installed"
fi
