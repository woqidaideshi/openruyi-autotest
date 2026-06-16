rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libarchive ===
INSTALLED_BY_TEST=0
if ! rpm -q libarchive 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libarchive 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libarchive"
    else
        echo "SKIP: libarchive not available in repos"
        exit 0
    fi
else
    echo "SETUP: libarchive already installed"
fi



echo "=== ���ļ���֤ ==="
