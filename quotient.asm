;------------------------------------------------------------------------------
; quotient.asm - доп. функция фильмов
;------------------------------------------------------------------------------

extern FICTION
extern CARTOON
extern SCIENCE
extern printf

; доп. функция
global Quotient
Quotient:
section .text
push rbp
mov rbp, rsp
    cvtsi2sd    xmm0, dword[rdi+8]     
    call Strlen
    cvtsi2sd    xmm2, eax     
    divsd       xmm0, xmm2
leave
ret

; вычисление среднего значения доп. функции
global QuotientAverageContainer
QuotientAverageContainer:
section .data
    .sum    dq  0.0
section .bss
    .count  resq  1
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес начала контейнера
    mov ebx, esi            ; число фильмов
    xor ecx, ecx            ; счетчик фильмов;
    movsd xmm1, [.sum]      ; перенос накопителя суммы в регистр 1
.loop:
    cmp ecx, ebx            ; проверка на окончание цикла
    jge .return                 ; Перебрали все фильмы
    
    add rdi, 4
    mov r10, rdi            ; сохранение начала фильма
    mov [.count], ecx
    call Quotient     ; Получение доп. функции фильма
    mov ecx, [.count]
    addsd xmm1, xmm0        ; накопление сумм
    inc rcx                 ; индекс следующего фильма
    add r10, 16             ; адрес следующего фильма
    mov rdi, r10            ; восстановление для передачи параметра
    jmp .loop
.return:
    movsd       xmm0, xmm1
    cvtsi2sd    xmm1, ebx               
    divsd       xmm0, xmm1
leave
ret

; вычисление длины строки
global Strlen
Strlen:
section .text
push rbp
mov rbp, rsp
    ; Адрес сообщения уже загружен в rdi
    mov ecx, -1     ; ecx должен быть < 0
    xor al, al      ; конечный симврл = 0
    cld             ; направление обхода от начала к концу
    repne   scasb   ; while(msg[rdi]) != al) {rdi++, rcx--}
    neg ecx
    sub ecx, 2      ; ecx = length(msg)
    mov eax, ecx
leave
ret


    
