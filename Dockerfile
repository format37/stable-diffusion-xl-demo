FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu20.04
LABEL maintainer="Hugging Face"
LABEL repository="diffusers"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y bash \
                   build-essential \
                   git \
                   git-lfs \
                   curl \
                   ca-certificates \
                   libsndfile1-dev \
                   libgl1 \
                   python3.8 \
                   python3-pip \
                   python3.8-venv && \
    rm -rf /var/lib/apt/lists

# make sure to use venv
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# pre-install the heavy dependencies (these can later be overridden by the deps from setup.py)
RUN python3 -m pip install --no-cache-dir --upgrade pip && \
    python3 -m pip install --no-cache-dir \
        torch \
        torchvision \
        torchaudio \
        invisible_watermark && \
    python3 -m pip install --no-cache-dir \
        accelerate \
        datasets \
        hf-doc-builder \
        huggingface-hub \
        Jinja2 \
        librosa \
        numpy \
        scipy \
        tensorboard \
        transformers \
        omegaconf \
        pytorch-lightning \
        xformers

# SDXL
RUN python3 -m pip install --no-cache-dir \
    transformers \
    accelerate \
    safetensors \
    "numpy>=1.17" \
    "PyWavelets>=1.1.1" \
    "opencv-python>=4.1.0.25"
RUN python3 -m pip install --no-cache-dir --no-deps \
    invisible-watermark
RUN python3 -m pip install --upgrade \
    diffusers[torch]

COPY requirements.txt /opt/requirements.txt
RUN python3 -m pip install --no-cache-dir -r /opt/requirements.txt

COPY share_btn.py /opt/share_btn.py

COPY app.py /opt/app.py

# CMD ["python3", "/opt/app.py"]
# PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:512 SDXL_MODEL_DIR=/path_to_sdxl python app.py
# CMD ["PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:512", "SDXL_MODEL_DIR=/path_to_sdxl", "python3", "/opt/app.py"]
CMD ["python3", "/opt/app.py"]
