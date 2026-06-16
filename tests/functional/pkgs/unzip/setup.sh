rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install unzip ===
INSTALLED_BY_TEST=0
if ! rpm -q unzip 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y unzip 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed unzip"
    else
        echo "SKIP: unzip not available in repos"
        exit 0
    fi
else
    echo "SETUP: unzip already installed"
fi



echo "=== ����: ������ ==="
