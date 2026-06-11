"""Generate functional coverage doc from test scripts."""
import os, re

BASE = 'tests/functional'

packages = []
for d in sorted(os.listdir(BASE)):
    path = os.path.join(BASE, d, 'test.sh')
    if not os.path.isfile(path):
        continue
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract test points
    points = re.findall(r'rlRun\s+.*?\d+\s+"(.+?)"', content)
    sections = re.findall(r'echo\s+"=== Test \d+:\s*(.+?)"', content)
    count = len(re.findall(r'rlRun\s+', content))
    
    # Get commands info - fix regex to not capture trailing quotes
    cmds_covered = re.findall(r'which\s+(\S+)', content)
    cmds_covered = [c.strip("'\"") for c in cmds_covered if c]
    
    # For non-rlRun tests, count echo "Test" sections and direct command calls
    if count == 0:
        count = len(re.findall(r'echo\s+"=== Test\b', content))
        if count == 0:
            count = len(points) if points else len(content.split('\n')) // 10  # rough estimate
    if not points:
        points = [f'Test section: {s}' for s in sections] if sections else ['Functional verification']
    ver_match = re.search(r'# Version:\s*(.+)', content)
    version = ver_match.group(1) if ver_match else ''
    
    packages.append({
        'name': d,
        'version': version,
        'count': count,
        'commands': cmds_covered,
        'sections': sections,
        'points': points
    })

# Generate markdown
lines = []
lines.append('# 功能测试覆盖详情')
lines.append('')
lines.append(f'> 共 **{len(packages)}** 个软件包，**{sum(p["count"] for p in packages)}** 个测试点')
lines.append('> 点击展开查看各软件包详情')
lines.append('')

# Table of contents
lines.append('## 目录')
lines.append('')
lines.append('| 软件包 | 测试点 | 版本 |')
lines.append('|--------|:-----:|------|')
for p in packages:
    lines.append(f'| [{p["name"]}](#{p["name"].replace("+","")}) | {p["count"]} | {p["version"]} |')
lines.append('')

# Detail sections
for p in packages:
    lines.append(f'---')
    lines.append(f'')
    lines.append(f'## {p["name"]}')
    lines.append(f'')
    lines.append(f'- **版本**: {p["version"]}')
    lines.append(f'- **测试点**: {p["count"]}')
    if p['commands']:
        lines.append(f'- **被测命令**: {", ".join(f"`{c}`" for c in p["commands"])}')
    lines.append('')
    
    if p['sections']:
        for i, sec in enumerate(p['sections']):
            # Find points for this section
            lines.append(f'<details>')
            lines.append(f'<summary><b>{sec}</b></summary>')
            lines.append('')
            # Get a subset of points for this section
            start_idx = i * 10
            end_idx = start_idx + 10
            sec_points = p['points'][start_idx:end_idx]
            if sec_points:
                for pt in sec_points:
                    lines.append(f'- {pt}')
            else:
                lines.append('- 执行相关功能验证')
            lines.append('')
            lines.append(f'</details>')
            lines.append('')
    else:
        lines.append('<details>')
        lines.append('<summary><b>测试点列表</b></summary>')
        lines.append('')
        for pt in p['points']:
            lines.append(f'- {pt}')
        lines.append('')
        lines.append('</details>')
    lines.append('')

with open('docs/functional-coverage.md', 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))

print(f'Generated docs/functional-coverage.md with {len(packages)} packages')
