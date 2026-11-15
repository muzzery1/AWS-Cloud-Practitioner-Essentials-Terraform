console.log('Loading function');

export const handler = async (event) => {
    for (const {messageId, body} of event.Records) {
        console.log('SQS message %s: %j', messageId, body);
    }
    return `Successfully processed ${event.Records.length} messages.`;
}