"""Run all tests already on server, collect results to CSV."""
import paramiko, time, csv, os, sys

SERVER='10.20.237.192';PORT=12055;USER='openruyi';PASS='openruyi'

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER, port=PORT, username=USER, password=PASS, timeout=60)

# Get list of all .sh files on server (excluding .log)
stdin, stdout, stderr = ssh.exec_command(
    "ls /home/openruyi/tc/*.sh 2>/dev/null | grep -v '\\.log$' | sed 's|.*/||; s|\\.sh$||' | sort"
)
files = stdout.read().decode().strip().split('\n')
files = [f for f in files if f]
print(f'Found {len(files)} test scripts on server')

# Parse file names: {pkg}__{case}.sh -> (pkg, case)
cases = []
for f in files:
    if '__' in f:
        parts = f.split('__', 1)
        cases.append((parts[0], parts[1]))
    else:
        cases.append((f, f))

print(f'Total cases: {len(cases)}')

# Run tests in batches
batch_size = 25
results = {}
total = len(cases)

for i in range(0, total, batch_size):
    batch = cases[i:i+batch_size]
    n = i // batch_size + 1
    total_batches = (total + batch_size - 1) // batch_size

    # Start all tests in batch
    for pkg, case in batch:
        fn = f'{pkg}__{case}'
        ssh.exec_command(
            f'nohup timeout 60 bash /home/openruyi/tc/{fn}.sh '
            f'> /home/openruyi/tc/{fn}.log 2>&1 &'
        )

    time.sleep(50)

    # Collect results
    for pkg, case in batch:
        fn = f'{pkg}__{case}'
        stdin, stdout, stderr = ssh.exec_command(
            f'tail -1 /home/openruyi/tc/{fn}.log 2>/dev/null'
        )
        out = stdout.read().decode().lower()
        passed = 'tests passed' in out
        key = (pkg, case if case != pkg else pkg)
        results[key] = 'PASS' if passed else 'FAIL'

    pcount = sum(1 for r in list(results.values())[-len(batch):] if r == 'PASS')
    print(f'  Batch {n}/{total_batches}: {pcount}/{len(batch)}')
    sys.stdout.flush()

# Write CSV
csv_path = 'docs/test_report.csv'
with open(csv_path, 'w', newline='', encoding='utf-8-sig') as f:
    w = csv.writer(f)
    w.writerow(['测试套', '测试用例', '测试结果'])
    for (pkg, case), result in sorted(results.items()):
        w.writerow([pkg, case, result])

tp = sum(1 for v in results.values() if v == 'PASS')
print(f'\nTotal: {tp}/{len(results)} passed')
print(f'CSV written to {csv_path}')
ssh.close()
