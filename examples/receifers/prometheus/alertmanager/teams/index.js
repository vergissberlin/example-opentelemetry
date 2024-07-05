import axios from 'axios';

var formatted_Card_Payload = {
    "type": "message",
    "attachments": [
        {
            "contentType": "application/vnd.microsoft.card.adaptive",
            "contentUrl": null,
            "content": {
                "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
                "type": "AdaptiveCard",
                "version": "1.2",
                "body": [
                    {
                        "type": "TextBlock",
                        "text": "Submitted response:"
                    }
                ]
            }
        }
    ]
}

var webhookUrl = "https://prod-156.westeurope.logic.azure.com:443/workflows/b8ae13484b124b148515273c843ccaf2/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=H2EBFv_xpXNWaTShyDnIpPN4CqkSYMaId3hydP280PM";

axios.post(webhookUrl , formatted_Card_Payload )
.then(res => {
    console.log(`statusCode: ${res.status}`)
    console.log(res)
})
.catch(error => {
    console.error(error)
})
