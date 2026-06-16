rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libpsl ===
INSTALLED_BY_TEST=0
if ! rpm -q libpsl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libpsl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libpsl"
    else
        echo "SKIP: libpsl not available in repos"
        exit 0
    fi
else
    echo "SETUP: libpsl already installed"
fi



echo "=== ���ļ���֤ ==="
