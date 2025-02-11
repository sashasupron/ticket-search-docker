#!/bin/bash

docker-compose -f compose-test.yaml up -d tbsky-booking-db-test redis-test tbsky-booking-test \
    && docker-compose -f compose-test.yaml exec tbsky-booking-test \
    bash -c "PYTHONPATH=./:\$PYTHONPATH poetry run pytest --cov=tbsky_booking --cov-report=term-missing:skip-covered --cov-fail-under=80 -vv tests/"
docker-compose -f compose-test.yaml kill tbsky-booking-db-test redis-test tbsky-booking-test