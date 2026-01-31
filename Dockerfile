ARG TARGETPLATFORM
FROM kobeeeef/xdash-alt-base-image:today

WORKDIR /xbot/Alt

RUN apt-get update && apt-get install -y --no-install-recommends build-essential && \
    rm -rf /var/lib/apt/lists/* && apt-get clean

COPY requirements.txt /xbot/Alt/requirements.txt

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --prefer-binary -r requirements.txt && \

WORKDIR /xbot/Alt/src
