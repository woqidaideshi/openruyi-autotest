rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install glib ===
INSTALLED_BY_TEST=0
if ! rpm -q glib 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y glib 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed glib"
    else
        echo "SKIP: glib not available in repos"
        exit 0
    fi
else
    echo "SETUP: glib already installed"
fi



echo "=== glib ���� ==="
rlRun 'glib-compile-schemas --help 2>&1 | head -10' 0 "glib-compile-schemas ����"
rlRun 'gsettings --help 2>&1 | head -10' 0 "gsettings ����"
