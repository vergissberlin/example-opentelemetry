FROM golang:1.23-alpine

# Create and set the working directory
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Install the dependencies
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the application
RUN go build -o /dice-service

EXPOSE 8020

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD wget -qO- http://localhost:8020/health || exit 1

CMD ["/dice-service"]
