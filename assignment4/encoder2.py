#!/usr/bin/python

import random
import socket
import struct
import sys

# Seed PRNG (don't use this for real crypto)
random.seed()

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

# Process 4 bytes at a time
for i in range(0, len(shellcode_original), 4):
	xor_byte_good = False
	while(xor_byte_good == False):
		# Generate random XOR byte
		r = random.randint(1,255)
		# Check that resulting shellcode doesn't contain null bytes
		if (r ^ shellcode_original[i] != 0) and (r ^ shellcode_original[i+1] != 0) and (r ^ shellcode_original[i+2] != 0) and (r ^ shellcode_original[i+3] != 0):
			xor_byte_good = True

	# Encoded shellcode contains XOR byte + next 4 bytes reversed	
	shellcode_encoded.append(r)
	shellcode_encoded.append(shellcode_original[i+3] ^ r)
	shellcode_encoded.append(shellcode_original[i+2] ^ r)
	shellcode_encoded.append(shellcode_original[i+1] ^ r)
	shellcode_encoded.append(shellcode_original[i] ^ r)

# Add end of shellcode marker
shellcode_encoded.append(0x90)
shellcode_encoded.append(0x90)
shellcode_encoded.append(0xaa)
shellcode_encoded.append(0xaa)

# Print out the output
shellcode_original_hex = ''.join('\\x{:02x}'.format(x) for x in shellcode_original)
shellcode_encoded_hex = ''.join('\\x{:02x}'.format(x) for x in shellcode_encoded)
shellcode_encoded_nasm = ''.join('0x{:02x},'.format(x) for x in shellcode_encoded).rstrip(',')
print('[+] Original shellcode (len: {}): {}'.format(len(shellcode_original), shellcode_original_hex))
print('[+] Encoded shellcode (len: {}): {}'.format(len(shellcode_encoded), shellcode_encoded_hex))
print('[+] Encoded shell in NASM format: {}'.format(shellcode_encoded_nasm))
