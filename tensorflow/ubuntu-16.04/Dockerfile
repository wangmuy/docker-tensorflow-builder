FROM ubuntu:16.04

# gcc-6 g++-6: see https://github.com/ethereum-mining/ethminer/issues/731
RUN apt update && apt install -y \
    build-essential \
    gcc-6 \
    g++-6 \
    curl \
    git \
    wget \
    libjpeg-dev \
    openjdk-8-jdk \
    && rm -rf /var/lib/lists/*

# Install Anaconda
WORKDIR /
RUN wget "http://mirrors.ustc.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh" -O "miniconda.sh" && \
    bash "miniconda.sh" -b -p "/conda" && \
    rm miniconda.sh && \
    echo PATH='/conda/bin:$PATH' >> /root/.bashrc && \
    /conda/bin/conda config --add channels conda-forge && \
    /conda/bin/conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/free/ && \
    /conda/bin/conda update --yes -n base conda && \
    /conda/bin/conda update --all --yes

COPY build.sh /build.sh
COPY setup_cuda.sh /setup_cuda.sh

CMD bash build.sh

