import {
    CloudWatchLogsClient,
    CreateLogGroupCommand,
    CreateLogStreamCommand,
    PutLogEventsCommand,
  } from "@aws-sdk/client-cloudwatch-logs";
  
  export class CloudWatchLogger {
    private client: CloudWatchLogsClient;
    private logGroupName: string;
    private logStreamName: string;
    private sequenceToken: string | undefined;
  
    constructor(region: string, logGroupName: string, logStreamName: string) {
      this.client = new CloudWatchLogsClient({ region });
      this.logGroupName = logGroupName;
      this.logStreamName = logStreamName;
      this.sequenceToken = undefined;
    }
  
    /**
     * Initializes the CloudWatch log group and stream.
     */
    async initialize(): Promise<void> {
      try {
        // Create Log Group
        await this.client.send(
          new CreateLogGroupCommand({ logGroupName: this.logGroupName })
        );
        console.log(`Log group ${this.logGroupName} created.`);
      } catch (err: any) {
        if (err.name !== "ResourceAlreadyExistsException") {
          console.error("Error creating log group:", err);
          throw err;
        }
      }
  
      try {
        // Create Log Stream
        await this.client.send(
          new CreateLogStreamCommand({
            logGroupName: this.logGroupName,
            logStreamName: this.logStreamName,
          })
        );
        console.log(`Log stream ${this.logStreamName} created.`);
      } catch (err: any) {
        if (err.name !== "ResourceAlreadyExistsException") {
          console.error("Error creating log stream:", err);
          throw err;
        }
      }
    }
  
    /**
     * Sends a log message to CloudWatch.
     * @param message - The log message to send.
     */
    async sendLog(message: string): Promise<void> {
      try {
        const params = {
          logGroupName: this.logGroupName,
          logStreamName: this.logStreamName,
          logEvents: [
            {
              message,
              timestamp: Date.now(),
            },
          ],
          sequenceToken: this.sequenceToken,
        };
  
        const response = await this.client.send(new PutLogEventsCommand(params));
  
        // Update the sequence token for the next log
        if (response.nextSequenceToken) {
          this.sequenceToken = response.nextSequenceToken;
        }
      } catch (err: any) {
        console.error("Error sending log:", err);
        throw err;
      }
    }
  }
  