rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install popt ===
INSTALLED_BY_TEST=0
if ! rpm -q popt 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y popt 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed popt"
    else
        echo "SKIP: popt not available in repos"
        exit 0
    fi
else
    echo "SETUP: popt already installed"
fi



echo "=== ���ļ���֤ ==="
