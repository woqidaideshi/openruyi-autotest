rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install readline ===
INSTALLED_BY_TEST=0
if ! rpm -q readline 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y readline 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed readline"
    else
        echo "SKIP: readline not available in repos"
        exit 0
    fi
else
    echo "SETUP: readline already installed"
fi



echo "=== ���ļ���֤ ==="
