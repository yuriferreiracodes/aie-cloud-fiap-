# Multi-stage build para imagem leve.
FROM python:3.11-slim AS builder

WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --target=/install -r requirements.txt

# Imagem final
FROM python:3.11-slim

WORKDIR /app
COPY --from=builder /install /usr/local/lib/python3.11/site-packages
COPY app.py .

EXPOSE 8080

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]
