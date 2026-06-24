NAME=zpm
SRC=src/main.lua

PREFIX ?= /usr/local

LUAJIT_INC=/usr/include/luajit-2.1
LUAJIT_LIB=/usr/lib/aarch64-linux-gnu

.PHONY: all build install uninstall clean check

all: build

check:
	@command -v luajit >/dev/null || (echo "Missing LuaJIT"; echo "Install: sudo apt install luajit"; exit 1)
	@command -v luastatic >/dev/null || (echo "Missing luastatic"; echo "Install: sudo luarocks install luastatic"; exit 1)

build: check
	@echo "Building $(NAME)..."

	luastatic $(SRC) \
		-lluajit-5.1 \
		-I$(LUAJIT_INC) \
		-L$(LUAJIT_LIB)

	mv -f main $(NAME)
	chmod +x $(NAME)

	@echo "Built $(NAME)"

install:
	install -Dm755 ./zpm /usr/bin/zpm
	@echo "Installed: /usr/bin/zpm"

uninstall:
	rm -f $(PREFIX)/bin/$(NAME)
	@echo "Uninstalled $(NAME)"

clean:
	rm -f $(NAME)
	rm -f main.luastatic.c
	@echo "Cleaned"
