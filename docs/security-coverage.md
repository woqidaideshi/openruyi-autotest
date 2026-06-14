# 安全测试覆盖详情

> 最后更新: 2026-06-14 | 自动生成
> 测试环境: openEuler RISC-V (10.20.237.192)

共 **1** 个安全测试套件，**8** 个测试用例，**26** 个功能点

## 安全测试套件一览

| 测试套件 | 用例数 | 功能点 | 类型 |
|----------|:---:|:---:|:---:|
| [nmap](#nmap) | 8 | 26 | rlRun |

---

## nmap

<details>
<summary><b>nmap — 8 个用例 / 26 个功能点</b></summary>

#### test_nmap_basic_scan

- TCP 端口扫描 (常用端口)
- UDP 端口扫描 (DNS)
- TCP 端口扫描 (1-100)

#### test_nmap_service_detection

- SSH 服务版本检测
- 服务版本探测

#### test_nmap_os_detection

- 操作系统指纹识别
- 限制型 OS 检测

#### test_nmap_script_scan

- NSE banner 脚本
- NSE HTTP 头检测
- NSE SSH 认证方法检测
- NSE SSL 密码套件枚举

#### test_nmap_firewall_evasion

- 分片包扫描 (fragment)
- 随机数据填充扫描
- 错误校验和探测

#### test_nmap_network_discovery

- Ping 扫描 (主机发现)
- ICMP Echo 发现
- TCP SYN Ping 发现

#### test_nmap_ssl_analysis

- SSL 证书分析
- Heartbleed 漏洞检测
- SSLv2 支持检测

#### test_nmap_output_formats

- 普通格式输出 (-oN)
- XML 格式输出 (-oX)
- Grepable 格式输出 (-oG)
- 全格式输出 (-oA)
- 普通输出文件存在
- XML 输出文件存在
- Grepable 输出文件存在

</details>

## 安全测试覆盖场景

| 场景类别 | 覆盖内容 | nmap 命令示例 |
|----------|---------|-------------|
| **端口扫描** | TCP/UDP 端口发现 | `nmap -T4 -p 1-100` / `nmap -sU -p 53` |
| **服务检测** | 服务版本识别 | `nmap -sV -p 22` |
| **OS 指纹** | 操作系统识别 | `nmap -O --osscan-limit` |
| **NSE 脚本** | 漏洞/信息探测 | `nmap --script=banner,ssl-enum-ciphers` |
| **规避技术** | 防火墙/IDS 绕过 | `nmap -f` / `nmap --data-length` / `nmap --badsum` |
| **主机发现** | 存活主机探测 | `nmap -sn` / `nmap -PE` / `nmap -PS` |
| **SSL/TLS** | 证书/密码分析 | `nmap --script=ssl-cert,ssl-heartbleed,sslv2` |
| **输出格式** | 多格式报告 | `nmap -oN/-oX/-oG/-oA` |

---

## 运行安全测试

```bash
# 单独运行 nmap 安全测试
cd tests/security/nmap && bash test.sh

# 在服务器上运行
ssh openruyi@10.20.237.192 -p 12055
cd /path/to/tests/security/nmap && bash test.sh
```

## 安全说明

- 所有测试仅针对 localhost (127.0.0.1) 执行，不会扫描外部网络
- 部分功能（OS 指纹识别）需要 root 权限，非 root 环境下会自动跳过
- 扫描使用 `-T4` 和 `--host-timeout` 参数控制时间
- 如发现危险端口开放（telnet 23、FTP 21、RDP 3389 等），测试会发出警告
