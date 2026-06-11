"""Analyze all test scripts and generate coverage doc."""
import os, re, json

BASE = 'tests/functional'
results = {}

for d in sorted(os.listdir(BASE)):
    path = os.path.join(BASE, d, 'test.sh')
    if not os.path.isfile(path):
        continue
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract rlRun test descriptions
    points = re.findall(r'rlRun\s+.*?\d+\s+"(.+?)"', content)
    # Also find echo section headers
    sections = re.findall(r'echo\s+"=== Test \d+:\s*(.+?)"', content)
    # Count rlRun calls
    count = len(re.findall(r'rlRun\s+', content))
    results[d] = {'count': count, 'points': points, 'sections': sections}

for pkg, info in sorted(results.items()):
    print(f'{pkg}: {info["count"]} test points, {len(info["sections"])} sections')
    for s in info['sections']:
        print(f'  - {s}')
    pts = info['points']
    if pts:
        if len(pts) <= 10:
            for p in pts:
                print(f'    . {p}')
        else:
            for p in pts[:5]:
                print(f'    . {p}')
            print(f'    ... ({len(pts)-10} more)')
            for p in pts[-5:]:
                print(f'    . {p}')
    print()
