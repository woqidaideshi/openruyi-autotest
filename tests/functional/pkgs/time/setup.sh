rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install time ===
INSTALLED_BY_TEST=0
if ! rpm -q time 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y time 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed time"
    else
        echo "SKIP: time not available in repos"
        exit 0
    fi
else
    echo "SETUP: time already installed"
fi



echo "=== ����: ������ ==="
