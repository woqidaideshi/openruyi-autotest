rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install lz4 ===
INSTALLED_BY_TEST=0
if ! rpm -q lz4 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y lz4 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed lz4"
    else
        echo "SKIP: lz4 not available in repos"
        exit 0
    fi
else
    echo "SETUP: lz4 already installed"
fi



echo "=== ����: ������ ==="
