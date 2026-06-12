import paramiko, os, time

SERVER = '10.20.237.192'; PORT = 12055; USER = 'openruyi'; PASS = 'openruyi'
BASE = 'e:/code/openruyi-autotest/tests/functional'

# All packages
all_pkgs = sorted([d for d in os.listdir(BASE)
                   if os.path.isdir(os.path.join(BASE, d)) and
                   os.path.isfile(os.path.join(BASE, d, 'test.sh'))])
print(f'Total: {len(all_pkgs)} packages')

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER, port=PORT, username=USER, password=PASS, timeout=15)

# Upload all
for pkg in all_pkgs:
    sftp = ssh.open_sftp()
    with open(os.path.join(BASE, pkg, 'test.sh'), 'r', encoding='utf-8') as f:
        content = f.read().replace('\r\n', '\n')
    with sftp.open(f'/home/openruyi/{pkg}_test.sh', 'w') as rf:
        rf.write(content)
    sftp.chmod(f'/home/openruyi/{pkg}_test.sh', 0o755)
    sftp.close()
ssh.exec_command('rm -f /home/openruyi/*_result.log')
print('Uploaded all\n')

results = {}
batch_size = 5
for i in range(0, len(all_pkgs), batch_size):
    batch = all_pkgs[i:i+batch_size]
    n = i//batch_size + 1; total_batches = (len(all_pkgs)+batch_size-1)//batch_size
    print(f'Batch {n}/{total_batches}: {", ".join(batch)}')
    for pkg in batch:
        ssh.exec_command(f'chmod +x /home/openruyi/{pkg}_test.sh; nohup timeout 240 bash /home/openruyi/{pkg}_test.sh > /home/openruyi/{pkg}_result.log 2>&1 &')
    time.sleep(120)
    for pkg in batch:
        i2,o2,e2 = ssh.exec_command(f'tail -3 /home/openruyi/{pkg}_result.log 2>/dev/null')
        ok = 'tests passed' in o2.read().decode().lower()
        results[pkg] = 'PASS' if ok else 'FAIL'
    passed = sum(1 for p in batch if results.get(p)=='PASS')
    print(f'  -> {passed}/{len(batch)}\n')

print('='*72)
print(f'{"Package":<28} {"Status":<8} {"Category"}')
print('-'*72)
cats = {}
for pkg in all_pkgs:
    status = results.get(pkg, '?')
    print(f'{pkg:<28} {status:<8} {"func"}')
print('-'*72)
pass_count = sum(1 for v in results.values() if v=='PASS')
print(f'Total: {pass_count}/{len(all_pkgs)} passed')
ssh.close()
