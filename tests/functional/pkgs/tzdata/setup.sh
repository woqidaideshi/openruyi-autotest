rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install tzdata ===
INSTALLED_BY_TEST=0
if ! rpm -q tzdata 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y tzdata 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed tzdata"
    else
        echo "SKIP: tzdata not available in repos"
        exit 0
    fi
else
    echo "SETUP: tzdata already installed"
fi



echo "=== ����: ������ ==="
