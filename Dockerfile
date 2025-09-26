# Use the official Python image.
FROM python:3.10-slim

# Set the working directory.
WORKDIR /app

# Copy the application files.
COPY . .

# Install the rembg package and all its dependencies.
RUN pip install ".[cpu,cli]"

# Set the command to run the RunPod handler.
CMD ["python", "runpod_handler.py"]
