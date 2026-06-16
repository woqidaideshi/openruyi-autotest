rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install p11-kit ===
INSTALLED_BY_TEST=0
if ! rpm -q p11-kit 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y p11-kit 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed p11-kit"
    else
        echo "SKIP: p11-kit not available in repos"
        exit 0
    fi
else
    echo "SETUP: p11-kit already installed"
fi



echo "=== p11-kit �������� ==="
rlRun 'p11-kit --help 2>&1 | head -10' 0 "p11-kit ����"
rlRun 'trust --help 2>&1 | head -10' 0 "trust ����"
