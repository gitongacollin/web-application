FROM python:3.12-slim-buster

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONBUFFERED 1
ENV FLASK_APP app.py
ENV FLASK_ENV production

EXPOSE 9420

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD []

