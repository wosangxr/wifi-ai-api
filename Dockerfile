FROM python:3.11-slim

# ติดตั้ง System Dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 🔥 จุดตาย: สั่งให้มันโหลด Model ลงเครื่องตอนนี้เลย (ตอน Build)
# เพื่อที่เวลารันจริง (Deploy) มันจะได้ไม่ต้องโหลดอีก
RUN python -c "import easyocr; easyocr.Reader(['en'], gpu=False)"

COPY . .

# ใช้ PORT จาก Environment ของ Google Cloud
ENV PORT 5000
EXPOSE 5000

CMD ["python", "app.py"]
