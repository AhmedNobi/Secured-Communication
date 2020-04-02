include irvine32.inc
addroundkey PROTO , x_param: ptr byte, y_param: ptr byte,z_param: ptr byte
ShiftRows PROTO  , matrix : ptr byte
Inverse_ShiftRows PROTO , matrix : ptr byte
sub PROTO  , matrix : ptr byte
sub_inverse PROTO , matrix2: ptr byte
mixCol PROTO , matrix: PTR byte
Inverse-mixCol PROTO , matrix : ptr byte
MulBy2 PROTO ,  x_param: byte
MulBy3 PROTO ,  x_param: byte
MulBy9 PROTO ,  x_param: byte
MulByB PROTO ,  x_param: byte
MulByD PROTO ,  x_param: byte
MulByE PROTO ,  x_param: byte
MoveToMatrix PROTO  , var0 : ptr dword , var1 : ptr dword , var2 : ptr dword , var3 : ptr dword , resMatrix : ptr byte

.data
	;------------------------------------------------------------------------------------
	RowSize dword 16
	RowIndex dword ?
	ColIndex dword ?
	MulRes dword ?
	tempArr Byte 16 dup(?)
	var0 dword 0
	var1 dword 0
	var2 dword 0
	var3 dword 0
	var11 byte ?
	var22 byte ?
	var33 byte ?
	varr44 byte ?
	matrixx byte 16 dup (?)
	resMatrix Byte 16 dup(?)
	RowSize3 dword 16
	ColSize3 dword 16
	RowIndex3 dword ?
	ColIndex3 dword ?
	MulRes3 dword ?
	tempArr3 Byte 16 dup(?)
	RMAtrix byte 16 dup (?)
	DFinal byte 16 dup(?)
	EFinal byte 16 dup(?)
	;################ S-BOX ######################################;

 SBOX_R0  Byte 63h,7Ch,77h,7Bh,0F2h,6Bh,6Fh,0C5h,30h,01h,67h,2Bh,0FEh,0D7h,0ABh,76h
 SBOX_R1  Byte 0CAh,82h,0C9h,7Dh,0FAh,59h,47h,0F0h,0ADh,0D4h,0A2h,0AFh,9Ch,0A4h,72h,0C0h
 SBOX_R2  Byte 0B7h,0FDh,93h,26h,36h,3Fh,0F7h,0CCh,34h,0A5h,0E5h,0F1h,71h,0D8h,31h,15h
 SBOX_R3  Byte 04h,0C7h,23h,0C3h,18h,96h,05h,9Ah,07h,12h,80h,0E2h,0EBh,27h,0B2h,75h
 SBOX_R4  Byte 09h,83h,2Ch,1Ah,1Bh,6Eh,5Ah,0A0h,52h,3Bh,0D6h,0B3h,29h,0E3h,2Fh,84h
 SBOX_R5  Byte 53h,0D1h,00h,0EDh,20h,0FCh,0B1h,5Bh,6Ah,0CBh,0BEh,39h,4Ah,4Ch,58h,0CFh
 SBOX_R6  Byte 0D0h,0EFh,0AAh,0FBh,43h,4Dh,33h,85h,45h,0F9h,02h,7Fh,50h,3Ch,9Fh,0A8h
 SBOX_R7  Byte 51h,0A3h,40h,8Fh,92h,9Dh,38h,0F5h,0BCh,0B6h,0DAh,21h,10h,0FFh,0F3h,0D2h
 SBOX_R8  Byte 0CDh,0Ch,13h,0ECh,5Fh,97h,44h,17h,0C4h,0A7h,7Eh,3Dh,64h,5Dh,19h,73h
 SBOX_R9  Byte 60h,81h,4Fh,0DCh,22h,2Ah,90h,88h,46h,0EEh,0B8h,14h,0DEh,5Eh,0Bh,0DBh
 SBOX_R10 Byte 0E0h,32h,3Ah,0Ah,49h,06h,24h,5Ch,0C2h,0D3h,0ACh,62h,91h,95h,0E4h,79h
 SBOX_R11 Byte 0E7h,0C8h,37h,6Dh,8Dh,0D5h,4Eh,0A9h,6Ch,56h,0F4h,0EAh,65h,7Ah,0AEh,08h
 SBOX_R12 Byte 0BAh,78h,25h,2Eh,1Ch,0A6h,0B4h,0C6h,0E8h,0DDh,74h,1Fh,4Bh,0BDh,8Bh,8Ah
 SBOX_R13 Byte 70h,3Eh,0B5h,66h,48h,03h,0F6h,0Eh,61h,35h,57h,0B9h,86h,0C1h,1Dh,9Eh
 SBOX_R14 Byte 0E1h,0F8h,98h,11h,69h,0D9h,8Eh,94h,9Bh,1Eh,87h,0E9h,0CEh,55h,28h,0DFh
 SBOX_R15 Byte 8Ch,0A1h,89h,0Dh,0BFh,0E6h,42h,68h,41h,99h,2Dh,0Fh,0B0h,54h,0BBh,16

 ;########################## inverse-SBOX ##########################################

 Inv_SBOX_R0  Byte 52h, 09h, 6ah, 0d5h, 30h, 36h, 0a5h, 38h, 0bfh, 40h, 0a3h, 9eh, 81h, 0f3h, 0d7h, 0fbh
 Inv_SBOX_R1  Byte 7ch, 0e3h, 39h, 82h, 9bh, 2fh, 0ffh, 87h, 34h, 8eh, 43h, 44h, 0c4h, 0deh, 0e9h, 0cbh
 Inv_SBOX_R2  Byte 54h, 7bh, 94h, 32h, 0a6h, 0c2h, 23h, 3dh, 0eeh, 4ch, 95h, 0bh, 42h, 0fah, 0c3h, 4eh
 Inv_SBOX_R3  Byte 08h, 2eh, 0a1h, 66h, 28h, 0d9h, 24h, 0b2h, 76h, 5bh, 0a2h, 49h, 6dh, 8bh, 0d1h, 25h
 Inv_SBOX_R4  Byte 72h, 0f8h, 0f6h, 64h, 86h, 68h, 98h, 16h, 0d4h, 0a4h, 5ch, 0cch, 5dh, 65h, 0b6h, 92h
 Inv_SBOX_R5  Byte 6ch, 70h, 48h, 50h, 0fdh, 0edh, 0b9h, 0dah, 5eh, 15h, 46h, 57h, 0a7h, 8dh, 9dh, 84h
 Inv_SBOX_R6  Byte 90h, 0d8h, 0abh, 00h, 8ch, 0bch, 0d3h, 0ah, 0f7h, 0e4h, 58h, 05h, 0b8h, 0b3h, 45h, 06h
 Inv_SBOX_R7  Byte 0d0h, 2ch, 1eh, 8fh, 0cah, 3fh, 0fh, 02h, 0c1h, 0afh, 0bdh, 03h, 01h, 13h, 8ah, 6bh
 Inv_SBOX_R8  Byte 3ah, 91h, 11h, 41h, 4fh, 67h, 0dch, 0eah, 97h, 0f2h, 0cfh, 0ceh, 0f0h, 0b4h, 0e6h, 73h
 Inv_SBOX_R9  Byte 96h, 0ach, 74h, 22h, 0e7h, 0adh, 35h, 85h, 0e2h, 0f9h, 37h, 0e8h, 1ch, 75h, 0dfh, 6eh
 Inv_SBOX_R10 Byte 47h, 0f1h, 1ah, 71h, 1dh, 29h, 0c5h, 89h, 6fh, 0b7h, 62h, 0eh, 0aah, 18h, 0beh, 1bh
 Inv_SBOX_R11 Byte 0fch, 56h, 3eh, 4bh, 0c6h, 0d2h, 79h, 20h, 9ah, 0dbh, 0c0h, 0feh, 78h, 0cdh, 5ah, 0f4h
 Inv_SBOX_R12 Byte 1fh, 0ddh, 0a8h, 33h, 88h, 07h, 0c7h, 31h, 0b1h, 12h, 10h, 59h, 27h, 80h, 0ech, 5fh
 Inv_SBOX_R13 Byte 60h, 51h, 7fh, 0a9h, 19h, 0b5h, 4ah, 0dh, 2dh, 0e5h, 7ah, 9fh, 93h, 0c9h, 9ch, 0efh
 Inv_SBOX_R14 Byte 0a0h, 0e0h, 3bh, 4dh, 0aeh, 2ah, 0f5h, 0b0h, 0c8h, 0ebh, 0bbh, 3ch, 83h, 53h, 99h, 61h
 Inv_SBOX_R15 Byte 17h, 2bh, 04h, 7eh, 0bah, 77h, 0d6h, 26h, 0e1h, 69h, 14h, 63h, 55h, 21h, 0ch, 7dh
