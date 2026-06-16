rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install patch ===
INSTALLED_BY_TEST=0
if ! rpm -q patch 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y patch 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed patch"
    else
        echo "SKIP: patch not available in repos"
        exit 0
    fi
else
    echo "SETUP: patch already installed"
fi



echo "=== ����: ������ ==="
