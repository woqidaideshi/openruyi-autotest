rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install cloud-utils-growpart ===
INSTALLED_BY_TEST=0
if ! rpm -q cloud-utils-growpart 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y cloud-utils-growpart 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed cloud-utils-growpart"
    else
        echo "SKIP: cloud-utils-growpart not available in repos"
        exit 0
    fi
else
    echo "SETUP: cloud-utils-growpart already installed"
fi
