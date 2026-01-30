# ---------- Stage 1: Builder ----------
FROM python:3.12-slim-bookworm AS builder

# Install uv binary from official image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set working directory
WORKDIR /app

# Enable bytecode compilation and link mode for performance
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

# Copy only dependency files first to leverage Docker caching
COPY pyproject.toml uv.lock ./

# Install dependencies into a virtual environment (.venv)
# --frozen ensures we use the exact versions in uv.lock
RUN uv sync --frozen --no-install-project --no-dev

# Copy the rest of the application
COPY . .

# Install the project itself
RUN uv sync --frozen --no-dev


# ---------- Stage 2: Runtime ----------
FROM kobeeeef/xdash-alt-base-image:today

# Install Debian system dependencies for OpenCV
# Even 'headless' needs some basic shared libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the virtual environment from the builder
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app /app

# Place the virtual environment's bin at the front of the PATH
ENV PATH="/app/.venv/bin:$PATH"

# Run your application
CMD ["python", "host_scripts/main.py"]
