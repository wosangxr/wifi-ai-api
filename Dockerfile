FROM python:3.11-slim

# 1. ติดตั้ง System Dependencies สำหรับ OpenCV
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2. ติดตั้ง Python Libraries
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 3. 🔥 จุดสำคัญ: สั่งให้ EasyOCR โหลดโมเดลภาษาอังกฤษลงใน Image ไปเลย
# วิธีนี้จะช่วยลดเวลาตอน API เริ่มทำงานได้มหาศาล
RUN python -c "import easyocr; easyocr.Reader(['en'], gpu=False)"

# 4. Copy โค้ดทั้งหมดเข้าเครื่อง
COPY . .

# 5. ตั้งค่า Port (Cloud Run จะใช้ PORT จาก Env)
EXPOSE 5000

CMD ["python", "app.py"]
