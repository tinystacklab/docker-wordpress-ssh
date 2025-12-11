# Docker WordPress with SSH

一个基于 Docker Compose 的 WordPress 一键部署方案，包含 MySQL 数据库服务，并集成 SSH 访问功能，方便直接进入 WordPress 容器进行管理和调试。

## 功能特性

- ✨ 一键部署 WordPress 最新版本
- 📦 内置 MySQL 8.0 数据库，数据持久化存储
- 🔌 集成 SSH 服务，可直接连接到 WordPress 容器
- 🚀 自定义端口映射，避免与主机端口冲突
- 📁 数据持久化，容器重启后数据不丢失

## 端口映射

| 服务类型 | 宿主机端口 | 容器端口 | 用途说明 |
|---------|---------|---------|---------|
| HTTP | 40080 | 80 | WordPress 网站访问 |
| SSH | 40022 | 22 | SSH 容器连接 |
| MySQL | 43306 | 3306 | 数据库远程连接 |

## 快速开始

### 1. 克隆项目

```bash
git clone <repository-url>
cd docker-wordpress-ssh
```

### 2. 修改 SSH 密码（重要）

编辑 `entrypoint.sh` 文件，修改 SSH root 密码：

```bash
# 第 13 行：将 your_secure_ssh_password 替换为强密码
echo 'root:your_secure_ssh_password' | chpasswd
```

### 3. 启动服务

```bash
# 后台启动所有服务
docker-compose up -d
```

### 4. 访问 WordPress

在浏览器中打开：`http://localhost:40080`

按照向导完成 WordPress 安装配置即可。

## SSH 连接容器

### 使用密码连接

```bash
ssh root@localhost -p 40022
```

### 使用密钥连接（推荐）

1. 将公钥复制到容器内：
```bash
ssh-copy-id -p 40022 root@localhost
```

2. 之后即可无密码连接：
```bash
ssh -p 40022 root@localhost
```

## 数据库连接

### 使用 MySQL 客户端连接

```bash
mysql -h localhost -P 43306 -u wordpress -p wordpress
```

### 数据库信息

- **数据库名**: wordpress
- **用户名**: wordpress
- **密码**: wordpress
- **主机**: localhost:43306

## 数据持久化

所有重要数据都存储在宿主机的目录中：

- `./db_data`: MySQL 数据库数据
- `./wordpress_data`: WordPress 网站文件和主题插件

## 停止和重启服务

```bash
# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 查看服务状态
docker-compose ps
```

## 注意事项

1. **安全警告**：请务必修改默认的 SSH 密码和数据库密码，避免安全风险
2. **端口冲突**：如果宿主机端口已被占用，请修改 `docker-compose.yaml` 中的端口映射
3. **性能优化**：建议根据实际需要调整 MySQL 和 WordPress 的资源限制
4. **备份**：定期备份 `db_data` 和 `wordpress_data` 目录，防止数据丢失

## 目录结构

```
docker-wordpress-ssh/
├── docker-compose.yaml    # Docker Compose 配置文件
├── entrypoint.sh         # 自定义容器启动脚本（安装 SSH + 启动服务）
├── README.md             # 项目说明文档
├── db_data/              # MySQL 数据库数据目录
└── wordpress_data/       # WordPress 网站文件目录
```
