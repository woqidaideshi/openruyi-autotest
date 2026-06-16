rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install pcre2 ===
INSTALLED_BY_TEST=0
if ! rpm -q pcre2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y pcre2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed pcre2"
    else
        echo "SKIP: pcre2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: pcre2 already installed"
fi



echo "=== ����: ������ ==="
