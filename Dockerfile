# Use the official Python image.
FROM python:3.10-slim

# Set the working directory.
WORKDIR /app

# Copy all files from the repository into the container's working directory at once.
# This single, simple copy is intended to be more robust for build environments
# that have issues with staged file copying.
COPY . .

# Install the rembg package and all its dependencies (for CPU and CLI)
# from the local source. The 'cli' extras in setup.py include 'runpod' and 'requests'.
RUN pip install --no-cache-dir ".[cpu,cli]"

# Download the default model so it's cached in the image, ready for use.
RUN rembg d u2net

# This command is the standard entry point for a RunPod Python worker.
# It automatically finds and runs the handler defined in runpod_handler.py.
CMD ["python", "-m", "runpod.serverless.worker"]
