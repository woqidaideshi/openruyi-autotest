rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install zstd ===
INSTALLED_BY_TEST=0
if ! rpm -q zstd 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y zstd 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed zstd"
    else
        echo "SKIP: zstd not available in repos"
        exit 0
    fi
else
    echo "SETUP: zstd already installed"
fi
