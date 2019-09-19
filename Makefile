setup-dev:
	docker-compose build

start-dev:
	docker-compose up -d

stop-dev:
	docker-compose down

run-tests:
	docker-compose exec app bash -c "rspec"

deploy-production:
	docker-compose exec app bash -c "cap production deploy"