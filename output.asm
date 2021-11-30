; output.asm - вывод информации о контейнере в файл
extern printf
extern fprintf

extern Quotient

extern FICTION
extern CARTOON
extern SCIENCE


; вывод игрового фильма
global OutFiction
OutFiction:
section .data
    .outfmt db "It is Fiction: name = %s, year = %d, producer = %s. Quotient = %g",10,0
section .bss
    .fict  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1       ; вычисленная доп. функция игрового фильма
    .prod   resq  1
    .name   resq  1
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.fict], rdi          ; сохраняется адрес игрового фильма
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вычисление доп. функции игрового фильма (адрес уже в rdi)
    call    Quotient
    movsd   [.p], xmm0          ; сохранение (может лишнее) доп. функции

    ; Вывод информации об игровом фильме в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        
    mov     rax, [.fict]        ; адрес игрового фильма
    mov     [.name], rax
    mov     edx, [.name]         
    mov     ecx, [rax+8]        
    add     rax, 12
    mov     [.prod], rax
    mov     r8, [.prod]
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

; вывод мультфильма
global OutCartoon
OutCartoon:
section .data
    .outfmt1 db "It is Cartoon: name = %s, year = %d, type = drawn. Quotient = %g",10,0
    .outfmt2 db "It is Cartoon: name = %s, year = %d, type = puppet. Quotient = %g",10,0
    .outfmt3 db "It is Cartoon: name = %s, year = %d, type = plasticine. Quotient = %g",10,0
section .bss
    .cart  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1       ; вычисленная доп. функция мультфильма
    .name   resq  1
    .type   resq  1
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.cart], rdi        ; сохраняется адрес мультфильма
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вычисление доп. функции мультфильма (адрес уже в rdi)
    call    Quotient
    movsd   [.p], xmm0          ; сохранение (может лишнее) доп.функции

    ; Вывод информации о мультфильме в файл
    mov     rdi, [.FILE]
    mov     rax, [.cart]      ; адрес мультфильма
    mov     [.name], rax
    mov     edx, [.name]          
    mov     ecx, [rax+8]        
    mov     r10d, [rax+12]        
    
    cmp     r10d, 1
    je     .drawn   
    cmp     r10d, 2
    je    .puppet 
    cmp     r10d, 3
    je   .plasticine 
    
    jmp  .return  

; нарисованный
.drawn:
    mov     rsi,  .outfmt1
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf
    jmp     .return

; кукольный
.puppet:
    mov     rsi,  .outfmt2
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf
    jmp     .return
    
; пластилиновый
.plasticine:
    mov     rsi,  .outfmt3
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf
    jmp     .return
.return:
leave
ret

; вывод документального фильма
global OutScience
OutScience:
section .data
    .outfmt db "It is Science: name = %s, year = %d, length = %d minutes. Quotient = %g",10,0
section .bss
    .scie  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1       ; вычисленная доп. функция документального фильма
    .name   resq  1
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.scie], rdi        ; сохраняется адрес документального фильма
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вычисление доп.функции (адрес уже в rdi)
    call    Quotient
    movsd   [.p], xmm0          ; сохранение (может лишнее) доп. функции

    ; Вывод информации о документальном фильме в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        
    mov     rax, [.scie]      ; адрес документального фильма
    mov     [.name], rax
    mov     edx, [.name]       
    mov     ecx, [rax+8]        
    mov     r8, [rax+12]        
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf 

leave
ret

; вывод фильма
global OutMovie
OutMovie:
section .data
    .erMovie db "Incorrect film!",10,0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фильма
    mov eax, [rdi]
    cmp eax, [FICTION]
    je fictOut
    cmp eax, [CARTOON]
    je cartOut
    cmp eax, [SCIENCE]
    je scieOut
    mov rdi, .erMovie
    mov rax, 0
    call fprintf
    jmp     return
fictOut:
    ; Вывод игрового фильма
    add     rdi, 4
    call    OutFiction
    jmp return
cartOut:
    ; Вывод мультфильма
    add     rdi, 4
    call    OutCartoon
    jmp return
scieOut:
    ; Вывод документального фильма
    add     rdi, 4
    call    OutScience
    jmp return
return:
leave
ret

; вывод контейнера
global OutContainer
OutContainer:
section .data
    numFmt  db  "%d: ",0
section .bss
    .pcont  resq    1   ; адрес контейнера
    .len    resd    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.len],   esi     ; сохраняется число элементов
    mov [.FILE],  rdx    ; сохраняется указатель на файл

    ; В rdi адрес начала контейнера
    mov rbx, rsi            ; число фильмов
    xor ecx, ecx            ; счетчик фильмов = 0
    mov rsi, rdx            ; перенос указателя на файл
.loop:
    cmp ecx, ebx            ; проверка на окончание цикла
    jge .return             ; Перебрали все фильмы

    push rbx
    push rcx

    ; Вывод номера фильма
    mov     rdi, [.FILE]    ; текущий указатель на файл
    mov     rsi, numFmt     ; формат для вывода фильма
    mov     edx, ecx        ; индекс текущего фильма
    xor     rax, rax,       ; только целочисленные регистры
    call fprintf

    ; Вывод текущей фигуры
    mov     rdi, [.pcont]
    mov     rsi, [.FILE]
    call OutMovie    

    pop rcx
    pop rbx
    inc ecx                 ; индекс следующего фильма

    mov     rax, [.pcont]
    add rax, 20
    mov     [.pcont], rax
    jmp .loop
.return:
leave
ret
 
; удаление элементов, у которых значение доп. функции меньше среднего
global DeleteLessThanAverage
DeleteLessThanAverage:
section .data
    numFmt1  db  "%d: ",0
section .bss
    .pcont  resq    1   
    .len    resd    1  
    .FILE   resq    1   
    .avg    resq    1
    .temp   resq    1
section .text
push rbp
mov rbp, rsp
    
    mov [.pcont], rdi   
    mov [.len],   esi     
    mov [.FILE],  rdx   
    movsd [.avg], xmm0
    mov r15, 0
    mov rbx, rsi            
    xor ecx, ecx           
    mov rsi, rdx            
.loop:
    cmp ecx, ebx            
    jge .return         

    push rbx
    push rcx
    mov rdi, [.pcont]
    add rdi, 4
    call Quotient
    movsd xmm1, [.avg]
    comisd xmm1, xmm0
    jb .print
    
    pop rcx
    pop rbx
    inc ecx
    mov rax, [.pcont]
    add rax, 20
    mov [.pcont], rax

    jmp .loop
    
    
.print:
    mov     rdi, [.FILE]    
    mov     rsi, numFmt1     
    mov     rdx, r15        
    xor     rax, rax,       
    call fprintf

    mov     rdi, [.pcont]
    mov     rsi, [.FILE]
    call OutMovie    
                   
    pop rcx
    pop rbx
    inc ecx
    inc r15
    mov     rax, [.pcont]
    add rax, 20
    mov     [.pcont], rax

    jmp .loop
 
.return:
leave
ret
