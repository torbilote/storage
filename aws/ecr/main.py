from fastapi import FastAPI
from datetime import datetime
import platform

app = FastAPI(title="Test API", description="Simple FastAPI app for AWS Fargate testing", version="1.0.0")


@app.get("/")
def root():
    return {
        "message": "Hello from AWS Fargate!",
        "status": "running",
        "timestamp": datetime.utcnow().isoformat(),
    }


@app.get("/health")
def health_check():
    return {"status": "healthy"}


@app.get("/info")
def info():
    return {
        "python_version": platform.python_version(),
        "system": platform.system(),
        "machine": platform.machine(),
        "timestamp": datetime.utcnow().isoformat(),
    }