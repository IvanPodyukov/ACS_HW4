; inrnd.asm - генерация 
extern printf
extern rand

extern FICTION
extern CARTOON
extern SCIENCE

; генерация рандомного символа и длины фильма в минутах
global Random
Random:
section .data
    .i     dq      25
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     rdx, rdx    ; обнуление перед делением
    idiv    qword[.i]       ; (/%) -> остаток в rdx
    mov     rax, rdx
    add     rax , 97        ; должно сформироваться случайное число

leave
ret

; генерация рандомного типа мультфильма
global RandomType
RandomType:
section .data
    .i     dq      3
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     rdx, rdx    ; обнуление перед делением
    idiv    qword[.i]       ; (/%) -> остаток в rdx
    mov     rax, rdx
    inc     rax        ; должно сформироваться случайное число

leave
ret

; генерация рандомного года
global RandomYear
RandomYear:
section .data
    .i     dq      100
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     rdx, rdx    ; обнуление перед делением
    idiv    qword[.i]       ; (/%) -> остаток в rdx
    mov     rax, rdx
    add     rax, 1920         ; должно сформироваться случайное число

leave
ret

; генерация рандомного игрового фильма
global InRndFiction
InRndFiction:
section .bss
    .fict  resq 1   ; адрес игрового фильма
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес игрового фильма
    mov     [.fict], rdi
    ; Генерация параметров игрового фильма
    call    Random
    mov     rbx, [.fict]
    mov     [rbx], rax
    call    Random
    mov     rbx, [.fict]
    mov     [rbx+1], rax
    call    Random
    mov     rbx, [.fict]
    mov     [rbx+2], rax
    call    Random
    mov     rbx, [.fict]
    mov     [rbx+3], rax
    call    Random
    mov     rbx, [.fict]
    mov     [rbx+4], rax
    call    Random
    mov     rbx, [.fict]
    mov     [rbx+5], rax
    call    Random
    mov     rbx, [.fict]
    mov     [rbx+6], rax
    call    RandomYear
    mov     rbx, [.fict]
    mov     [rbx+8], rax
    call    Random
    mov     rbx, [.fict]
    mov     [rbx+12], rax
    call    Random
    mov     rbx, [.fict]
    mov     [rbx+13], rax
    call    Random
    mov     rbx, [.fict]
    mov     [rbx+14], rax

leave
ret

; генерация рандомного мультфильма
global InRndCartoon
InRndCartoon:
section .bss
    .cart  resq 1   ; адрес мультфильма
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес мультфильма
    mov     [.cart], rdi
    ; Генерация параметров мультфильма
    call    Random
    mov     rbx, [.cart]
    mov     [rbx], rax
    call    Random
    mov     rbx, [.cart]
    mov     [rbx+1], rax
    call    Random
    mov     rbx, [.cart]
    mov     [rbx+2], rax
    call    Random
    mov     rbx, [.cart]
    mov     [rbx+3], rax
    call    Random
    mov     rbx, [.cart]
    mov     [rbx+4], rax
    call    Random
    mov     rbx, [.cart]
    mov     [rbx+5], rax
    call    Random
    mov     rbx, [.cart]
    mov     [rbx+6], rax
    call    RandomYear
    mov     rbx, [.cart]
    mov     [rbx+8], eax
    call    RandomType
    mov     rbx, [.cart]
    mov     [rbx+12], eax

leave
ret

; генерация рандомного документального фильма
global InRndScience
InRndScience:
section .bss
    .scie  resq 1   ; адрес треугольника
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес документального фильма
    mov     [.scie], rdi
    ; Генерация параметров документального фильма
    call    Random
    mov     rbx, [.scie]
    mov     [rbx], rax
    call    Random
    mov     rbx, [.scie]
    mov     [rbx+1], rax
    call    Random
    mov     rbx, [.scie]
    mov     [rbx+2], rax
    call    Random
    mov     rbx, [.scie]
    mov     [rbx+3], rax
    call    Random
    mov     rbx, [.scie]
    mov     [rbx+4], rax
    call    Random
    mov     rbx, [.scie]
    mov     [rbx+5], rax
    call    Random
    mov     rbx, [.scie]
    mov     [rbx+6], rax
    call    RandomYear
    mov     rbx, [.scie]
    mov     [rbx+8], eax
    call    Random
    mov     rbx, [.scie]
    mov     [rbx+12], eax
    

leave
ret

; генерация рандомного фильма
global InRndMovie
InRndMovie:
section .data
    .i  dq   3
section .bss
    .movie     resq    1   ; адрес фильма
    .key        resd    1   ; ключ
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фильма
    mov [.movie], rdi
    xor rax, rax
    ; Формирование признака фильма
    call rand
    and eax, 1
    mov [.key], eax
    xor rax, rax   
    call rand
    and eax, 1
    add eax, [.key]
    inc eax
    mov rdi, [.movie]
    mov [rdi], eax      ; запись ключа в фильм
    cmp eax, [FICTION]
    je .fictInRnd
    cmp eax, [CARTOON]
    je .cartInRnd
    cmp eax, [SCIENCE]
    je .scieInRnd
    xor eax, eax        ; код возврата = 0
    jmp     .return
.fictInRnd:
    ; Генерация игрового фильма
    add     rdi, 4
    call    InRndFiction
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.cartInRnd:
    ; Генерация мультфильма
    add     rdi, 4
    call    InRndCartoon
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.scieInRnd:
    ; Генерация документального фильма
    add     rdi, 4
    call    InRndScience
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.return:
leave
ret

;----------------------------------------------
;// Случайный ввод содержимого контейнера
;void InRndContainer(void *c, int *len, int size) {
    ;void *tmp = c;
    ;while(*len < size) {
        ;if(InRndShape(tmp)) {
            ;tmp = tmp + shapeSize;
            ;(*len)++;
        ;}
    ;}
;}
global InRndContainer
InRndContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .psize  resd    1   ; число порождаемых элементов
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.plen], rsi    ; сохраняется указатель на длину
    mov [.psize], edx    ; сохраняется число порождаемых элементов
    ; В rdi адрес начала контейнера
    xor ebx, ebx        ; число фигур = 0
.loop:
    cmp ebx, edx
    jge     .return
    ; сохранение рабочих регистров
    push rdi
    push rbx
    push rdx

    call    InRndMovie    ; ввод фигуры
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

    pop rdx
    pop rbx
    inc rbx

    pop rdi
    add rdi, 20            ; адрес следующей фигуры

    jmp .loop
.return:
    mov rax, [.plen]    ; перенос указателя на длину
    mov [rax], ebx      ; занесение длины
leave
ret
