# Use Debian-slim for glibc compatibility
FROM python:3.12-slim

# 1. Install system dependencies for OpenCV and RKNN
# libgl1 and libglib2.0 are required for cv2 to run
RUN apt-get update && apt-get install -y \
    uv \
    libgl1 \
    libglib2.0-0 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 3. Setup workspace
WORKDIR /app

# 4. Copy dependency files
COPY pyproject.toml uv.lock ./

# 5. Install dependencies
# On Debian, uv will now find the 'manylinux' wheels for ARM64 instantly
RUN uv sync --frozen --system

# 6. Copy your code and the ONNX model
COPY . .

# 7. Run the export
CMD ["python", "app/main.py"]
