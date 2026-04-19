set shell := ["bash", "-euo", "pipefail", "-c"]
set dotenv-load

default:
    @just --list

help:
    @just --list

fmt:
    @echo "No formatter configured."

lint:
    @echo "No linter configured."

test:
    @echo "No tests configured."

clean:
    @echo "No clean step configured."

ci: lint test

setup:
    @echo "Setup steps go here."
