; input.asm - ввод фильмов в контейнер
extern printf
extern fscanf

extern FICTION
extern CARTOON
extern SCIENCE

; ввод игрового фильма
global InFiction
InFiction:
section .data
    .infmt db "%s%d%s",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .fict  resq    1   ; адрес игрового фильма
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.fict], rdi          ; сохраняется адрес игрового фильма
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод игрового из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         
    mov     rdx, [.fict]      
    mov     rcx, [.fict]
    add     rcx, 8              
    mov     r8, [.fict]
    add     r8, 12
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

leave
ret

; ввод мультфильма
global InCartoon
InCartoon:
section .data
    .infmt db "%s%d%d",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .cart  resq    1   ; адрес мультфильма
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.cart], rdi          ; сохраняется адрес мультфильма
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод мультфильма из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         
    mov     rdx, [.cart]      
    mov     rcx, [.cart]
    add     rcx, 8            
    mov     r8, [.cart]
    add     r8, 12
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

leave
ret

; ввод документального фильма
global InScience
InScience:
section .data
    .infmt db "%s%d%d",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .scie  resq    1   ; адрес документального фильма
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.scie], rdi          ; сохраняется адрес документального фильма
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод документального фильма из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt        
    mov     rdx, [.scie]      
    mov     rcx, [.scie]
    add     rcx, 8            
    mov     r8, [.scie]
    add     r8, 12             
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

leave
ret

; ввод фильма
global InMovie
InMovie:
section .data
    .tagFormat   db      "%d",0
section .bss
    .FILE       resq    1   ; временное хранение указателя на файл
    .pmovie     resq    1   ; адрес фильма
    .movieTag   resd    1   ; признак фильма
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pmovie], rdi          ; сохраняется адрес фильма
    mov     [.FILE], rsi            ; сохраняется указатель на файл

    ; чтение признака фильма и его обработка
    mov     rdi, [.FILE]
    mov     rsi, .tagFormat
    mov     rdx, [.pmovie]      ; адрес начала фильма (ее признак)
    xor     rax, rax            ; нет чисел с плавающей точкой
    call    fscanf


    mov rcx, [.pmovie]          ; загрузка адреса начала фильма
    mov eax, [rcx]              ; и получение прочитанного признака
    cmp eax, [FICTION]
    je .fictIn
    cmp eax, [CARTOON]
    je .cartIn
    cmp eax, [SCIENCE]
    je .scieIn
    xor eax, eax    ; Некорректный признак - обнуление кода возврата
    jmp     .return
.fictIn:
    ; Ввод игрового фильма
    mov     rdi, [.pmovie]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InFiction
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.cartIn:
    ; Ввод мультфильма
    mov     rdi, [.pmovie]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InCartoon
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.scieIn:
    ; Ввод документального фильма
    mov     rdi, [.pmovie]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InScience
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.return:

leave
ret

; ввод в контейнер
global InContainer
InContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.plen], rsi    ; сохраняется указатель на длину
    mov [.FILE], rdx    ; сохраняется указатель на файл
    ; В rdi адрес начала контейнера
    xor rbx, rbx        ; число фильмов = 0
    mov rsi, rdx        ; перенос указателя на файл
.loop:
    ; сохранение рабочих регистров
    push rdi
    push rbx

    mov     rsi, [.FILE]
    mov     rax, 0      ; нет чисел с плавающей точкой
    call    InMovie     ; ввод фильма
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

    pop rbx
    inc rbx

    pop rdi
    add rdi, 20
    jmp  .loop
    
    
.return:
    mov rax, [.plen]    ; перенос указателя на длину
    mov [rax], ebx      ; занесение длины
    call printf
leave
ret

