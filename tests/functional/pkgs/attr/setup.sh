rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install attr ===
INSTALLED_BY_TEST=0
if ! rpm -q attr 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y attr 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed attr"
    else
        echo "SKIP: attr not available in repos"
        exit 0
    fi
else
    echo "SETUP: attr already installed"
fi


rlRun 'attr --version' 0 "��ȡ attr �汾��Ϣ"
rlRun 'getfattr --version' 0 "��ȡ getfattr �汾��Ϣ"
rlRun 'setfattr --version' 0 "��ȡ setfattr �汾��Ϣ"
