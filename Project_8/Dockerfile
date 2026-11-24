# Small official Python image
FROM python:3.12-slim

# Do not write .pyc files; show logs immediately
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install dependencies first so Docker can cache this layer
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY app.py .

# Run as a normal user, not root
RUN useradd --create-home appuser
USER appuser

EXPOSE 5000

# Production-style web server instead of Flask's development server
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
