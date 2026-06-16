rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install tcsh ===
INSTALLED_BY_TEST=0
if ! rpm -q tcsh 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y tcsh 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed tcsh"
    else
        echo "SKIP: tcsh not available in repos"
        exit 0
    fi
else
    echo "SETUP: tcsh already installed"
fi



echo "=== ����: ������ ==="
