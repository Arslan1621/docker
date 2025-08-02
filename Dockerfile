FROM python:3.9-slim-buster

WORKDIR /app

# Fix Debian Buster repo URLs and install system dependencies for PyMuPDF
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
    sed -i '/security.debian.org/d' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    libmupdf-dev \
    mupdf-tools \
    fontconfig && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "-m", "gunicorn", "src.main:app", "-b", "0.0.0.0:5000"]
