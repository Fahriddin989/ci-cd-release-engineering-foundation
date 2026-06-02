import time
from flask import request, Response
from prometheus_client import Counter, Histogram, Info, generate_latest, CONTENT_TYPE_LATEST

REQUEST_COUNT = Counter(
    "release_api_http_requests_total",
    "Total HTTP requests handled by release-api",
    ["method", "endpoint", "status"],
)

REQUEST_LATENCY = Histogram(
    "release_api_http_request_duration_seconds",
    "HTTP request latency for release-api",
    ["method", "endpoint", "status"],
)

APP_INFO = Info(
    "release_api_app",
    "release-api application information",
)


def init_metrics(app):
    APP_INFO.info({
        "service": "release-api",
        "version": app.config.get("APP_VERSION", "unknown"),
    })

    @app.before_request
    def start_timer():
        request._metrics_start_time = time.perf_counter()

    @app.after_request
    def record_metrics(response):
        if request.path == "/metrics":
            return response

        duration = time.perf_counter() - getattr(request, "_metrics_start_time", time.perf_counter())
        endpoint = request.path
        method = request.method
        status = str(response.status_code)

        REQUEST_COUNT.labels(method=method, endpoint=endpoint, status=status).inc()
        REQUEST_LATENCY.labels(method=method, endpoint=endpoint, status=status).observe(duration)

        return response

    @app.get("/metrics")
    def metrics():
        return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)
