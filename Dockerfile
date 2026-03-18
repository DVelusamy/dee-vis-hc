FROM python:3.9-slim

WORKDIR /app

# Install CPU-only PyTorch first (saves ~2GB vs CUDA version)
RUN pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu

# Install remaining dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Make start script executable
RUN chmod +x start.sh

# Default API_BASE for in-container communication
ENV API_BASE=http://localhost:8000

# Expose Streamlit port (Railway serves one port)
EXPOSE 8501

CMD ["./start.sh"]
