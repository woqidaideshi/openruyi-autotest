rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libnfnetlink ===
INSTALLED_BY_TEST=0
if ! rpm -q libnfnetlink 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libnfnetlink 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libnfnetlink"
    else
        echo "SKIP: libnfnetlink not available in repos"
        exit 0
    fi
else
    echo "SETUP: libnfnetlink already installed"
fi



echo "=== ���ļ���֤ ==="
