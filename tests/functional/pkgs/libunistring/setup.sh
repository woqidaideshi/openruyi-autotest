rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libunistring ===
INSTALLED_BY_TEST=0
if ! rpm -q libunistring 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libunistring 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libunistring"
    else
        echo "SKIP: libunistring not available in repos"
        exit 0
    fi
else
    echo "SETUP: libunistring already installed"
fi



echo "=== ���ļ���֤ ==="
