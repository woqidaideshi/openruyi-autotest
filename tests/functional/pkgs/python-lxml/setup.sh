rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install python-lxml ===
INSTALLED_BY_TEST=0
if ! rpm -q python-lxml 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y python-lxml 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed python-lxml"
    else
        echo "SKIP: python-lxml not available in repos"
        exit 0
    fi
else
    echo "SETUP: python-lxml already installed"
fi



echo "=== ���ļ���֤ ==="
