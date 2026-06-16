rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install lvm2 ===
INSTALLED_BY_TEST=0
if ! rpm -q lvm2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y lvm2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed lvm2"
    else
        echo "SKIP: lvm2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: lvm2 already installed"
fi



echo "=== LVM ���� ==="
