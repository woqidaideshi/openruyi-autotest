"""Generate functional coverage doc with case-level detail."""
import os, re, textwrap

BASE = 'tests/functional'
lines = []

# Header
lines.append('# 功能测试覆盖详情')
lines.append('')
lines.append('> 点击展开查看各软件包详情，每个用例下列出测试功能点')
lines.append('')

# Count totals
all_cases = []
for pkg in sorted(os.listdir(BASE)):
    pp = os.path.join(BASE, pkg)
    if not os.path.isdir(pp): continue
    cases = [d for d in sorted(os.listdir(pp)) if d.startswith('test_')]
    if cases:
        all_cases.extend(cases)

lines.append(f'共 **{len(set(os.path.dirname(os.path.join(BASE,d)) for d in os.listdir(BASE) if os.path.isdir(os.path.join(BASE,d)) and [x for x in os.listdir(os.path.join(BASE,d)) if x.startswith("test_")]))}** 个软件包，**{len(all_cases)}** 个测试用例')
lines.append('')

# TOC
lines.append('## 目录')
lines.append('')
for pkg in sorted(os.listdir(BASE)):
    pp = os.path.join(BASE, pkg)
    if not os.path.isdir(pp): continue
    cases = [d for d in sorted(os.listdir(pp)) if d.startswith('test_')]
    if not cases: continue
    lines.append(f'- [{pkg}](#{pkg}) ({len(cases)} cases)')

lines.append('')

# Detail per package
for pkg in sorted(os.listdir(BASE)):
    pp = os.path.join(BASE, pkg)
    if not os.path.isdir(pp): continue
    cases = sorted([d for d in os.listdir(pp) if d.startswith('test_')])
    if not cases: continue
    
    lines.append('---')
    lines.append(f'')
    lines.append(f'## {pkg}')
    lines.append(f'')
    lines.append(f'<details open>')
    lines.append(f'<summary><b>{pkg} — {len(cases)} 个测试用例</b></summary>')
    lines.append('')
    
    for case in cases:
        case_dir = os.path.join(pp, case)
        fmf_path = os.path.join(case_dir, 'main.fmf')
        
        # Read summary from main.fmf
        summary = case
        if os.path.isfile(fmf_path):
            with open(fmf_path, 'r', encoding='utf-8') as f:
                for line in f:
                    if line.startswith('summary:'):
                        summary = line.split(':', 1)[1].strip()
                        break
        
        # Read test points from test.sh
        test_path = os.path.join(case_dir, 'test.sh')
        test_points = []
        if os.path.isfile(test_path):
            with open(test_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Extract rlRun descriptions (Chinese test descriptors)
            descs = re.findall(r'rlRun\s+.*?\d+\s+"(.+?)"', content)
            if descs:
                # Filter meaningful descriptions (not temp dir, rpm check etc.)
                skip_patterns = ['是否已安装', '是否可用', '创建临时', '进入测试',
                               '创建测试文件', '创建测试目录', '获取.*版本',
                               'version', 'Version', 'mktemp', 'cd \\$', 'cd /',
                               'rpm -q', '哪些命令', 'which ', '--version',
                               '检查.*版本', '检查.*软件包']
                for d in descs:
                    if not any(p in d for p in skip_patterns):
                        test_points.append(d)
        
        lines.append(f'#### `{case}`')
        lines.append(f'')
        lines.append(f'> {summary}')
        lines.append('')
        
        if test_points:
            lines.append('**功能点：**')
            lines.append('')
            for tp in test_points[:25]:  # limit to 25 per case
                lines.append(f'- {tp}')
            if len(test_points) > 25:
                lines.append(f'- ... 等共 {len(test_points)} 个测试点')
            lines.append('')
        else:
            # Try echo sections as fallback
            if os.path.isfile(test_path):
                with open(test_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                sections = re.findall(r'echo\s+"=== (?:Test|测试)\s+\d+:?\s*(.+?)(?:\s*===)?"', content)
                if sections:
                    lines.append('**测试段：**')
                    for s in sections:
                        lines.append(f'- {s}')
                    lines.append('')
                else:
                    lines.append('基本功能验证')
                    lines.append('')
    
    lines.append(f'</details>')
    lines.append('')

with open('docs/functional-coverage.md', 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))

pkg_count = len(set(d for d in os.listdir(BASE) if os.path.isdir(os.path.join(BASE,d)) and [x for x in os.listdir(os.path.join(BASE,d)) if x.startswith('test_')]))
print(f'Generated: {pkg_count} packages, {len(all_cases)} cases')
