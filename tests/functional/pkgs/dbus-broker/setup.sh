rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install dbus-broker ===
INSTALLED_BY_TEST=0
if ! rpm -q dbus-broker 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y dbus-broker 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed dbus-broker"
    else
        echo "SKIP: dbus-broker not available in repos"
        exit 0
    fi
else
    echo "SETUP: dbus-broker already installed"
fi



echo "=== ����: ������ ==="
