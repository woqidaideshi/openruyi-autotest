#!/bin/sh -eux
# 冒烟测试: 验证 tmt 帮助信息

tmp=$(mktemp)
tmt --help > "$tmp"
grep -C3 'Test Management Tool' "$tmp"
rm "$tmp"

echo "冒烟测试通过!"