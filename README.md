# pfctl - iptables 端口转发工具

轻量级 iptables 端口转发管理工具，一条命令即可完成端口转发配置。

## 🚀 一键安装

```bash
# curl
bash <(curl -fsSL https://raw.githubusercontent.com/sail-tunnel/pfctl/main/install.sh)

# wget
bash <(wget -qO- https://raw.githubusercontent.com/sail-tunnel/pfctl/main/install.sh)
```

## 📖 使用说明

### 添加转发规则

```bash
# 基本转发（本地 8080 → 目标 1.2.3.4:8080，TCP+UDP）
pfctl add -p 8080 -d 1.2.3.4

# 端口映射（本地 8443 → 目标 10.0.0.5:443）
pfctl add -p 8443 -d 10.0.0.5 --dport 443

# 端口范围转发（本地 8000-9000 → 目标 8000-9000）
pfctl add -p 8000-9000 -d 10.0.0.5

# 内网转发（指定 SNAT 源 IP）
pfctl add -p 8080 -d 192.168.80.35 -s 192.168.80.40

# 仅 TCP 协议
pfctl add -p 8080 -d 1.2.3.4 -P tcp
```

### 删除转发规则

```bash
pfctl del -p 8080 -d 1.2.3.4
```

### 查看当前规则

```bash
pfctl list
```

### 持久化规则

```bash
pfctl save
```

### 自更新

```bash
pfctl update
```

### 查看版本

```bash
pfctl version
```

## 📋 参数说明

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `-p, --port` | 本地监听端口（支持范围，如 `8000-9000`） | *必填* |
| `-d, --dest` | 目标 IP（转发地址） | *必填* |
| `-s, --snat` | SNAT 源地址 | MASQUERADE |
| `-P, --proto` | 协议: `tcp` / `udp` / `both` | `both` |
| `--dport` | 目标端口（支持范围） | 与本地端口一致 |

## 🗑️ 卸载

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/sail-tunnel/pfctl/main/install.sh) --uninstall
```

## 📄 License

MIT