# STAGE 1: The Builder (uses the specialized uv image)
FROM ghcr.io/astral-sh/uv:latest AS builder

# Set up the workspace
WORKDIR /app

# Enable bytecode compilation for extra speed
ENV UV_COMPILE_BYTECODE=1

# Copy your dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies into a specific folder (/app/.venv)
# We use --frozen to ensure the lockfile isn't changed
RUN uv sync --frozen --no-dev


# STAGE 2: The Final Image (the slim Linux you actually want)
FROM python:3.12-slim

# Install the minimal runtime libs for OpenCV/RKNN
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# MAGIC STEP: Copy ONLY the installed packages from the builder stage
# This keeps the final image tiny (no uv, no build tools, just the apps)
COPY --from=builder /app/.venv /app/.venv

# Copy your source code
COPY . .

# Set the path to use the virtual environment we copied
ENV PATH="/app/.venv/bin:$PATH"

CMD ["python", "app/main.py"]
