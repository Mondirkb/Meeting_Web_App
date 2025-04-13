FROM python:3.10-slim

# Install system dependencies
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

# Upgrade CMake (required for dlib)
RUN wget https://github.com/Kitware/CMake/releases/download/v3.27.9/cmake-3.27.9-linux-x86_64.sh && \
    chmod +x cmake-3.27.9-linux-x86_64.sh && \
    ./cmake-3.27.9-linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm cmake-3.27.9-linux-x86_64.sh

# Set working directory
WORKDIR /app

# First copy only requirements to cache the pip install step
COPY requirements.txt .

# Install Python dependencies in two stages
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt --ignore-installed

# Install dlib separately with build optimizations
RUN pip install --no-cache-dir dlib==19.24.2 --global-option=--yes --global-option="--no" --global-option="DLIB_USE_CUDA"

# Copy the rest of the application
COPY . .

# Set environment variables
ENV FLASK_APP=app.py
ENV FLASK_ENV=production

# Expose port
EXPOSE 8000

# Run the application
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "app:app"]