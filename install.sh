#!/bin/ash

# AutoUpdateHosts 一键安装脚本

# 定义远程脚本文件的 URL
SCRIPT_URL="https://raw.githubusercontent.com/CowCow-Finance/OpenWrt-AutoUpdateHosts/main/files/autoupdatehosts"
# 定义本地脚本文件的目标路径
SCRIPT_PATH="/etc/autoupdatehosts"
# 定义计划任务的时间（每天凌晨4点30分）
CRON_TIME="30 4 * * *"
# 定义 dnsmasq 配置文件路径
DNSMASQ_CONF="/etc/config/dhcp"

echo "开始安装 AutoUpdateHosts 脚本..."

# 下载远程脚本文件到本地，并显示下载进度
echo "下载 AutoUpdateHosts 脚本文件..."
curl -# -o "$SCRIPT_PATH" "$SCRIPT_URL"

# 赋予脚本文件相应的权限
echo "赋予脚本文件权限..."
chmod +x "$SCRIPT_PATH"

# 修改 dnsmasq 配置文件取消忽略 hosts 文件的设置，删除包含 "option nohosts" 的行
echo "修改 dnsmasq 配置文件，取消“忽略 hosts 文件”的设定..."
sed -i '/option nohosts/d' "$DNSMASQ_CONF"

echo "开始添加计划任务..."

# 检查是否已经存在相同的计划任务，如果不存在则添加
if grep -qF "$SCRIPT_PATH" /etc/crontabs/root; then
    echo "已经存在相同的计划任务，跳过计划任务添加步骤。"
else
    echo "添加计划任务，默认更新时间为每天4:30..."
    echo "$CRON_TIME $SCRIPT_PATH" >> /etc/crontabs/root
fi

# 提取计划任务的时间，并输出相应提示
CRON_HOUR=$(echo $CRON_TIME | cut -d' ' -f2)
CRON_MIN=$(echo $CRON_TIME | cut -d' ' -f1)
echo "AutoUpdateHosts 脚本安装完成！脚本将在每天的 $CRON_HOUR 点 $CRON_MIN 分运行。"

# 运行脚本文件一次
echo "运行 AutoUpdateHosts 脚本..."
"$SCRIPT_PATH"
