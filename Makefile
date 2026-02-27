# Makefile for Home Automation Blynk Controlled System
# Based on the Industrial Machine Monitoring System Makefile

# Configuration
# If arduino-cli is in your PATH, it will be used. 
# Otherwise, it falls back to the hardcoded path.
ARDUINO_CLI ?= arduino-cli
LOCAL_CLI_PATH = "C:\Users\Manikanda Bharathi\AppData\Local\Programs\Arduino IDE\resources\app\lib\backend\resources\arduino-cli.exe"

# If the command in PATH fails, use the local path
ifeq ($(shell $(ARDUINO_CLI) version > /dev/null 2>&1 && echo ok),)
    ARDUINO_CLI = $(LOCAL_CLI_PATH)
endif

BOARD = arduino:avr:uno
PORT = COM3 

# Sketch paths
SKETCH = HomeAutomationBlynk.ino
BUILD_DIR = build

# Libraries and Cores
CORE = arduino:avr
# List of required libraries based on the includes in the .ino file
LIBS = "Ethernet" "Blynk" "LiquidCrystal I2C"

# Standard targets
.PHONY: all compile upload clean setup help

all: setup compile

setup:
	@if ! $(ARDUINO_CLI) version > /dev/null 2>&1; then \
		echo "ERROR: arduino-cli not found in PATH or at specified LOCAL_CLI_PATH."; \
		echo "Please install it or update the path in the Makefile."; \
		exit 1; \
	fi
	@echo "--- Initializing Arduino Environment ---"
	@$(ARDUINO_CLI) core update-index
	@$(ARDUINO_CLI) core install $(CORE)
	@$(ARDUINO_CLI) lib install $(LIBS)
	@echo "--- Setup Complete ---"

compile: 
	@echo "--- Compiling Project ---"
	@mkdir -p $(BUILD_DIR)
	$(ARDUINO_CLI) compile --fqbn $(BOARD) --build-path $(BUILD_DIR) $(SKETCH)

upload:
	@echo "--- Uploading to Arduino UNO ---"
	$(ARDUINO_CLI) upload -p $(PORT) --fqbn $(BOARD) --build-path $(BUILD_DIR) $(SKETCH)

clean:
	@echo "--- Cleaning build artifacts ---"
	rm -rf $(BUILD_DIR)

help:
	@echo "Available targets:"
	@echo "  make compile         - Compile the sketch into the /build folder"
	@echo "  make upload          - Compile and upload the sketch to the Arduino (check PORT)"
	@echo "  make all             - Setup environment and compile"
	@echo "  make setup           - Install required cores (arduino:avr) and libraries (Blynk etc.)"
	@echo "  make clean           - Remove build directories"
	@echo "  make help            - Show this help message"
