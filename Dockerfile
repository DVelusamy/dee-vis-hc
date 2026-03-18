FROM python:3.9-slim

WORKDIR /app

# Install dependencies first for better layer caching
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
