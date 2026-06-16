rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install diffutils ===
INSTALLED_BY_TEST=0
if ! rpm -q diffutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y diffutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed diffutils"
    else
        echo "SKIP: diffutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: diffutils already installed"
fi



echo "=== ����: ������ ==="
