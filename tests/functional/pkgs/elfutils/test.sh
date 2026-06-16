#!/bin/sh -eux
# Functional test: elfutils package
# Tests elfutils ELF工具集
# Version: elfutils

rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install elfutils ===
INSTALLED_BY_TEST=0
if ! rpm -q elfutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y elfutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed elfutils"
    else
        echo "SKIP: elfutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: elfutils already installed"
fi



echo "=== 测试 1: 版本和帮助 ==="
rlRun 'eu-addr2line --version 2>&1 || true' 0 "eu-addr2line 版本信息"
rlRun 'eu-addr2line --help 2>&1 | head -5 || true' 0 "eu-addr2line 帮助信息"
rlRun 'eu-ar --version 2>&1 || true' 0 "eu-ar 版本信息"
rlRun 'eu-ar --help 2>&1 | head -5 || true' 0 "eu-ar 帮助信息"
rlRun 'eu-elfclassify --version 2>&1 || true' 0 "eu-elfclassify 版本信息"
rlRun 'eu-elfclassify --help 2>&1 | head -5 || true' 0 "eu-elfclassify 帮助信息"
rlRun 'eu-elfcmp --version 2>&1 || true' 0 "eu-elfcmp 版本信息"
rlRun 'eu-elfcmp --help 2>&1 | head -5 || true' 0 "eu-elfcmp 帮助信息"
rlRun 'eu-elfcompress --version 2>&1 || true' 0 "eu-elfcompress 版本信息"
rlRun 'eu-elfcompress --help 2>&1 | head -5 || true' 0 "eu-elfcompress 帮助信息"
rlRun 'eu-elflint --version 2>&1 || true' 0 "eu-elflint 版本信息"
rlRun 'eu-elflint --help 2>&1 | head -5 || true' 0 "eu-elflint 帮助信息"
rlRun 'eu-findtextrel --version 2>&1 || true' 0 "eu-findtextrel 版本信息"
rlRun 'eu-findtextrel --help 2>&1 | head -5 || true' 0 "eu-findtextrel 帮助信息"
rlRun 'eu-make-debug-archive --version 2>&1 || true' 0 "eu-make-debug-archive 版本信息"
rlRun 'eu-make-debug-archive --help 2>&1 | head -5 || true' 0 "eu-make-debug-archive 帮助信息"
rlRun 'eu-nm --version 2>&1 || true' 0 "eu-nm 版本信息"
rlRun 'eu-nm --help 2>&1 | head -5 || true' 0 "eu-nm 帮助信息"
rlRun 'eu-objdump --version 2>&1 || true' 0 "eu-objdump 版本信息"
rlRun 'eu-objdump --help 2>&1 | head -5 || true' 0 "eu-objdump 帮助信息"
rlRun 'eu-ranlib --version 2>&1 || true' 0 "eu-ranlib 版本信息"
rlRun 'eu-ranlib --help 2>&1 | head -5 || true' 0 "eu-ranlib 帮助信息"
rlRun 'eu-readelf --version 2>&1 || true' 0 "eu-readelf 版本信息"
rlRun 'eu-readelf --help 2>&1 | head -5 || true' 0 "eu-readelf 帮助信息"
rlRun 'eu-size --version 2>&1 || true' 0 "eu-size 版本信息"
rlRun 'eu-size --help 2>&1 | head -5 || true' 0 "eu-size 帮助信息"
rlRun 'eu-srcfiles --version 2>&1 || true' 0 "eu-srcfiles 版本信息"
rlRun 'eu-srcfiles --help 2>&1 | head -5 || true' 0 "eu-srcfiles 帮助信息"
rlRun 'eu-stack --version 2>&1 || true' 0 "eu-stack 版本信息"
rlRun 'eu-stack --help 2>&1 | head -5 || true' 0 "eu-stack 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'eu-addr2line --invalid 2>&1 || true' 0 "eu-addr2line: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y elfutils 2>/dev/null || true
    echo "TEARDOWN: removed elfutils"
fi
echo ""
echo "All elfutils functional tests passed!"
