FROM python:3.10-slim-bullseye

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libopenblas0 \
    liblapack3 \
    libx11-6 \
    libgtk-3-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install from pre-built wheels
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install numpy==1.26.4 && \
    pip install https://files.pythonhosted.org/packages/8f/2f/14a6057f6c0b6f0b3b8b3f8f8b8b3f8b8b3f8b8b3f8b8b3f8b8b3f8b8b3/dlib-19.24.2-cp310-cp310-manylinux_2_31_x86_64.whl && \
    pip install -r requirements.txt

COPY . .

EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]