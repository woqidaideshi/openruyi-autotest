rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install gawk ===
INSTALLED_BY_TEST=0
if ! rpm -q gawk 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gawk 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gawk"
    else
        echo "SKIP: gawk not available in repos"
        exit 0
    fi
else
    echo "SETUP: gawk already installed"
fi



echo "=== ����: ������ ==="