;#######################################################
.code

;################################################################################
;----------------------------------------------------------
;Calculates: encrypt message.
;Recieves: text, key and length.
;Returns: Encrypted message.
;----------------------------------------------------------
Encrypt proc text:PTR byte, key: PTR byte, len:Dword
pushAD  ;Push all registers




mov ecx,9

invoke addroundkey,text,key,RMAtrix
L1:
invoke sub ,RMAtrix
invoke ShiftRows,tempArr
invoke mixCol,resMatrix
invoke addroundkey , matrixx , ,RMAtrix
loop L1

invoke sub ,RMAtrix
invoke ShiftRows,tempArr
invoke addroundkey , matrixx , ,EFinal


popAD   ;Pop all registers
ret
Encrypt Endp
;################################################################################
;----------------------------------------------------------
;Calculates: Decrypt message.
;Recieves: encrypted text, key and length.
;Returns: Decrypted message.
;----------------------------------------------------------

Decrypt proc text:PTR byte, key: PTR byte, len:Dword
pushAD ;Push all registers

	mov ecx,9

invoke sub,text
invoke ShiftRows,tempArr
invoke addroundkey,resMatrix, ,RMAtrix

L2:
invoke sub ,RMAtrix
invoke ShiftRows,tempArr
invoke mixCol,resMatrix
invoke addroundkey , matrixx , ,RMAtrix
loop L2

