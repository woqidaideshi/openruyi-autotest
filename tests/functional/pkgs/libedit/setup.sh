rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libedit ===
INSTALLED_BY_TEST=0
if ! rpm -q libedit 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libedit 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libedit"
    else
        echo "SKIP: libedit not available in repos"
        exit 0
    fi
else
    echo "SETUP: libedit already installed"
fi



echo "=== ���ļ���֤ ==="
