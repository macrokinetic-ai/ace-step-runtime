# ACE-Step 1.5 runtime image for vast.ai: open-source code and dependencies only.
# Contains NO models (downloaded at start with hf_transfer), no keys, no songs.
# Base = the image used in the working runs 3/4.
FROM pytorch/pytorch:2.8.0-cuda12.8-cudnn9-runtime

ARG ACE_COMMIT=ca1e85fe9430179831e6bc6be790c332190a3866
ENV DEBIAN_FRONTEND=noninteractive PATH=/root/.local/bin:$PATH \
    HF_HUB_ENABLE_HF_TRANSFER=1 HF_XET_HIGH_PERFORMANCE=1 UV_LINK_MODE=copy

# gcc: triton (nano-vllm) compiles a small C stub at start; without it the 4B LM fails
RUN apt-get update && apt-get install -y --no-install-recommends \
        git ffmpeg curl rsync build-essential ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Split into layers < 10 GB (ghcr per-layer limit): torch + CUDA wheels first, then the rest
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && git clone https://github.com/ace-step/ACE-Step-1.5.git /opt/ace \
    && cd /opt/ace && git checkout ${ACE_COMMIT} \
    && uv venv && uv pip install --index-url https://download.pytorch.org/whl/cu128 \
         torch==2.10.0+cu128 torchvision==0.25.0+cu128 torchaudio==2.10.0+cu128 \
    && uv cache clean && rm -rf /root/.cache
RUN cd /opt/ace && uv sync \
    && uv pip install hf_transfer "huggingface_hub[cli]" \
    && uv cache clean && rm -rf /root/.cache

WORKDIR /opt/ace
LABEL org.opencontainers.image.source="https://github.com/macrokinetic-ai/ace-step-runtime" \
      org.opencontainers.image.description="ACE-Step 1.5 (pinned commit) + deps for CUDA 12.8; models not included" \
      org.opencontainers.image.licenses="MIT"
