rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install json-c ===
INSTALLED_BY_TEST=0
if ! rpm -q json-c 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y json-c 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed json-c"
    else
        echo "SKIP: json-c not available in repos"
        exit 0
    fi
else
    echo "SETUP: json-c already installed"
fi



echo "=== ���ļ���֤ ==="
