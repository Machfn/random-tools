#!/bin/bash

# SETUP SCRIPT to compile functions to ~/bin directory, you will need to add ~/bin to path
# usage:
# 	./setup.sh def -> runs default setup



ac="nasm"
pc="g++"
cc="gcc"
gc="go"
ylw="\e[33m"
rst="\e[0m"
grn="\e[32m"
red="\e[31m"
createbin=$(mkdir ~/bin)
cgc=$(go build -o ~/bin/sendTo ./webFunctions/sendTo.go)
cbc=$(g++ ./binaryConverter/main.cpp -o ~/bin/binary -lm)
cwt=$(cd fileFunctions; ./compile.sh writeTo)
cct=$(cd fileFunctions; ./compile.sh caw)
command_exists() {
	command -v "$1" > /dev/null 2>&1
}
if [ "$1" == "def" ]
then 
	echo "Default Setup Selected"
	echo -e "\033[2C${ylw}Checking for compilers${rst}"
	if command_exists "$ac"; then
		echo -e "\t ${grn}nasm assembly compiler installed${rst}"
	else
		echo -e "\t ${red}nasm not installed${rst}"
		exit 1
	fi
	if command_exists "$pc"; then
		echo -e "\t ${grn}g++ C++ compiler installed${rst}"
	else
		echo -e "\t ${red}g++ not installed${rst}"
		exit 1
	fi
	if command_exists "$cc"; then
		echo -e "\t ${grn}gcc C compiler installed${rst}"
	else
		echo -e "\t ${red}gcc not installed${rst}"
		exit 1
	fi
	if command_exists "$gc"; then
		echo -e "\t ${grn}go build tool installed${rst}"
	else
		echo -e "\t ${red}go not installed${rst}"
		exit 1
	fi
	echo -e "\033[2C${ylw}Attempting to compile${rst}"
	if [ -d "~/bin" ]; then
		echo -e "\t ${grn}~/bin already exists ${rst}"
	else
		$createbin || echo -e "\t ${red}Failed to create bin folder (might already exist) ${rst}"
	fi
	if $cbc; then
		echo -e "\t ${grn}Succesfully compiled binary converter ${rst}"
	else
		$cbc || echo -e "\t ${red}Failed to compile binary converter to bin ${rst}"
	fi
	if $cwt; then
		echo -e "\t ${grn}Successfully compiled file writer ${rst}"
	else
		$cwt || echo -e "\t ${red}Failed to compile file writer to bin ${rst}"
	fi
	if $cgc; then
		echo -e "\t ${grn}Successfully built sendTo function ${rst}"
	else
		$cgc || echo -e "\t ${red}Failed to build sendTo function to bin ${rst}"
	fi
	if $cct; then
		echo -e "\t ${grn}Succesfully built caw function ${rst}"
	else
		$cgc || echo -e "\t ${red}Failed to build caw function to bin ${rst}"
	fi
	
else
	echo "Unknown Mode Selected"
fi
