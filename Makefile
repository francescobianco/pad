
BIN ?= pad
PREFIX ?= /usr/local
PAD_HOME ?= /home/pad/
PAD_SOCKET ?= /home/pad/.socket
USER := $(shell logname)
HOME := $(shell getent passwd $(shell logname) | cut -d: -f6)
HOST := $(shell hostname)

install:
	@useradd -m -d ${PAD_HOME} -s /bin/bash pad 2> /dev/null || true
	@usermod -a -G pad $(USER)
	@touch ${PAD_SOCKET}
	@chown pad:pad ${PAD_SOCKET}
	@chmod 777 ${PAD_SOCKET}
	@echo pad start > $(PAD_HOME)/.bashrc
	@touch $(HOME)/.padrc
	@apt-get install -y --no-install-recommends openssh-server > /dev/null
	@rm -f $(HOME)/.ssh/pad
	@ssh-keygen -t rsa -q -N "" -f $(HOME)/.ssh/pad -C "$(USER)@$(HOST)"
	@cat ${HOME}/.ssh/pad.pub >> ${HOME}/.ssh/authorized_keys
	@chown $(USER):$(USER) $(HOME)/.ssh/pad $(HOME)/.ssh/pad.pub
	@chmod 400 $(HOME)/.ssh/pad $(HOME)/.ssh/pad.pub
	@chmod og-wx ${HOME}/.ssh/authorized_keys
	@cp pad $(PREFIX)/bin/$(BIN)
	@chmod +x $(PREFIX)/bin/$(BIN)
	@echo Installation complete.

uninstall:
	@rm -f $(PREFIX)/bin/$(BIN)

connect:
	@ssh pad@127.0.0.1
