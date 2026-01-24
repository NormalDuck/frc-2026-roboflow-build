# STAGE 1: Builder
# Using the 'python3.12-slim' version of uv gives us a shell and Python
FROM ghcr.io/astral-sh/uv:python3.12-slim AS builder

WORKDIR /app

# Enable bytecode compilation and fix link mode for Docker
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies into /app/.venv
# This works now because this image has /bin/sh
RUN uv sync --frozen --no-dev --no-install-project


# STAGE 2: Final Runtime
FROM python:3.12-slim

# Install runtime libs for OpenCV/RKNN
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the virtual environment from the builder
COPY --from=builder /app/.venv /app/.venv

# Copy your source code
COPY . .

# Ensure the app uses the virtual environment's python/packages
ENV PATH="/app/.venv/bin:$PATH"

# If main.py is in an 'app' folder, use: CMD ["python", "app/main.py"]
CMD ["python", "main.py"]
