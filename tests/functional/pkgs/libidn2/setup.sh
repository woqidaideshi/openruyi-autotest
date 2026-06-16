rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libidn2 ===
INSTALLED_BY_TEST=0
if ! rpm -q libidn2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libidn2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libidn2"
    else
        echo "SKIP: libidn2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: libidn2 already installed"
fi



echo "=== ����: ������ ==="
