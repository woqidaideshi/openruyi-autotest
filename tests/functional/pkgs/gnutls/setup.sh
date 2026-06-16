rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install gnutls ===
INSTALLED_BY_TEST=0
if ! rpm -q gnutls 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gnutls 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gnutls"
    else
        echo "SKIP: gnutls not available in repos"
        exit 0
    fi
else
    echo "SETUP: gnutls already installed"
fi
