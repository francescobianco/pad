
BIN := pad
PREFIX := /usr/local

install:
	cp pad $(PREFIX)/bin/$(BIN)

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)
