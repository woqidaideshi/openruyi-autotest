rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libevent ===
INSTALLED_BY_TEST=0
if ! rpm -q libevent 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libevent 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libevent"
    else
        echo "SKIP: libevent not available in repos"
        exit 0
    fi
else
    echo "SETUP: libevent already installed"
fi



echo "=== ���ļ���֤ ==="
