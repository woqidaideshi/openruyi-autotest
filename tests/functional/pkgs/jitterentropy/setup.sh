rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install jitterentropy ===
INSTALLED_BY_TEST=0
if ! rpm -q jitterentropy 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y jitterentropy 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed jitterentropy"
    else
        echo "SKIP: jitterentropy not available in repos"
        exit 0
    fi
else
    echo "SETUP: jitterentropy already installed"
fi



echo "=== ���ļ���֤ ==="
