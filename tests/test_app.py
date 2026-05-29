import os
import sys

sys.path.insert(0, os.path.abspath("app/backend"))

from release_api import create_app


def test_health_endpoint():
    app = create_app()
    client = app.test_client()

    response = client.get("/health")

    assert response.status_code == 200
    assert response.json["status"] == "ok"
    assert response.json["service"] == "release-api"


def test_ready_endpoint():
    app = create_app()
    client = app.test_client()

    response = client.get("/ready")

    assert response.status_code == 200
    assert response.json["status"] == "ready"


def test_app_version_from_environment(monkeypatch):
    monkeypatch.setenv("APP_VERSION", "test-version")

    app = create_app()
    client = app.test_client()

    response = client.get("/health")

    assert response.status_code == 200
    assert response.json["version"] == "test-version"
