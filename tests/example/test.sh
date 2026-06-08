#!/bin/sh -eux
# 示例测试: 参考模板 - 验证 tmt 帮助信息

tmp=$(mktemp)
tmt --help > "$tmp"
grep -C3 'Test Management Tool' "$tmp"
rm "$tmp"

echo "示例测试通过!"