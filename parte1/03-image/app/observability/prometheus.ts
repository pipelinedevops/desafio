import express, { Application, Request, Response } from "express";
import { Counter, Gauge, Histogram, Registry, collectDefaultMetrics } from "prom-client";

class PrometheusMetrics {
  private app: Application;
  private port: number;
  private registry: Registry;
  public requestsCounter: Counter<string>;
  public activeUsersGauge: Gauge<string>;
  public responseTimeHistogram: Histogram<string>;

  constructor(port: number = 3000) {
    this.app = express();
    this.port = port;

    // Create a custom registry
    this.registry = new Registry();

    // Register default system metrics (CPU, memory, etc.)
    collectDefaultMetrics({ register: this.registry });

    // Define custom metrics
    this.requestsCounter = new Counter({
      name: "http_requests_total",
      help: "Total number of HTTP requests",
      labelNames: ["method", "endpoint"],
    });

    this.activeUsersGauge = new Gauge({
      name: "active_users",
      help: "Number of active users in the system",
    });

    this.responseTimeHistogram = new Histogram({
      name: "response_time_seconds",
      help: "Response time in seconds",
      buckets: [0.1, 0.5, 1, 2.5, 5], // Buckets for histogram
      labelNames: ["method", "endpoint"],
    });

    // Register custom metrics
    this.registry.registerMetric(this.requestsCounter);
    this.registry.registerMetric(this.activeUsersGauge);
    this.registry.registerMetric(this.responseTimeHistogram);

    // Expose metrics at /metrics endpoint
    this.app.get("/metrics", async (_req: Request, res: Response) => {
      try {
        res.set("Content-Type", this.registry.contentType);
        res.send(await this.registry.metrics());
      } catch (err) {
        res.status(500).send(err);
      }
    });
  }

  /**
   * Starts the HTTP server to expose metrics.
   */
  public startServer(): void {
    this.app.listen(this.port, () => {
      console.log(`Prometheus metrics server running on http://localhost:${this.port}/metrics`);
    });
  }
}

export default PrometheusMetrics;
