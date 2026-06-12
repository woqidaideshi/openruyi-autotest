import paramiko, os, time

SERVER = '10.20.237.192'; PORT = 12055; USER = 'openruyi'; PASS = 'openruyi'
BASE = 'e:/code/openruyi-autotest/tests/functional'

new_pkgs = ['curl','sed','dwz','pkgconf','cryptsetup','newt','lua','ca-certificates','ca-certificates-mozilla','nettle','bash','mpc','isl','mpdecimal','mpfr','gmp','debugedit','filesystem','linux-headers','libselinux','rpm-config-openruyi','findutils','zstd','pam','glibc','gzip','xz','util-linux','elfutils','audit','python']

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER, port=PORT, username=USER, password=PASS, timeout=15)

# Upload all
for pkg in new_pkgs:
    sftp = ssh.open_sftp()
    with open(os.path.join(BASE, pkg, 'test.sh'), 'r', encoding='utf-8') as f:
        content = f.read().replace('\r\n', '\n')
    with sftp.open(f'/home/openruyi/{pkg}_test.sh', 'w') as rf:
        rf.write(content)
    sftp.chmod(f'/home/openruyi/{pkg}_test.sh', 0o755)
    sftp.close()
print('Uploaded all 31 scripts\n')

results = {}
for i in range(0, len(new_pkgs), 5):
    batch = new_pkgs[i:i+5]
    n = i//5 + 1
    print(f'Batch {n}: {batch}')
    for pkg in batch:
        ssh.exec_command(f'chmod +x /home/openruyi/{pkg}_test.sh; nohup timeout 240 bash /home/openruyi/{pkg}_test.sh > /home/openruyi/{pkg}_result.log 2>&1 &')
    time.sleep(120)
    for pkg in batch:
        i2,o2,e2 = ssh.exec_command(f'tail -3 /home/openruyi/{pkg}_result.log 2>/dev/null')
        ok = 'tests passed' in o2.read().decode().lower()
        results[pkg] = 'PASS' if ok else 'FAIL'
    passed = sum(1 for p in batch if results.get(p)=='PASS')
    print(f'  -> {passed}/{len(batch)}\n')

print('='*60)
for pkg in new_pkgs:
    print(f'  {"PASS" if results.get(pkg)=="PASS" else "FAIL"} {pkg}')
print(f'Total: {sum(1 for v in results.values() if v=="PASS")}/{len(new_pkgs)}')
ssh.close()
