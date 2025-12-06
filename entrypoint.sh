#!/bin/bash
# 自定义 entrypoint 脚本：用于同时启动 SSH 服务和 WordPress

# 1. 安装 SSH 服务（官方 WordPress 镜像默认不含 SSH）
apt-get update && apt-get install -y \
    openssh-server \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*  # 清理 apt 缓存，减小容器体积

# 2. 创建 SSH 服务必需的目录（否则 sshd 启动失败）
mkdir -p /var/run/sshd

# 3. 设置 root 用户的 SSH 密码（请务必修改为强密码！）
# 格式：echo '用户名:密码' | chpasswd
echo 'root:your_secure_ssh_password' | chpasswd

# 4. 修改 SSH 配置，允许 root 远程登录（默认配置可能禁止）
# 注意：生产环境建议创建普通用户并禁用 root 登录，此处为演示简化
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 5. 启动 SSH 服务
service ssh start

# 6. 执行原 WordPress 镜像的 entrypoint（启动 Apache + WordPress）
# 使用 exec 确保 Apache 成为容器主进程，便于容器接收停止信号
exec docker-entrypoint.sh apache2-foreground

