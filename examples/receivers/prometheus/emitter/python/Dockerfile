FROM python:3.7-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install python dependencies
COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

# Setup directory structure
RUN mkdir -p /app
WORKDIR /app

# Copy source code
COPY . /app

# Expose port
EXPOSE 5000

# Run the application
CMD ["python", "main.py"]
