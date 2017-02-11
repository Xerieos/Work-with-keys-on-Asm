code segment
START: 
	assume  cs:code

;==================================================
; Макросы	
	setcursor macro a, b
		MOV  AH,02     ;Запрос на установку курсора
		MOV  BH,00     ;Экран 
		MOV  DH, a     ;Строка 
		MOV  DL, b     ;Столбец 
		INT  10H       ;Передача управления в BIOS
    endm

	getcursor macro 
		mov ah, 03h
		int 10h
	endm
	
	print macro c
		mov ah, 02h
		mov dl, c
		int 21h
	endm
	
;==================================================
 ;Установка видеорежима
	mov ah, 00h
	mov al, 13h
	int 10h
	

; Нажатие клавиш	
NEXT:
	mov ah, 08h
	int 21h
	test al, al					; проверка на расширенный код
	jz EXTENDED_CODE		
	jmp NEXT
	
	
EXTENDED_CODE:
	int 21h		; повторный вызов для получения старшего байта 

	cmp al, 72		;	вверх
	je KEY_UP
	cmp al, 80		; вниз
	je KEY_DOWN
	cmp al, 75
	je KEY_LEFT		; влево
	cmp al, 77
	je KEY_RIGHT	; вправо
	jmp NEXT
	
; вывод
KEY_UP:
	print  '|'
	
	getcursor
	dec dh
	dec dl
	setcursor dh, dl
	jmp NEXT
	
KEY_DOWN:
	print  '|'	
	
	getcursor
	inc dh
	dec dl
	setcursor dh, dl
	jmp NEXT
	

KEY_LEFT:
	print  '-'

	getcursor
	sub dl, 2
	setcursor dh, dl
	
	jmp NEXT
	
	
KEY_RIGHT:
	print  '-'	
	jmp NEXT
	
	
; конец
	mov ax, 4ch
	int 21h

ends
end start