NAME := rusqlite
WASM_TRPL := wasm32-unknown-unknown
# WASM_TRPL := wasm32-unknown-emscripten
WASM_DEBUG := target/$(WASM_TRPL)/debug/$(NAME).wasm
WASM_RELEASE := target/$(WASM_TRPL)/release/$(NAME).wasm
WASM_NPM_BIN := $(shell npm bin)/wa
SRC := $(shell find ./src -type f -name '*.rs')

# all: $(DEBUG) $(RELEASE) # $(WASM_DEBUG) $(WASM_RELEASE)
all: $(WASM_DEBUG) # $(WASM_RELEASE)
#  $(NAME).debug.wast $(NAME).release.wast

$(WASM_DEBUG): $(SRC)
	cargo build --target $(WASM_TRPL)

$(WASM_RELEASE): $(SRC)
	cargo build --target $(WASM_TRPL) --release

$(NAME).debug.wast: $(WASM_DEBUG)
	$(WASM_NPM_BIN) disassemble -o $(NAME).debug.wast $(WASM_DEBUG)

$(NAME).release.wast: $(WASM_RELEASE)
	$(WASM_NPM_BIN) disassemble -o $(NAME).release.wast $(WASM_RELEASE)

.PHONY: install
install:
	rustup target add $(WASM_TRPL)
	# cargo install wasm-bindgen
