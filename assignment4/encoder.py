#!/usr/bin/python

import socket
import struct
import sys

if len(sys.argv) < 2:
	print('Usage: {name} [shellcode_file]'.format(name = sys.argv[0]))
	exit(1)

shellcode_file = sys.argv[1]

# Read shellcode from file in '\xFF\xEE\xDD' format
with open(shellcode_file) as f:
	shellcode_original = bytearray.fromhex(f.read().strip().replace('\\x',''))

# If shellcode is not 4 bytes aligned, adding padding bytes at the end
if len(shellcode_original) % 4 != 0:
	padding = 4 - (len(shellcode_original) % 4)
else:
	padding = 0
if padding:
	print('[+] Shellcode not 4 bytes aligned, adding {} \\x90 bytes of padding...'.format(padding))
	for i in range(0, padding):
		shellcode_original.append(0x90)

shellcode_encoded = bytearray()

for i in range(0, len(shellcode_original), 4):
	shellcode_encoded.append(shellcode_original[i+1])
	shellcode_encoded.append(shellcode_original[i])
	shellcode_encoded.append(shellcode_original[i+3])
	shellcode_encoded.append(shellcode_original[i+2])

shellcode_original_hex = ''.join('\\x{:02x}'.format(x) for x in shellcode_original)
shellcode_encoded_hex = ''.join('\\x{:02x}'.format(x) for x in shellcode_encoded)
print('[+] Original shellcode (len: {}): {}'.format(len(shellcode_original), shellcode_original_hex))
print('[+] Encoded shellcode (len: {}): {}'.format(len(shellcode_encoded), shellcode_encoded_hex))
