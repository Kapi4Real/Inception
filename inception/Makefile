SHELL := /bin/bash

.PHONY: help setup build up down logs ps clean fclean re start stop

help:
	@echo "Inception Docker Project - Available commands:"
	@echo ""
	@echo "  make setup      - Initial setup (creates directories, updates paths)"
	@echo "  make build      - Build all Docker images"
	@echo "  make up         - Start all services"
	@echo "  make down       - Stop all services"
	@echo "  make restart    - Restart all services"
	@echo "  make logs       - View service logs"
	@echo "  make ps         - Show service status"
	@echo "  make clean      - Stop services and remove images"
	@echo "  make fclean     - Stop and remove everything (data preserved in ~/data)"
	@echo "  make re         - Full rebuild from scratch"
	@echo ""

setup:
	@bash setup.sh

build:
	@docker-compose build

up: build
	@docker-compose up -d
	@echo "✓ Services started. Access WordPress at https://localhost"

start:
	@docker-compose up -d

down:
	@docker-compose down

stop:
	@docker-compose stop

restart:
	@docker-compose restart

logs:
	@docker-compose logs -f

ps:
	@docker-compose ps

clean:
	@docker-compose down --remove-orphans

fclean: clean
	@docker-compose down -v --remove-orphans
	@echo "✓ All containers and volumes removed. Data in ~/data/ is preserved."

re: fclean setup up

.DEFAULT_GOAL := help

