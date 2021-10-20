
BIN ?= pad
PREFIX ?= /usr/local
PAD_SOCKET=/home/pad/.socket

install:
	@useradd -m -d /home/pad -s /bin/bash pad 2> /dev/null || true
	@usermod -G pad $(shell logname)
	@touch ${PAD_SOCKET}
	@chown pad:pad ${PAD_SOCKET}
	@chmod 777 ${PAD_SOCKET}
	@echo pad start > /home/pad/.bashrc
	@apt-get install -y --no-install-recommends openssh-server > /dev/null
	@echo "Set SSH password for the pad user"
	@passwd -q pad
	@cp pad $(PREFIX)/bin/$(BIN)
	@chmod +x $(PREFIX)/bin/$(BIN)
	@echo Installation complete. Follow this step:
	@echo 1. Restart your PC.
	@echo 2. Connect via SSH the pad user.

uninstall:
	@rm -f $(PREFIX)/bin/$(BIN)

connect:
	@ssh pad@127.0.0.1
