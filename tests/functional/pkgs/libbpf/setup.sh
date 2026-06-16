rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libbpf ===
INSTALLED_BY_TEST=0
if ! rpm -q libbpf 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libbpf 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libbpf"
    else
        echo "SKIP: libbpf not available in repos"
        exit 0
    fi
else
    echo "SETUP: libbpf already installed"
fi



echo "=== ���ļ���֤ ==="
