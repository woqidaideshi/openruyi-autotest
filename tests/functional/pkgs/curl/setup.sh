rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install curl ===
INSTALLED_BY_TEST=0
if ! rpm -q curl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y curl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed curl"
    else
        echo "SKIP: curl not available in repos"
        exit 0
    fi
else
    echo "SETUP: curl already installed"
fi



rlRun 'curl --version' 0 "curl 版本信息"
