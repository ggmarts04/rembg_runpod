FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Download the default model
RUN rembg d u2net

CMD ["python", "runpod_handler.py"]
