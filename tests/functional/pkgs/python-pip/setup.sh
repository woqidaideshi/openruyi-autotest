rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install python-pip ===
INSTALLED_BY_TEST=0
if ! rpm -q python-pip 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y python-pip 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed python-pip"
    else
        echo "SKIP: python-pip not available in repos"
        exit 0
    fi
else
    echo "SETUP: python-pip already installed"
fi



echo "=== pip �������� ==="
rlRun 'pip3 --help 2>&1 | head -15' 0 "pip ����"
