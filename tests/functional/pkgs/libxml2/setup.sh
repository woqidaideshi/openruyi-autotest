rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libxml2 ===
INSTALLED_BY_TEST=0
if ! rpm -q libxml2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libxml2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libxml2"
    else
        echo "SKIP: libxml2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: libxml2 already installed"
fi



echo "=== ����: ������ ==="
