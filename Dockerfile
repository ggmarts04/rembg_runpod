# Use the official Python image.
FROM python:3.10-slim

# Set the working directory.
WORKDIR /app

# Copy only the necessary files to install dependencies.
COPY setup.py setup.cfg pyproject.toml MANIFEST.in ./
COPY rembg ./rembg

# Install the rembg package and its dependencies for CPU and CLI.
# The 'cli' extras now include 'runpod' and 'requests'.
RUN pip install --no-cache-dir ".[cpu,cli]"

# Copy the handler script.
COPY runpod_handler.py .

# Download the default model to cache it in the image.
RUN rembg d u2net

# This command is the standard entry point for a RunPod Python worker.
# It will automatically find and run the handler defined in runpod_handler.py.
CMD ["python", "-m", "runpod.serverless.worker"]
