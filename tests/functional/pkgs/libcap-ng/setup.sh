rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libcap-ng ===
INSTALLED_BY_TEST=0
if ! rpm -q libcap-ng 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libcap-ng 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libcap-ng"
    else
        echo "SKIP: libcap-ng not available in repos"
        exit 0
    fi
else
    echo "SETUP: libcap-ng already installed"
fi



echo "=== ���ļ���֤ ==="
