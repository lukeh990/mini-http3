# Project settings
TARGET      := mini-http3
SRC_DIR     := src
BUILD_DIR   := dist
BIN_DIR     := bin
GEN_INC_DIR := include/generated

# Compiler settings
CXX         := g++
CXXFLAGS    := -Wall -Wextra -O2 -std=c++23 -Iinclude

# Collect all source files recursively
SRCS        := $(shell find $(SRC_DIR) -name '*.cpp')
# Map source files to object files in BUILD_DIR
OBJS        := $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(SRCS))

# Final binary
TARGET_BIN  := $(BIN_DIR)/$(TARGET)

MAJOR_V    := "1"
MINOR_V    := "0"
HOTFIX_V   := "0"
VERSION_H  := $(GEN_INC_DIR)/version.h
CXXFLAGS   += -I$(GEN_INC_DIR)
GIT_HASH   := $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
BUILD_DATE := $(shell date -u +"%Y-%m-%d %H:%M:%S %z")

# Default target
.PHONY: build
build: $(TARGET_BIN)

# Link the binary
$(TARGET_BIN): $(OBJS) | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJS)

# Compile source files to object files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Ensure output directories exist
$(BIN_DIR):
	mkdir -p $@

$(BUILD_DIR):
	mkdir -p $@

$(GEN_INC_DIR):
	mkdir -p $@

.PHONY: $(VERSION_H)
$(VERSION_H): $(GEN_INC_DIR)
	echo "#pragma once" > $@
	echo "#define BUILD_VERSION \"$(GIT_HASH) ($(BUILD_DATE))\"" >> $@
	echo "#define RELEASE_VERSION \"$(MAJOR_V).$(MINOR_V).$(HOTFIX_V)\"" >> $@

$(OBJS): $(VERSION_H)

# Clean build artifacts
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR) $(GEN_INC_DIR)

.PHONY: run
run: $(TARGET_BIN)
	$(TARGET_BIN)
