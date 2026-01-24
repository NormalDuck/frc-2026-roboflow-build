FROM python:3.12-slim

RUN apk add --no-cache python3 py3-pip uv

WORKDIR /app

COPY pyproject.toml uv.lock ./

RUN uv sync

COPY . .

CMD ["python", "main.py"]
