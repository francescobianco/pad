
BIN ?= pad
PREFIX ?= /usr/local
PAD_HOME ?= /home/pad/
PAD_SOCKET ?= /home/pad/.socket

install:
	@useradd -m -d ${PAD_HOME} -s /bin/bash pad 2> /dev/null || true
	@usermod -a -G pad $(shell logname)
	@touch ${PAD_SOCKET}
	@chown pad:pad ${PAD_SOCKET}
	@chmod 777 ${PAD_SOCKET}
	@echo pad start > ${PAD_HOME}.bashrc
	@apt-get install -y --no-install-recommends openssh-server > /dev/null
	@cp pad $(PREFIX)/bin/$(BIN)
	@chmod +x $(PREFIX)/bin/$(BIN)
	@echo Installation complete.

uninstall:
	@rm -f $(PREFIX)/bin/$(BIN)

connect:
	@ssh pad@127.0.0.1