invoke addroundkey , RMAtrix , ,DFinal
popAD  ;pop all registers
ret
Decrypt Endp
;#################################################################################

;*******************************Add round Key function ***************************
;----------------------------------------------------------
;Calculates: xor between key+text matrix .
;Recieves: text matrix, key.
;Returns: Decrypted matrix.
;----------------------------------------------------------
addroundkey proc, x_param: ptr byte, y_param: ptr byte,z_param: ptr byte
	mov esi,x_param
	mov edi,y_param
	mov ebx,z_param
	mov ecx,16
	l1:
	mov eax,0
	mov al, [esi]
	xor al, [edi] 
	mov [ebx],al
	mov al,[ebx]
	inc esi
	inc edi
	inc ebx
	loop l1
	ret
addroundkey endp
;#################################################################################

;*******************************Subtitute function(Encrypt)**********************
;----------------------------------------------------------
;Calculates: subtitute each byte from text message with a byte from S-Box .
;Recieves: text matrix.
;Returns: Decrypted matrix.
;----------------------------------------------------------
sub PROC matrix: ptr byte

	mov ecx ,16
	mov ebx,0

	loop1:
	push ecx
	mov ecx,offset tempARR
	mov edx , offset SBOX_R0

	mov esi,0fh   ;esi=00001111
	mov edi,0fh   ;edi=11110000

	;------------addr=baseaddr+(columnsindex*rowsize+rowindex)*datasize-------------
	movzx eax,byte ptr[matrix+ebx]
	and esi,eax  ;esi=row index
	ror eax,4
	and edi,eax  ;edi=column index
	push edx
	push eax
	
	;mov eax ,edi
	mul ColSize
	add eax,esi
	mov MulRes,eax

	pop eax
	pop edx
	
	;---------------------Sub S-Box-------------------------------------------------
	push eax
	add edx,MulRes
	movzx eax ,byte ptr [edx]  ;getting the value from sbox
	add ecx,ebx
	mov [ecx],al
	add tempArr,bl
	pop eax
	;-------------------------------------------------------------------------------

	inc ebx
	pop ecx
	loop loop1

	ret
