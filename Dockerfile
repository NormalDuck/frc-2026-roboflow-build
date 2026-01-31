ARG TARGETPLATFORM
FROM kobeeeef/xdash-alt-base-image:today

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends build-essential && \
    rm -rf /var/lib/apt/lists/* && apt-get clean

COPY requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir --prefer-binary -r requirements.txt

RUN pip list

WORKDIR /app
