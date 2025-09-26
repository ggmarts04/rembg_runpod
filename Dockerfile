FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY runpod_handler.py .

CMD ["python", "runpod_handler.py"]
