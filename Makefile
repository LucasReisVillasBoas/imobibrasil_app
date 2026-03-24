.PHONY: help setup check lint format test coverage build clean

help:
	@echo ""
	@echo "  ImobiBrasil App — Comandos disponíveis"
	@echo ""
	@echo "  make setup     Instala dependências"
	@echo "  make check     Lint + testes (roda antes do commit)"
	@echo "  make lint      Analisa o código"
	@echo "  make test      Roda todos os testes"
	@echo "  make coverage  Testes com cobertura"
	@echo "  make build     Build web de produção"
	@echo "  make clean     Limpa build artifacts"
	@echo ""

setup:
	flutter pub get

lint:
	flutter analyze --fatal-infos --fatal-warnings

format:
	dart format lib/ test/ --set-exit-if-changed

test:
	flutter test --reporter expanded

coverage:
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html

build:
	flutter build web --release

clean:
	flutter clean
	flutter pub get

check: lint test
	@echo ""
	@echo "  ✅ Lint e testes passando — pronto para commit!"
	@echo ""
