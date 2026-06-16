rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install less ===
INSTALLED_BY_TEST=0
if ! rpm -q less 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y less 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed less"
    else
        echo "SKIP: less not available in repos"
        exit 0
    fi
else
    echo "SETUP: less already installed"
fi



echo "=== ����: ������ ==="
