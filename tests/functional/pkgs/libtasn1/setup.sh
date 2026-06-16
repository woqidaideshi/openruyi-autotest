rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libtasn1 ===
INSTALLED_BY_TEST=0
if ! rpm -q libtasn1 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libtasn1 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libtasn1"
    else
        echo "SKIP: libtasn1 not available in repos"
        exit 0
    fi
else
    echo "SETUP: libtasn1 already installed"
fi



echo "=== ����: ������ ==="
