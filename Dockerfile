# ---- builder stage ----
FROM python:3.9-slim AS builder

WORKDIR /build

# Install CPU-only PyTorch first (saves ~2GB vs CUDA version)
RUN pip install --no-cache-dir --prefix=/install torch --index-url https://download.pytorch.org/whl/cpu

# Install remaining dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Strip .dist-info, __pycache__, tests, and pip metadata to save space
RUN find /install -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null; \
    find /install -type d -name "*.dist-info" -exec rm -rf {} + 2>/dev/null; \
    find /install -type d -name "tests" -exec rm -rf {} + 2>/dev/null; \
    find /install -type d -name "test" -exec rm -rf {} + 2>/dev/null; \
    find /install -name "*.pyc" -delete 2>/dev/null; \
    true

# ---- final stage ----
FROM python:3.9-slim

WORKDIR /app

# Copy only the installed packages from builder
COPY --from=builder /install /usr/local

# Copy application code
COPY . .

# Make start script executable
RUN chmod +x start.sh

# Default API_BASE for in-container communication
ENV API_BASE=http://localhost:8000

# Expose Streamlit port (Railway serves one port)
EXPOSE 8501

CMD ["./start.sh"]
