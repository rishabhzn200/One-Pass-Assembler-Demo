sti
XYZ:
mov bx,ax
mov cl,dl
add bx,cx
cmp ax,cx
je XYZ
cmp bx,[si]
je ABC
je QWE
xor al,al
QWE:
add [si],al
ABC:
sti
cli
