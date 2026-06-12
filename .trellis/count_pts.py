import os, re
total = 0
for d in sorted(os.listdir('tests/functional')):
    p = os.path.join('tests/functional', d, 'test.sh')
    if not os.path.isfile(p): continue
    with open(p, 'r', encoding='utf-8') as f:
        c = f.read()
    n = len(re.findall(r'rlRun\s+', c))
    if n == 0:
        n = len(re.findall(r'echo\s+"=== Test', c)) * 15
        if n == 0: n = 15
    total += n
print(total)
