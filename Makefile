NAME=zpm
SRC=src/main.lua

PREFIX ?= /usr/bin

LUAJIT_INC ?= /usr/include/luajit-2.1
LUAJIT_LIB ?= /usr/lib/aarch64-linux-gnu

CC ?= cc
LUASTATIC ?= luastatic

CFLAGS=-Os
LDFLAGS=-rdynamic -lm

.PHONY: all build install uninstall clean check

all: check build

check:
	@command -v $(CC) >/dev/null || (echo "Missing compiler"; exit 1)
	@command -v luajit >/dev/null || (echo "Missing luajit"; exit 1)
	@command -v $(LUASTATIC) >/dev/null || (echo "Missing luastatic"; exit 1)
	@test -e $(LUAJIT_LIB)/libluajit-5.1.so || (echo "Missing LuaJIT library"; exit 1)
	@echo "Dependencies OK"

build: check
	@echo "Building $(NAME)..."

	$(LUASTATIC) $(SRC) \
		-lluajit-5.1 \
		-I$(LUAJIT_INC) \
		-L$(LUAJIT_LIB)

	$(CC) $(CFLAGS) main.luastatic.c \
		$(LDFLAGS) \
		-L$(LUAJIT_LIB) \
		-l:libluajit-5.1.so \
		-I$(LUAJIT_INC) \
		-o $(NAME)

	chmod +x $(NAME)

	@echo "Built $(NAME)"

install:
	@test -f ./$(NAME) || (echo "Run make first"; exit 1)
	install -Dm755 ./$(NAME) $(PREFIX)/$(NAME)
	@echo "Installed $(PREFIX)/$(NAME)"

uninstall:
	rm -f $(PREFIX)/$(NAME)

clean:
	rm -f $(NAME)
	rm -f main.luastatic.c
	@echo "Cleaned"
