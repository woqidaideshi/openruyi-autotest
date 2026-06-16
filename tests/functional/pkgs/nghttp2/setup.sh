rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install nghttp2 ===
INSTALLED_BY_TEST=0
if ! rpm -q nghttp2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y nghttp2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed nghttp2"
    else
        echo "SKIP: nghttp2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: nghttp2 already installed"
fi



echo "=== ���ļ���֤ ==="
