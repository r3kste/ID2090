# References:
# https://makefiletutorial.com
# https://stackoverflow.com/questions/24005166/gnu-make-silent-by-default
# https://www.gnu.org/software/make/manual/html_node/Wildcard-Function.html
# https://www.gnu.org/software/make/manual/make.html#Pattern-Intro
# https://www.positioniseverything.net/make-clean

# Uses silent mode
MAKEFLAGS += --silent

# Uses compiler as g++
# Flags given for g++ are -std=c++11 and -O3
# -std=c++11 is used to enable C++11 features
# -O3 is optimization level 3
CXX = g++
CXXFLAGS = -std=c++11 -O2

# Source files are all the .cpp files 
# Object files are the source files with .o extension
# Output file is main
SOURCES = $(wildcard *.cpp ./geometry/*.cpp)
OBJECTS = $(SOURCES:.cpp=.o)
OUTPUT = main

# Main target which depends on the source files and the Makefile
# It compiles the source files and creates the object files
$(OUTPUT): $(OBJECTS) Makefile
	$(CXX) $(CXXFLAGS) -o $(OUTPUT) $(OBJECTS)

# Target for each object file which is compiled from the corresponding source file
# $@ corresponds to the target name (.o file)
# $< corresponds to the dependency name (.cpp file)
# Uses -c flag to compile the source files without linking
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -o $@ -c $<

# Clean target
# PHONY Prevents make from thinking that clean is a file
.PHONY: clean

# Removes the output file and the object files
# Uses -f flag to ignore errors if the files do not exist
clean:
	rm -f $(OUTPUT) $(OBJECTS)
