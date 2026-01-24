FROM alpine:3.23.2

RUN apk add --no-cache python3 py3-pip uv

WORKDIR /app

COPY pyproject.toml uv.lock ./

RUN uv sync

COPY . .

CMD ["python", "main.py"]
