#!/bin/bash

# 定义被控端 IPv6 地址和 Key
TARGET_V6="[240e:430:2418:a512:bd75:370c:d97:e016]"
SEC_KEY="X2rhdktRn4slRA6NylHZ5CJFjORJK03zmcsbtr4eZCg="
CONFIG_FILE="$HOME/.config/rustdesk/RustDesk2.toml"

echo "正在强制注入 RustDesk 配置..."

# 1. 彻底结束 RustDesk 相关进程
sudo pkill -9 rustdesk

# 2. 直接修改配置文件（确保方括号被正确写入）
# 使用 sed 替换关键配置项
sed -i "s/^rendezvous_server = .*/rendezvous_server = '$TARGET_V6'/" "$CONFIG_FILE"
sed -i "s/^custom-rendezvous-server = .*/custom-rendezvous-server = '$TARGET_V6'/" "$CONFIG_FILE"
sed -i "s/^relay-server = .*/relay-server = '$TARGET_V6'/" "$CONFIG_FILE"
sed -i "s/^key = .*/key = '$SEC_KEY'/" "$CONFIG_FILE"

# 3. 检查文件内容是否符合预期
echo "当前配置文件状态："
grep -E "server|key" "$CONFIG_FILE"

# 4. 重启服务
sudo systemctl restart rustdesk

echo "配置已强制注入。请再次打开 RustDesk 查看底部状态栏。"
