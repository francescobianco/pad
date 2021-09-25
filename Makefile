
BIN ?= pad
PREFIX ?= /usr/local

install:
	@cp pad $(PREFIX)/bin/$(BIN)
	@chmod +x $(PREFIX)/bin/$(BIN)
	@echo Installation complete.

uninstall:
	@rm -f $(PREFIX)/bin/$(BIN)
