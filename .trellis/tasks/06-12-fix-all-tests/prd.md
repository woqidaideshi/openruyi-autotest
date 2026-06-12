# 修复失败用例并添加 setup/teardown 机制

## 目标

1. 修复所有 33 个失败和 33 个跳过的测试用例
2. 为所有 779 个测试脚本添加统一的 setup/teardown 机制

## Setup/Teardown 规范

### Setup
```bash
# 检查软件包是否安装，未安装则尝试安装
INSTALLED_BY_TEST=0
if ! rpm -q PKG 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y PKG 2>/dev/null; then
        INSTALLED_BY_TEST=1
    else
        echo "SKIP: PKG not available"
        exit 0
    fi
fi
```

### Teardown
```bash
# 如果 setup 安装了包，则卸载
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y PKG 2>/dev/null || true
fi
```

## 执行策略

批量自动重写所有 test.sh，统一注入 setup/teardown。
