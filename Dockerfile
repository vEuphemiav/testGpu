FROM python:3.9-slim as builder

# 设置环境变量
ENV LANG zh_CN.UTF-8 \
    LANGUAGE zh_CN:zh \
    LC_ALL zh_CN.UTF-8

# 安装必要的系统包
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    g++ \
    make \
    cmake \
    python3-dev \
    libopenblas-dev \
    libatlas-base-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 升级pip并安装Python包
RUN pip install --upgrade pip==23.2.1 && \
    pip install --no-cache-dir \
    torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu118 && \
    pip install --no-cache-dir \
    Cython \
    packaging \
    requests==2.32.3 \
    fairseq==0.12.2 \
    librosa==0.10.2.post1 \
    pyworld==0.3.4 \
    transformers==4.41.2 \
    numpy==1.23.3 \
    scipy==1.10.1 \
    torchaudio==2.4.1 \
    matplotlib==3.7.5 \
    loguru==0.7.2 \
    einops==0.8.0 \
    local-attention==1.9.15 \
    ffmpeg-python==0.2.0 \
    Werkzeug==2.0.3 \
    audiofile==1.5.1 \
    Flask==2.0.3

# 使用多阶段构建，只复制必要的文件到最终镜像
FROM python:3.9-slim

# 设置环境变量
ENV LANG zh_CN.UTF-8 \
    LANGUAGE zh_CN:zh \
    LC_ALL zh_CN.UTF-8

# 复制构建阶段的依赖
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# 复制项目文件
# COPY svc_proj /app/svc_proj

# 设置工作目录
# WORKDIR /app/svc_proj

# 暴露端口（如果需要）
# EXPOSE 9000

# 设置容器启动命令
# CMD [ "python3", "serverless_main.py" ]