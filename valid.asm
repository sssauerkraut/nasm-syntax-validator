; Базовые арифметические операции
mov eax, 10
mov ebx, 20
add eax, ebx
sub eax, 5
adc ebx, 1
sbb eax, 2
cmp eax, 25
and eax, 0xFF
or ebx, 0x0F
xor ecx, ecx

; С памятью
add [ebx], ecx
sub edx, [esi]
cmp [ebp], 10

; С разными размерами
add al, bl
sub ax, 5
adc al, 5
cmp al, 10

; Со знаковыми байтами
add ax, -5
sub eax, -10
cmp ax, -1

; С imm8 для 16/32 бит
add ax, 5
sub eax, 10

; С byte ptr
add byte [ebx], 5
cmp byte [ecx], 100

; С dword ptr
add dword [ebx], 50


; Прямая адресация
add [var2], ebx
add [ebp], eax ;[ebp-4] не работает


; ADD
add al, 1
add ax, 2
add eax, 3
add [eax], 4
add ebx, [ecx]

; ADC
adc al, 1
adc ax, 2
adc eax, 3
adc [eax], 4

; SUB
sub al, 1
sub ax, 2
sub eax, 3
sub [eax], 4

; SBB
sbb al, 1
sbb ax, 2
sbb eax, 3

; CMP
cmp al, 1
cmp ax, 2
cmp eax, 3
cmp [eax], 4

; AND
and al, 0x0F
and ax, 0xFF
and eax, 0xFFFFFF
and [eax], 0x80

; OR
or al, 0x0F
or ax, 0xFF
or eax, 0xFFFFFF

; XOR
xor al, al
xor ax, ax
xor eax, eax
xor [eax], 0xFF 
