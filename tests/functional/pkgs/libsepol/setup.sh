rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libsepol ===
INSTALLED_BY_TEST=0
if ! rpm -q libsepol 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libsepol 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libsepol"
    else
        echo "SKIP: libsepol not available in repos"
        exit 0
    fi
else
    echo "SETUP: libsepol already installed"
fi



echo "=== ���ļ���֤ ==="
