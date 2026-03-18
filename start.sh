#!/usr/bin/env bash
set -e

# Start FastAPI backend in the background
uvicorn src.main:app --host 0.0.0.0 --port 8000 &

# Give uvicorn time to bind to port 8000
sleep 3

# Start Streamlit frontend in the foreground
exec streamlit run streamlit_app/Home.py \
  --server.port 8501 \
  --server.address 0.0.0.0 \
  --server.headless true
