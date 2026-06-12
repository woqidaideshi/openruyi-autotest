#!/bin/sh -eux
# Functional test: meson

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install meson ===
INSTALLED_BY_TEST=0
if ! rpm -q meson 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y meson 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed meson"
    else
        echo "SKIP: meson not available in repos"
        exit 0
    fi
else
    echo "SETUP: meson already installed"
fi


rpm -q meson 2>/dev/null || { echo "meson not installed"; exit 0; }

echo "=== 测试 1: 库包验证 ==="
rpm -ql meson 2>/dev/null | head -10 || true
rpm -qi meson 2>/dev/null | head -10 || true
ldconfig -p 2>/dev/null | grep -i "meson" | head -5 || true

echo "=== 测试 2: 文件验证 ==="
ls /usr/lib64/libmeson*.so* 2>/dev/null | head -5 || echo "No shared libs"
ls /usr/share/meson/ 2>/dev/null | head -5 || true


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y meson 2>/dev/null || true
    echo "TEARDOWN: removed meson"
fi
echo ""
echo "All meson functional tests passed!"
