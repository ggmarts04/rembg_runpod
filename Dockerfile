# Stage 1: Builder
# This stage installs the package and all its dependencies.
FROM python:3.10-slim as builder

WORKDIR /app

# Copy setup files and source code for installation
COPY setup.py setup.cfg pyproject.toml MANIFEST.in ./
COPY rembg ./rembg

# Install the rembg package and its dependencies, including the 'cli' extras
# which now contain 'runpod' and 'requests'.
# This also installs onnxruntime for cpu.
RUN pip install --no-cache-dir ".[cpu,cli]"


# Stage 2: Final Image
# This stage creates the final, lean image for runtime.
FROM python:3.10-slim

WORKDIR /app

# Copy the installed packages from the builder stage.
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages

# Copy the handler script into the final image.
COPY runpod_handler.py .

# Download the default model so it's cached in the image.
RUN rembg d u2net

# Set the command to run the RunPod handler.
CMD ["python", "runpod_handler.py"]
