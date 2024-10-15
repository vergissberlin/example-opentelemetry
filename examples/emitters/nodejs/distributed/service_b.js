const express = require('express');
const { trace } = require('@opentelemetry/api');

const app = express();
const PORT = 8410;

app.get('/serviceB', (req, res) => {
    // Starten eines neuen Traces
    const tracer = trace.getTracer('serviceB');
    const span = tracer.startSpan('serviceB_request');

    // Verarbeitung des Antrags
    span.end();
    res.send('Hello from Service B!');
});

app.listen(PORT, () => {
    console.log(`Service B running on port ${PORT}`);
});