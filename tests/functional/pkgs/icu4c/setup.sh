rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install icu4c ===
INSTALLED_BY_TEST=0
if ! rpm -q icu4c 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y icu4c 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed icu4c"
    else
        echo "SKIP: icu4c not available in repos"
        exit 0
    fi
else
    echo "SETUP: icu4c already installed"
fi



echo "=== ICU ���� ==="
rlRun 'icuinfo --help 2>&1 | head -10' 0 "icuinfo ����"
rlRun 'uconv --help 2>&1 | head -10' 0 "uconv ����"
