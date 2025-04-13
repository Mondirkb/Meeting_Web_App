FROM python:3.10-slim-bullseye

# Install minimal runtime dependencies first
RUN apt-get update && apt-get install -y \
    libopenblas0 \
    liblapack3 \
    libx11-6 \
    libgtk-3-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements first for caching
COPY requirements.txt .

# Install Python dependencies (no build tools needed)
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir numpy==1.26.4 && \
    pip install --no-cache-dir dlib==19.24.6 --no-binary=dlib && \
    pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create directory for database
RUN mkdir -p /app/instance && \
    chmod 777 /app/instance

# Environment variables
ENV FLASK_APP=app.py
ENV FLASK_ENV=production
ENV SECRET_KEY=your-secret-key-here
ENV SQLALCHEMY_DATABASE_URI=sqlite:////app/instance/moundir.db
ENV SQLALCHEMY_TRACK_MODIFICATIONS=False
ENV WTF_CSRF_ENABLED=False
ENV PORT=8000

# Reduce Gunicorn workers to save memory
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:$PORT --workers 1 --threads 2 --timeout 120 app:app"]