rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libtirpc ===
INSTALLED_BY_TEST=0
if ! rpm -q libtirpc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libtirpc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libtirpc"
    else
        echo "SKIP: libtirpc not available in repos"
        exit 0
    fi
else
    echo "SETUP: libtirpc already installed"
fi



echo "=== ���ļ���֤ ==="
