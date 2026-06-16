rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libxcrypt ===
INSTALLED_BY_TEST=0
if ! rpm -q libxcrypt 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libxcrypt 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libxcrypt"
    else
        echo "SKIP: libxcrypt not available in repos"
        exit 0
    fi
else
    echo "SETUP: libxcrypt already installed"
fi



echo "=== ���ļ���֤ ==="
