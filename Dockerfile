FROM python:3.10-bullseye as builder

# Stage 1: Build environment with all necessary tools
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    wget \
    unzip \
    git \
    curl \
    libopenblas-dev \
    liblapack-dev \
    libx11-dev \
    libgtk-3-dev \
    libboost-all-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install specific CMake version (required for dlib)
RUN wget https://github.com/Kitware/CMake/releases/download/v3.27.9/cmake-3.27.9-linux-x86_64.sh && \
    chmod +x cmake-3.27.9-linux-x86_64.sh && \
    ./cmake-3.27.9-linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm cmake-3.27.9-linux-x86_64.sh

WORKDIR /app

# Install dlib with specific environment variables
ENV DLIB_USE_CUDA=0
RUN pip install --upgrade pip && \
    pip install numpy==1.26.4 && \
    pip install dlib==19.24.2 --verbose

# Final stage
FROM python:3.10-slim-bullseye

# Install runtime dependencies only
RUN apt-get update && apt-get install -y \
    libopenblas0 \
    liblapack3 \
    libx11-6 \
    libgtk-3-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy from builder
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY . .

# Environment variables
ENV FLASK_APP=app.py
ENV FLASK_ENV=production

EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "app:app"]