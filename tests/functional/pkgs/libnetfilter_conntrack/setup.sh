rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libnetfilter_conntrack ===
INSTALLED_BY_TEST=0
if ! rpm -q libnetfilter_conntrack 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libnetfilter_conntrack 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libnetfilter_conntrack"
    else
        echo "SKIP: libnetfilter_conntrack not available in repos"
        exit 0
    fi
else
    echo "SETUP: libnetfilter_conntrack already installed"
fi



echo "=== ���ļ���֤ ==="
