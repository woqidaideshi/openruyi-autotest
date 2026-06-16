rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install pkgconf ===
INSTALLED_BY_TEST=0
if ! rpm -q pkgconf 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y pkgconf 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed pkgconf"
    else
        echo "SKIP: pkgconf not available in repos"
        exit 0
    fi
else
    echo "SETUP: pkgconf already installed"
fi
