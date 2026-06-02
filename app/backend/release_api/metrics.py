import os
import time

from flask import Response, request
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Histogram, Info, generate_latest

REQUEST_COUNT = Counter(
    "release_api_http_requests_total",
    "Total HTTP requests handled by release-api",
    ["method", "path", "status"],
)

REQUEST_LATENCY = Histogram(
    "release_api_http_request_duration_seconds",
    "HTTP request latency for release-api",
    ["method", "path", "status"],
)

APP_INFO = Info(
    "release_api_app",
    "release-api application information",
)


def init_metrics(app):
    APP_INFO.info({
        "service": "release-api",
        "version": os.getenv("APP_VERSION", app.config.get("APP_VERSION", "unknown")),
    })

    @app.before_request
    def start_timer():
        request._metrics_start_time = time.perf_counter()

    @app.after_request
    def record_metrics(response):
        if request.path == "/metrics":
            return response

        duration = time.perf_counter() - getattr(
            request,
            "_metrics_start_time",
            time.perf_counter(),
        )

        REQUEST_COUNT.labels(
            method=request.method,
            path=request.path,
            status=str(response.status_code),
        ).inc()

        REQUEST_LATENCY.labels(
            method=request.method,
            path=request.path,
            status=str(response.status_code),
        ).observe(duration)

        return response

    @app.get("/metrics")
    def metrics():
        return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)
