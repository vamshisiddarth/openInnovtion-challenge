FROM python:3.9-slim
LABEL authors="vamshisiddarthgaddam"

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Set environment variables. These can be later override by configmap/secret
ENV DB_PASSWORD=""
ENV DB_HOST=""

EXPOSE 8080

CMD ["python", "app.py"]