sub ENDP

;#################################################################################

;*******************************Subtitute function(Dencrypt)*********************
;----------------------------------------------------------
;Calculates: subtitute each byte from Decrypted message with a byte from inverse-SBox .
;Recieves: text matrix.
;Returns: Encrypted matrix.
;----------------------------------------------------------
sub_inverse PROC matrix2: ptr byte

	mov ecx ,16
	mov ebx,0

	loopinverse:
	push ecx
	mov ecx,offset tempARR3
	mov edx , offset Inv_SBOX_R0

	mov esi,0fh   ;esi=00001111
	mov edi,0fh   ;edi=11110000
	
	;addr=baseaddr+(columnsindex*rowsize+rowindex)*datasize
	movzx eax,byte ptr[matrix+ebx]
	and esi,eax  ;esi=row index
	ror eax,4
	and edi,eax  ;edi=column index
	push edx
	push eax

	;mov eax ,edi
	mul ColSize3
	add eax,esi
	mov MulRes3,eax

	pop eax
	pop edx
	
	push eax
	add edx,MulRes3
	movzx eax ,byte ptr [edx]  ;getting the value from sbox
	add ecx,ebx
	mov [ecx],al
	add tempArr3,bl
	pop eax

	inc ebx
	pop ecx
	loop loopinverse
	ret
sub_inverse ENDP
;#################################################################################

;*******************************shift rows function ******************************
;----------------------------------------------------------
;Calculates: Shift each row with certain amount .
;Recieves: text matrix.
;Returns: Encrypted matrix.
;----------------------------------------------------------
ShiftRows proc , matrixxx : ptr byte

		;Row0
		mov esi ,  matrixxx 
	    mov ebx ,var0	
		mov ecx , 4
		l1:
		shl ebx,8
		mov bl , byte ptr[esi]
		inc esi 
		loop l1
		mov var0 , ebx

		;Row1
		mov esi ,  matrixxx
		add esi , 4
	    mov ebx ,var1
		mov ecx , 4
		l2:
		shl ebx,8
		mov bl , byte ptr[esi]
		inc esi 
		loop l2
		rol ebx , 8
		mov var1 , ebx

		;Row2
		mov esi ,  matrixxx
		add esi , 8
	    mov ebx ,var2
		mov ecx , 4
		l3:
		shl ebx,8
		mov bl , byte ptr[esi]
		inc esi 
		loop l3
		rol ebx , 16
		mov var2 , ebx

		;Row3
		mov esi ,  matrixxx
		add esi , 12
		mov ebx ,var3
		mov ecx , 4
		l4:
		shl ebx,8
		mov bl , byte ptr[esi]
		inc esi 
		loop l4
		rol ebx , 24
		mov var3 , ebx

		 mov eax ,0
		 mov ecx ,0
		 mov esi ,0
		 mov ebx ,0
		 
		;putting values to the new matrix
		invoke MoveToMatrix , var0 , var1 , var2 , var3 , ADDR resMatrix  

		ret
		ShiftRows endp
;#################################################################################

;*******************************Inverse Shift Rows function ******************************
;----------------------------------------------------------
;Calculates: Shift each row with certain amount .
;Recieves: Encrypted text matrix.
;Returns: Decrypted text matrix.
;----------------------------------------------------------
Inverse_ShiftRows proc , matrixxx : ptr byte

	;Row0
	mov esi ,  matrixxx 
	mov ebx ,var0		
	mov ecx , 4
	l1:
	shl ebx,8
	mov bl , byte ptr[esi]
	inc esi 
	loop l1
	mov var0 , ebx

	;Row1
	mov esi ,  matrixxx
	add esi , 4
	mov ebx ,var1
	mov ecx , 4
	l2:
	shl ebx,8
	mov bl , byte ptr[esi]
	inc esi 
	loop l2
	ror ebx , 8
	mov var1 , ebx

	;Row2
	mov esi ,  matrixxx
	add esi , 8
	mov ebx ,var2
	mov ecx , 4
	l3:
	shl ebx,8
	mov bl , byte ptr[esi]
	inc esi 
	loop l3
	ror ebx , 16
	mov var2 , ebx

	;Row3
	mov esi ,  matrixxx
	add esi , 12
	mov ebx ,var3
	mov ecx , 4
	l4:
	shl ebx,8
	mov bl , byte ptr[esi]
	inc esi 
	loop l4
	ror ebx , 24
	mov var3 , ebx

	mov eax ,0
	mov ecx ,0
	mov esi ,0
	mov ebx ,0
		 
	;putting values to the new matrix
	invoke MoveToMatrix , var0 , var1 , var2 , var3 , ADDR resMatrix  

