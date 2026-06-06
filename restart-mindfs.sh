#!/bin/bash
echo "🔄 重启 MindFS..."

# 杀掉现有进程
MINDFS_PID=$(ps aux | grep "[m]indfs" | awk '{print $2}')
if [ -n "$MINDFS_PID" ]; then
    echo "停止旧进程 (PID: $MINDFS_PID)"
    kill $MINDFS_PID 2>/dev/null
    sleep 2
fi

# 启动新进程
cd /home/pishi/coding/mindfs
echo "启动新 MindFS..."
nohup ./mindfs -addr 0.0.0.0:7331 /home/pishi/coding/mindfs > /dev/null 2>&1 &

# 等待启动
sleep 3

# 验证新进程
NEW_PID=$(ps aux | grep "[m]indfs" | awk '{print $2}')
if [ -n "$NEW_PID" ]; then
    echo "✅ MindFS 已成功重启，新进程 PID: $NEW_PID"
    echo "🌐 访问地址: http://127.0.0.1:7331?root=mindfs"
    echo "📋 日志文件: /root/.local/share/mindfs/logs/mindfs.log"
else
    echo "❌ MindFS 启动失败，请检查日志"
    tail -20 /root/.local/share/mindfs/logs/mindfs.log
fi
