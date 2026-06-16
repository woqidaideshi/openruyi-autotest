rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libnftnl ===
INSTALLED_BY_TEST=0
if ! rpm -q libnftnl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libnftnl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libnftnl"
    else
        echo "SKIP: libnftnl not available in repos"
        exit 0
    fi
else
    echo "SETUP: libnftnl already installed"
fi



echo "=== ���ļ���֤ ==="
