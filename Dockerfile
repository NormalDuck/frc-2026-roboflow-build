ARG TARGETPLATFORM
FROM kobeeeef/xdash-alt-base-image:today

WORKDIR /xbot/Alt

RUN apt-get update && apt-get install -y --no-install-recommends build-essential && \
    rm -rf /var/lib/apt/lists/* && apt-get clean

COPY requirements.txt /xbot/Alt/requirements.txt

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --prefer-binary -r requirements.txt && \
    # pip install --no-cache-dir --prefer-binary XTablesClient && \
    # pip install pyflame
    # RUN pip install rknn-toolkit-lite2==2.3.0 --no-cache-dir && \
    # pip install pynetworktables

# COPY ./src/assets/librknnrt.so /usr/li/librknnrt.so
WORKDIR /xbot/Alt/src
