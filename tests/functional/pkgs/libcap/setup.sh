rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libcap ===
INSTALLED_BY_TEST=0
if ! rpm -q libcap 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libcap 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libcap"
    else
        echo "SKIP: libcap not available in repos"
        exit 0
    fi
else
    echo "SETUP: libcap already installed"
fi



echo "=== ���ļ���֤ ==="
