FROM kobeeeef/xdash-alt-base-image:today

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements directly
COPY ./requirements.txt /app/requirements.txt

# Upgrade pip and install
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r /app/requirements.txt

# Debug print to build logs
RUN pip list

COPY . /app
