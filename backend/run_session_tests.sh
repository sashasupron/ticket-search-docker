#!/bin/bash

docker-compose -f compose-test.yaml up -d tbsky-session-db-test redis-test tbsky-session-test \
    && docker-compose -f compose-test.yaml exec tbsky-session-test \
    bash -c "PYTHONPATH=./:\$PYTHONPATH poetry run pytest --cov=tbsky_session --cov-report=term-missing:skip-covered --cov-fail-under=80 -vv tests/"
docker-compose -f compose-test.yaml kill tbsky-session-db-test redis-test tbsky-session-test
