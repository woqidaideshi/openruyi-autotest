rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install glibc ===
INSTALLED_BY_TEST=0
if ! rpm -q glibc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y glibc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed glibc"
    else
        echo "SKIP: glibc not available in repos"
        exit 0
    fi
else
    echo "SETUP: glibc already installed"
fi
