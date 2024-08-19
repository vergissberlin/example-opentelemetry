import { trace, Span, metrics } from '@opentelemetry/api'
const logsAPI = require('@opentelemetry/api-logs');

const tracer = trace.getTracer('dice-lib')
const meter = metrics.getMeter('dice-lib');
const logger = logsAPI.logs.getLogger('dice-lib');
const counter = meter.createCounter('dice-lib.rolls.counter');

export function rollOnce(i: number, min: number, max: number) {
    return tracer.startActiveSpan(`rollOnce: ${i}`, (span: Span) => {
        const result = Math.floor(Math.random() * (max - min) + min)

        // Add an attribute to the span
        span.setAttribute('dicelib.rolled', result.toString())
        span.end()
        return result
    })
}

export function rollTheDice(rolls: number, min: number, max: number) {
    logger.emit({
        severityNumber: logsAPI.SeverityNumber.INFO,
        severityText: 'INFO',
        body: 'rollTheDice called',
        attributes: { 'log.type': 'LogRecord' },
      });

    // Create a span. A span must be closed.
    return tracer.startActiveSpan('rollTheDice',
        { attributes: { 'dice-lib.rolls': rolls.toString() } }, (parentSpan: Span) => {
        const result: number[] = []
        for (let i = 0; i < rolls; i++) {
            result.push(rollOnce(i, min, max))
        }

        // Be sure to end the span!
        parentSpan.end()
        return result
    })
}
