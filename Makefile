#!make

BIN ?= pad
PREFIX ?= /usr/local

PAD_LIB := /usr/lib/pad
PAD_CONF := /etc/pad.conf
PAD_SOCKET := /usr/lib/pad/pad.sock

USER := $(shell logname)
HOME := $(shell getent passwd $(shell logname) | cut -d: -f6)
HOST := $(shell hostname)

install: install-packages install-pad-user install-pad-socket install-pad-files update-logged-user
	@echo Installation complete.

install-packages:
	@apt-get install -y --no-install-recommends xterm openssh-server > /dev/null

install-pad-user:
	@groupadd -f pad
	@useradd -g pad -m -d $(PAD_LIB) -s /bin/bash pad 2> /dev/null || true
	@echo pad start > $(PAD_LIB)/.bashrc

install-pad-socket:
	@touch $(PAD_SOCKET)
	@chown pad:pad $(PAD_SOCKET)
	@chmod 777 $(PAD_SOCKET)

install-pad-files:
	@cp -f pad $(PREFIX)/bin/$(BIN)
	@cp -f .padrc $(PAD_LIB)/.padrc
	@chmod +x $(PREFIX)/bin/$(BIN)

update-logged-user:
	@usermod -a -G pad $(USER)
	@touch $(HOME)/.padrc
	@rm -f $(HOME)/.ssh/pad
	@ssh-keygen -t rsa -q -N "" -f $(HOME)/.ssh/pad -C "$(USER)@$(HOST)"
	@cat $(HOME)/.ssh/pad.pub >> $(HOME)/.ssh/authorized_keys
	@chown $(USER):$(USER) $(HOME)/.ssh/pad $(HOME)/.ssh/pad.pub
	@chmod 400 $(HOME)/.ssh/pad $(HOME)/.ssh/pad.pub
	@chmod og-wx ${HOME}/.ssh/authorized_keys

uninstall:
	@rm -f $(PREFIX)/bin/$(BIN)
	@deluser --remove-home pad

connect:
	@ssh pad@127.0.0.1

## =====
## Tests
## =====
test-install:
	@sudo make -s install

test-shell:
	@sudo make -s install
	@pad shell
