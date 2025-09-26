FROM python:3.10-slim

WORKDIR /app

# Copy all files from the build context first
COPY . .

# List the files in the current directory to see what's in the build context
RUN ls -la

# Now, install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "runpod_handler.py"]
