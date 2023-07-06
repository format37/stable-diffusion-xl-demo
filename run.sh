# docker run --gpus '"device=0"' -p 2700:2700 -t sdxl
# network mode host
# Set variable: SDXL_MODEL_DIR = /weights
docker run --gpus '"device=0"' \
    --network host \
    -v /mnt/sda/share/alex/torrents/models/SDXL\ 0.9/:/weights \
    -e PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:512 \
    -e SDXL_MODEL_DIR=/weights \
    -p 2700:2700 -t sdxl
    