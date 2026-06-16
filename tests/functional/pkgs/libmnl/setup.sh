rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libmnl ===
INSTALLED_BY_TEST=0
if ! rpm -q libmnl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libmnl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libmnl"
    else
        echo "SKIP: libmnl not available in repos"
        exit 0
    fi
else
    echo "SETUP: libmnl already installed"
fi



echo "=== ���ļ���֤ ==="
