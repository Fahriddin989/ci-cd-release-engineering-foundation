import os
import socket

from flask import Blueprint, jsonify

api = Blueprint("api", __name__)


def service_payload(status):
    return {
        "service": os.getenv("SERVICE_NAME", "release-api"),
        "version": os.getenv("APP_VERSION", "0.1.0"),
        "hostname": socket.gethostname(),
        "status": status,
    }


@api.get("/")
def index():
    payload = service_payload("ok")
    payload["message"] = "CI/CD Release Engineering Foundation"
    return jsonify(payload), 200


@api.get("/health")
def health():
    return jsonify(service_payload("ok")), 200


@api.get("/ready")
def ready():
    return jsonify(service_payload("ready")), 200
