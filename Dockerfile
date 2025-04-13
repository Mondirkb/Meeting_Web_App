FROM python:3.10-slim

# Install minimal dependencies
RUN apt-get update && apt-get install -y \
    libopenblas-dev \
    liblapack-dev \
    libx11-dev \
    libgtk-3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install from pre-built wheel
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir numpy==1.26.4 && \
    pip install --no-cache-dir https://github.com/jloh02/dlib-wheels/releases/download/v19.24.2/dlib-19.24.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]