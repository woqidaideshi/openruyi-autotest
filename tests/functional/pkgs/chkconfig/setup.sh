rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install chkconfig ===
INSTALLED_BY_TEST=0
if ! rpm -q chkconfig 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y chkconfig 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed chkconfig"
    else
        echo "SKIP: chkconfig not available in repos"
        exit 0
    fi
else
    echo "SETUP: chkconfig already installed"
fi



echo "=== alternatives �������� ==="
rlRun 'alternatives --help 2>&1 | head -10' 0 "�鿴����"
