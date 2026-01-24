FROM alpine:3.23.2

# You need ALL of these to compile OpenCV
RUN apk add --no-cache \
    python3-dev \
    build-base \
    cmake \
    clang-dev \
    linux-headers \
    libffi-dev \
    musl-dev \
    openblas-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    uv

WORKDIR /app
COPY . .

RUN uv sync --frozen --system

CMD ["python", "main.py"]
