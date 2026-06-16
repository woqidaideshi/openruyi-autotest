rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libffi ===
INSTALLED_BY_TEST=0
if ! rpm -q libffi 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libffi 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libffi"
    else
        echo "SKIP: libffi not available in repos"
        exit 0
    fi
else
    echo "SETUP: libffi already installed"
fi



echo "=== ���ļ���֤ ==="
