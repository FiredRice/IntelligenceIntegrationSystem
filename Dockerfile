# ---------- 1. 基础镜像：官方 Python 3.10 slim ----------
FROM python:3.10-slim

# ---------- 2. 系统依赖： playwright 需要 chromium 及其运行时库 ----------
RUN apt-get update && apt-get install -y --no-install-recommends \
        wget \
        gnupg \
        ca-certificates \
        fonts-liberation \
        libappindicator3-1 \
        libasound2 \
        libatk-bridge2.0-0 \
        libatk1.0-0 \
        libcups2 \
        libdbus-1-3 \
        libdrm2 \
        libgbm1 \
        libgtk-3-0 \
        libnspr4 \
        libnss3 \
        libx11-xcb1 \
        libxcomposite1 \
        libxdamage1 \
        libxrandr2 \
        xdg-utils \
        # 清理缓存减小镜像体积
    && rm -rf /var/lib/apt/lists/*

# ---------- 3. 创建工作目录 ----------
WORKDIR /app

# ---------- 4. 一次性复制依赖文件，利用缓存 ----------
COPY requirements.txt requirements_freeze.txt ./

# ---------- 5. 安装 Python 依赖 ----------
# 直接使用官方镜像自带 pip，无需再建 venv（容器本身就是隔离环境）
RUN pip install --no-cache-dir -r requirements.txt || \
    pip install --no-cache-dir -r requirements_freeze.txt

# ---------- 6. 安装 Playwright 浏览器 ----------
RUN playwright install chromium

# ---------- 7. 复制项目其余源码 ----------
COPY . .

# ---------- 8. 暴露端口（如有需要自行修改） ----------
EXPOSE 8900

# ---------- 9. 默认启动命令 ----------
# 同时跑两个脚本：用 & 后台运行，然后 wait 保持容器存活
# 若需单进程或 supervisor，可改为 ["python", "IntelligenceHubLauncher.py"]
CMD ["sh", "-c", "python IntelligenceHubLauncher.py & python ServiceEngine.py & wait"]