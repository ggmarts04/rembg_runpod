# Use the official Python image.
FROM python:3.10-slim

# Set the working directory.
WORKDIR /app

# Copy all files from the repository into the container's working directory at once.
COPY . .

# Install the rembg package and all its dependencies (for CPU and CLI)
# from the local source. The 'cli' extras in setup.py include 'runpod' and 'requests'.
RUN pip install --no-cache-dir ".[cpu,cli]"

# Install runpod explicitly in case it's not included in the extras
RUN pip install --no-cache-dir runpod

# Download the default model so it's cached in the image, ready for use.
RUN rembg d u2net

# Set the handler file path explicitly
ENV RUNPOD_HANDLER_PATH=/app/handler.py

# This command is the standard entry point for a RunPod Python worker.
CMD ["python", "-m", "runpod.serverless.worker"]
