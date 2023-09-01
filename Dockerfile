# Builder stage
FROM python:3.12.0b4-alpine AS builder

RUN apk update && \
    apk add postgresql-client build-base libpq-dev postgresql-dev linux-headers libffi-dev libxslt-dev libxml2-dev \
    libjpeg zlib-dev jpeg-dev gcc musl-dev libxslt libxml2
    
# create the virtual environment
RUN python -m venv /opt/venv
    
# Activate the virtual environment
ENV PATH="/opt/venv/bin:$PATH"
    
COPY requirements /requirements

RUN pip install --upgrade pip && \
    pip install -r /requirements/base.txt


# Operational stage
FROM python:3.12.0b4-alpine

RUN apk update && \
    apk add postgresql-client build-base libpq-dev postgresql-dev linux-headers libffi-dev libxslt-dev libxml2-dev
    
COPY --from=builder /opt/venv /opt/venv

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    PATH="/opt/venv/bin:$PATH"
