rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libgcrypt ===
INSTALLED_BY_TEST=0
if ! rpm -q libgcrypt 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libgcrypt 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libgcrypt"
    else
        echo "SKIP: libgcrypt not available in repos"
        exit 0
    fi
else
    echo "SETUP: libgcrypt already installed"
fi



echo "=== ���ļ���֤ ==="
