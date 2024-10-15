#!/bin/bash

echo "Starting services …"
node service_a.js &
SERVICE_A_PID=$!
node service_b.js &
SERVICE_B_PID=$!

# Warten, bis die Services gestartet sind
sleep 2

# Funktion, um den Trace mit otel-cli zu starten und Service A aufzurufen
call_service_A() {
    echo "Calling Service A …"
    # Aufruf von Service A mit dem Trace-Kontext
    RESPONSE=$(curl http://0.0.0.0:8400/serviceA)
    echo "Response from Service A: $RESPONSE"
}

# Aufruf von Service A
call_service_A

# Stoppe die Services
kill $SERVICE_A_PID
kill $SERVICE_B_PID