ret
Inverse_ShiftRows endp
;#################################################################################

;*****************************move variables to new matrix function **************
MoveToMatrix proc , var_0 : ptr dword , var_1 : ptr dword , var_2 : ptr dword , var_3 : ptr dword , res_Matrix : ptr byte

	;********* first row ************
	mov eax, var_0
	mov esi, res_Matrix
	mov ecx ,4
	L1:
	rol eax, 8
	mov [esi] , al
	inc esi
	loop L1

	;********* second row ************
	mov eax, var_1
	mov esi, res_Matrix
	add esi , 4
	mov ecx ,4
	L2:
	rol eax, 8
	mov [esi] , al
	inc esi
	loop L2

	;********* third row ************
	mov eax, var_2
	mov esi, res_Matrix
	add esi , 8
	mov ecx ,4
	L3:
	rol eax, 8
	mov [esi] , al
	inc esi
	loop L3

	;********* fourth row ************
	mov eax, var_3
	mov esi, res_Matrix
	add esi , 12
	mov ecx ,4
	L4:
	rol eax, 8
	mov [esi] , al
	inc esi
	loop L4

	ret
	MoveToMatrix endp
;#################################################################################
;----------------------------------------------------------
;Calculates: Mix each Column .
;Recieves: Encrypted text matrix.
;Returns: Decrypted text matrix.
;----------------------------------------------------------
;****************************Mix Column Function(Encrypt)*************************
mixCol Proc matrix: PTR byte
	;FirstCol
	mov al,matrix[0]
	mov bl,matrix[4]
	mov cl,matrix[8]
	mov dl,matrix[12]

	;Row1
	invoke  MulBy2, al
	mov var11,al
	invoke  MulBy3 ,bl
	mov var22,al
	mov var33,cl
	mov var44,dl
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[0],al

	;Row2
	mov al,matrix[0]
	mov var11,al
	invoke  MulBy2, bl
	mov var22,al
	invoke  MulBy3, cl
	mov var33,al
	mov var44,dl
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[4],al

	;Row3
	mov al,matrix[0]
	mov var11,al
	mov var22,bl
	invoke  MulBy2 ,cl
	mov var33,al
	invoke  MulBy3 ,dl
	mov var44,al
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[8],al

	;Row4
	mov al,matrix[0]
	invoke  MulBy3 ,al
	mov var11,al
	mov var22,bl
	mov var33,cl
	invoke  MulBy2 ,dl
	mov var44,al
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[12],al

	;-----------------------------------
	;SecCol
	mov al,matrix[1]
	mov bl,matrix[5]
	mov cl,matrix[9]
	mov dl,matrix[13]

	;Row1
	invoke  MulBy2 ,al
	mov var11,al
	invoke  MulBy3 ,bl
	mov var22,al
	mov var33,cl
	mov var44,dl
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[1],al

	;Row2
	mov al,matrix[1]
	mov var11,al
	invoke  MulBy2, bl
	mov var22,al
	invoke  MulBy3 ,cl
	mov var33,al
	mov var44,dl
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[5],al

	;Row3
	mov al,matrix[1]
	mov var11,al
	mov var22,bl
	invoke  MulBy2 ,cl
	mov var33,al
	invoke  MulBy3 ,dl
	mov var44,al
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[9],al

	;Row4
	mov al,matrix[1]
	invoke  MulBy3 ,al
	mov var11,al
	mov var22,bl
	mov var33,cl
	invoke  MulBy2 ,dl
	mov var44,al
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[13],al

	;-----------------------------------
	;ThirdCol
	mov al,matrix[2]
	mov bl,matrix[6]
	mov cl,matrix[10]
	mov dl,matrix[14]

	;Row1
	invoke  MulBy2, al
	mov var11,al
	invoke  MulBy3 ,bl
	mov var22,al
	mov var33,cl
	mov var44,dl
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[2],al

	;Row2
	mov al,matrix[2]
	mov var11,al
	invoke  MulBy2 ,bl
	mov var22,al
	invoke  MulBy3 ,cl
	mov var33,al
	mov var44,dl
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[6],al

	;Row3
	mov al,matrix[2]
	mov var11,al
	mov var22,bl
	invoke  MulBy2, cl
	mov var33,al
	invoke  MulBy3 ,dl
	mov var44,al
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[10],al

	;Row4
	mov al,matrix[2]
	invoke  MulBy3, al
	mov var11,al
	mov var22,bl
	mov var33,cl
	invoke  MulBy2 ,dl
	mov var44,al
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[14],al
	;-----------------------------------
	;ForthCol
	mov al,matrix[3]
	mov bl,matrix[7]
	mov cl,matrix[11]
	mov dl,matrix[15]

	;Row1
	invoke  MulBy2 ,al
	mov var11,al
	invoke  MulBy3 ,bl
	mov var22,al
	mov var33,cl
	mov var44,dl
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[3],al

	;Row2
	mov al,matrix[3]
	mov var11,al
	invoke  MulBy2,bl
	mov var22,al
	invoke  MulBy3 ,cl
	mov var33,al
	mov var44,dl
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[7],al

	;Row3
	mov al,matrix[3]
	mov var11,al
	mov var22,bl
	invoke  MulBy2 ,cl
	mov var33,al
	invoke  MulBy3 ,dl
	mov var44,al
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[11],al

	;Row4
	mov al,matrix[3]
	invoke  MulBy3 ,al
	mov var11,al
	mov var22,bl
	mov var33,cl
	invoke  MulBy2, dl
	mov var44,al
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[15],al
RET
mixCol ENDP
;#################################################################################
;----------------------------------------------------------
;Calculates: Mix each Column .
;Recieves: Decrypted text matrix.
;Returns: Encrypted text matrix.
;----------------------------------------------------------
;****************************Inverse Mix Column Function(Encrypt)*************************
;#################################################################################
Inverse-mixCol PROC matrix:ptr byte
;FirstCol
	mov al,matrix[0]
	mov bl,matrix[4]
	mov cl,matrix[8]
	mov dl,matrix[12]

	;Row1
	PUSHAD
	invoke  MulByE, al
	mov var11,al
	POPAD
	PUSHAD
	invoke  MulByB ,bl
	mov var22,al
	POPAD
	PUSHAD
	invoke  MulByD ,cl
	mov var33,al
	POPAD
	PUSHAD
	invoke  MulBy9 ,dl
	mov var44,al
	POPAD
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[0],al

	;Row2
	mov al,matrix[0]
	PUSHAD
	invoke  MulBy9, al
	mov var11,al
	POPAD
	PUSHAD
	invoke  MulByE ,bl
	mov var22,al
	POPAD
	PUSHAD
	invoke  MulByB ,cl
	mov var33,al
	POPAD
	PUSHAD
	invoke  MulByD ,dl
	mov var44,al
	POPAD
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[4],al

	;Row3
	mov al,matrix[0]
	PUSHAD
	invoke  MulByD, al
	mov var11,al
	POPAD
	PUSHAD
	invoke  MulBy9 ,bl
	mov var22,al
	POPAD
	PUSHAD
	invoke  MulByE ,cl
	mov var33,al
	POPAD
	PUSHAD
	invoke  MulByB ,dl
	mov var44,al
	POPAD
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[8],al

	;Row4
	mov al,matrix[0]
	PUSHAD
	invoke  MulByB, al
	mov var11,al
	POPAD
	PUSHAD
	invoke  MulByD ,bl
	mov var22,al
	POPAD
	PUSHAD
	invoke  MulBy9 ,cl
	mov var33,al
	POPAD
	PUSHAD
	invoke  MulByE ,dl
	mov var44,al
	POPAD
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[12],al

	;-----------------------------------
	;SecCol
	mov al,matrix[1]
	mov bl,matrix[5]
	mov cl,matrix[9]
	mov dl,matrix[13]

	;Row1
	PUSHAD
	invoke  MulByE, al
	mov var11,al
	POPAD
	PUSHAD
	invoke  MulByB ,bl
	mov var22,al
	POPAD
	PUSHAD
	invoke  MulByD ,cl
	mov var33,al
	POPAD
	PUSHAD
	invoke  MulBy9 ,dl
	mov var44,al
	POPAD
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[1],al

	;Row2
	mov al,matrix[1]
	PUSHAD
	invoke  MulBy9, al
	mov var11,al
	POPAD
	PUSHAD
	invoke  MulByE ,bl
	mov var22,al
	POPAD
	PUSHAD
	invoke  MulByB ,cl
	mov var33,al
	POPAD
	PUSHAD
	invoke  MulByD ,dl
	mov var44,al
	POPAD
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[5],al

	;Row3
	mov al,matrix[1]
	PUSHAD
	invoke  MulByD, al
	mov var11,al
	POPAD
	PUSHAD
	invoke  MulBy9 ,bl
	mov var22,al
	POPAD
	PUSHAD
	invoke  MulByE ,cl
	mov var33,al
	POPAD
	PUSHAD
	invoke  MulByB ,dl
	mov var44,al
	POPAD
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[9],al

	;Row4
	mov al,matrix[1]
	PUSHAD
	invoke  MulByB, al
	mov var11,al
	POPAD
	PUSHAD
	invoke  MulByD ,bl
	mov var22,al
	POPAD
	PUSHAD
	invoke  MulBy9 ,cl
	mov var33,al
	POPAD
	PUSHAD
	invoke  MulByE ,dl
	mov var44,al
	POPAD
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[13],al

	;-----------------------------------
	;ThirdCol
	mov al,matrix[2]
	mov bl,matrix[6]
	mov cl,matrix[10]
	mov dl,matrix[14]

	;Row1
	PUSHAD
	invoke  MulByE, al
	mov var11,al
	POPAD
	PUSHAD
	invoke  MulByB ,bl
	mov var22,al
	POPAD
	PUSHAD
	invoke  MulByD ,cl
	mov var33,al
	POPAD
	PUSHAD
	invoke  MulBy9 ,dl
	mov var44,al
	POPAD
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[2],al

	;Row2
	mov al,matrix[2]
	PUSHAD
	invoke  MulBy9, al
	mov var11,al
	POPAD
	PUSHAD
	invoke  MulByE ,bl
	mov var22,al
	POPAD
	PUSHAD
	invoke  MulByB ,cl
	mov var33,al
	POPAD
	PUSHAD
	invoke  MulByD ,dl
	mov var44,al
	POPAD
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[6],al

	;Row3
	mov al,matrix[2]
	PUSHAD
	invoke  MulByD, al
	mov var11,al
	POPAD
	PUSHAD
	invoke  MulBy9 ,bl
	mov var22,al
	POPAD
	PUSHAD
	invoke  MulByE ,cl
	mov var33,al
	POPAD
	PUSHAD
	invoke  MulByB ,dl
	mov var44,al
	POPAD
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[10],al

	;Row4
	mov al,matrix[2]
	PUSHAD
	invoke  MulByB, al
	mov var11,al
	POPAD
	PUSHAD
	invoke  MulByD ,bl
	mov var22,al
	POPAD
	PUSHAD
	invoke  MulBy9 ,cl
	mov var33,al
	POPAD
	PUSHAD
	invoke  MulByE ,dl
	mov var44,al
	POPAD
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[14],al
	;-----------------------------------
	;ForthCol
	mov al,matrix[3]
	mov bl,matrix[7]
	mov cl,matrix[11]
	mov dl,matrix[15]

	;Row1
	PUSHAD
	invoke  MulByE, al
	mov var11,al
	POPAD
	PUSHAD
	invoke  MulByB ,bl
	mov var22,al
	POPAD
	PUSHAD
	invoke  MulByD ,cl
	mov var33,al
	POPAD
	PUSHAD
	invoke  MulBy9 ,dl
	mov var44,al
	POPAD
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[3],al

	;Row2
	mov al,matrix[3]
	PUSHAD
	invoke  MulBy9, al
	mov var11,al
	POPAD
	PUSHAD
	invoke  MulByE ,bl
	mov var22,al
	POPAD
	PUSHAD
	invoke  MulByB ,cl
	mov var33,al
	POPAD
	PUSHAD
	invoke  MulByD ,dl
	mov var44,al
	POPAD
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[7],al

	;Row3
	mov al,matrix[3]
	PUSHAD
	invoke  MulByD, al
	mov var11,al
	POPAD
	PUSHAD
	invoke  MulBy9 ,bl
	mov var22,al
	POPAD
	PUSHAD
	invoke  MulByE ,cl
	mov var33,al
	POPAD
	PUSHAD
	invoke  MulByB ,dl
	mov var44,al
	POPAD
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[11],al

	;Row4
	mov al,matrix[3]
	PUSHAD
	invoke  MulByB, al
	mov var11,al
	POPAD
	PUSHAD
	invoke  MulByD ,bl
	mov var22,al
	POPAD
	PUSHAD
	invoke  MulBy9 ,cl
	mov var33,al
	POPAD
	PUSHAD
	invoke  MulByE ,dl
	mov var44,al
	POPAD
	mov al,var44
	XOR al,var33
	XOR al,var22
	XOR al,var11
	mov matrixx[15],al
