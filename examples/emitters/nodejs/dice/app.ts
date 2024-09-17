import { trace } from '@opentelemetry/api'
import express, { Express } from 'express'
import { rollTheDice } from './dice'

const PORT: number = parseInt(process.env.PORT || '8030')
const app: Express = express()

// Favicon
app.use('/favicon.ico', express.static('public/images/favicon.ico'));

// Roll the dice
app.get('/', (req, res) => {
    const rolls = req.query.rolls ? parseInt(req.query.rolls.toString()) : NaN
    if (isNaN(rolls)) {
        res
            .status(400)
            .send('Request parameter "rolls" is missing or not a number.')
        return
    }
    res.send(JSON.stringify(rollTheDice(rolls, 1, 6)))
})

// Health check
app.get('/health', (req, res) => {
    res.send('OK')
})

app.listen(PORT, () => {
    console.log(`Listening for requests on http://0.0.0.0:${PORT}?rolls=12`)
})
