rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libpwquality ===
INSTALLED_BY_TEST=0
if ! rpm -q libpwquality 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libpwquality 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libpwquality"
    else
        echo "SKIP: libpwquality not available in repos"
        exit 0
    fi
else
    echo "SETUP: libpwquality already installed"
fi



echo "=== ����: ������ ==="
