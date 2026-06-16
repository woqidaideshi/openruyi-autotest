rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libseccomp ===
INSTALLED_BY_TEST=0
if ! rpm -q libseccomp 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libseccomp 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libseccomp"
    else
        echo "SKIP: libseccomp not available in repos"
        exit 0
    fi
else
    echo "SETUP: libseccomp already installed"
fi



echo "=== ���ļ���֤ ==="