Inverse-mixCol ENDP
;############################Advanced Multiplication##############################
MulBy2 proc x_param: byte
	clc
	mov al, x_param
	shl al,1
	jnc fin
	xor al,1bh
	fin:
	ret
MulBy2 endp
	;------------------------------------------
MulBy3 proc x_param: byte
	clc
	Invoke MulBy2,x_param
	xor al,x_param
	ret
MulBy3 endp
	;------------------------------------------
MulBy9 proc x_param: byte
	clc
	mov al,x_param
	mov bl,x_param
	mov ecx,3
	l1:
		mov x_param,al
		Invoke MulBy2,x_param
	loop l1
	xor al,bl
	ret
MulBy9 endp
	;------------------------------------------
MulByB proc x_param: byte
	clc
	mov al,x_param
	mov bl,x_param
	mov ecx,3
	l1:
		mov x_param,al
		Invoke MulBy2,x_param
		cmp ecx,3
		je assign
		contin:
	loop l1
	xor al,bl
	jmp fin
	assign:
	mov bh,al
	jmp contin
	fin:
	ret
MulByB endp
	;------------------------------------------
MulByD proc x_param: byte
	clc
	mov al,x_param
	mov bl,x_param
	mov ecx,3
	l1:
		mov x_param,al
		Invoke MulBy2,x_param
		cmp ecx,2
		je assign
		contin:
	loop l1
	xor al,bl
	xor al,bh
	jmp fin
	assign:
	mov bh,al
	jmp contin
	fin:
	ret
MulByD endp
	;------------------------------------------
MulByE proc x_param: byte
	clc
	mov al,x_param
	mov ecx,3
	l1:
		mov x_param,al
		Invoke MulBy2,x_param
		cmp ecx,3
		je assign1
		contin1:
		cmp ecx,2
		je assign2
		contin2:
	loop l1
	xor al,bl
	xor al,bh
	jmp fin
	assign1:
	mov bl,al
	jmp contin1
	assign2:
	mov bh,al
	jmp contin2
	fin:
	ret
MulByE endp
;#################################################################################
; DllMain is required for any DLL
DllMain PROC hInstance:DWORD, fdwReason:DWORD, lpReserved:DWORD
mov eax, 1 ; Return true to caller.
ret
DllMain ENDP
END DllMain