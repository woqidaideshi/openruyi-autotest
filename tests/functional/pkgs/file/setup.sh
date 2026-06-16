rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install file ===
INSTALLED_BY_TEST=0
if ! rpm -q file 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y file 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed file"
    else
        echo "SKIP: file not available in repos"
        exit 0
    fi
else
    echo "SETUP: file already installed"
fi



echo "=== ����: ������ ==="
