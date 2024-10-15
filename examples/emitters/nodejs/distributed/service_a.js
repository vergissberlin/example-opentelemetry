const express = require('express');
const axios = require('axios');
const { trace, context, propagation } = require('@opentelemetry/api');

const app = express();
const PORT = 8400;

app.get('/serviceA', (req, res) => {
    // Starten eines neuen Traces
    const tracer = trace.getTracer('serviceA');
    const span = tracer.startSpan('serviceA_request');

    // Propagieren des Trace-Kontexts
    const traceparent = propagation.extract(context.active(), req.headers);
    if (traceparent) {
        propagation.inject(context.active(), req.headers);
    }

    // Aufruf von Service B
    axios.get('http://localhost:8410/serviceB', { headers: req.headers })
        .then(response => {
            span.end();
            res.send(`Response from Service B: ${response.data}`);
        })
        .catch(error => {
            span.end();
            res.status(500).send('Error calling Service B');
        });
});

app.listen(PORT, () => {
    console.log(`Service A running on port ${PORT}`);
});