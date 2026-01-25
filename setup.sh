#!/bin/bash

ac="nasm"
pc="g++"
cc="gcc"
ylw="\e[33m"
rst="\e[0m"
grn="\e[32m"
red="\e[31m"
createbin=$(mkdir ~/bin)
cbc=$(g++ ./binaryConverter/main.cpp -o ~/bin/binary -lm)
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
	echo -e "\033[2C${ylw}Attempting to compile${rst}"
	if [ -d "~/bin" ]; then
		echo -e "\t ${grn}~/bin already exists ${rst}"
	else
		$createbin || echo -e "\t ${red} Failed to create bin folder (might already exist) ${rst}"
	fi
	if $cbc; then
		echo -e "\t ${grn} Succesfully compiled binary converter ${rst}"
	else
		$cbc || echo -e "\t ${red} Failed to compile to bin ${rst}"
	fi
	
else
	echo "Unknown Mode Selected"
fi
