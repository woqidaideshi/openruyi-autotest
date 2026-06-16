rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install iproute2 ===
INSTALLED_BY_TEST=0
if ! rpm -q iproute2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y iproute2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed iproute2"
    else
        echo "SKIP: iproute2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: iproute2 already installed"
fi



echo "=== ip ���� ==="
rlRun 'ip --help 2>&1 | head -10' 0 "ip ����"
