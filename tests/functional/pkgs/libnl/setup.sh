rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libnl ===
INSTALLED_BY_TEST=0
if ! rpm -q libnl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libnl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libnl"
    else
        echo "SKIP: libnl not available in repos"
        exit 0
    fi
else
    echo "SETUP: libnl already installed"
fi



echo "=== ���ļ���֤ ==="
