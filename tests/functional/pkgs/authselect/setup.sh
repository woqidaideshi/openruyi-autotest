rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install authselect ===
INSTALLED_BY_TEST=0
if ! rpm -q authselect 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y authselect 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed authselect"
    else
        echo "SKIP: authselect not available in repos"
        exit 0
    fi
else
    echo "SETUP: authselect already installed"
fi



echo "=== authselect �������� ==="
rlRun 'authselect --help 2>&1 | head -20' 0 "�鿴������Ϣ"
