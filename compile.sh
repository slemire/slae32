#!/bin/bash

echo '[+] Assembling with Nasm ... '
nasm -f elf32 -o $1.o $1.asm

if [ $? -eq 0 ]
then
	echo '[+] Linking ...'
	ld -o $1 $1.o
else
	exit
fi

if [ $? -eq 0 ]
then
	shellcode=$(objdump -d ./$1|grep '[0-9a-f]:'|grep -v 'file'|cut -f2 -d:|cut -f1-6 -d' '|tr -s ' '|tr '\t' ' '|sed 's/ $//g'|sed 's/ /\\x/g'|paste -d '' -s |sed 's/^/"/'|sed 's/$/"/g'|sed 's/"//g')
	shellcode_len=$(echo -ne $shellcode | wc -c)
	echo "[+] Shellcode: $shellcode"
	echo -n '[+] Length: '; echo $shellcode_len
	if [[ "$shellcode" =~ "x00" ]]
	then
		echo '[>] Warning! NULL characters detected in shellcode!'
	fi
	echo '[+] Done!'
else
	exit
fi
