;UNIVERSIDAD RAFAEL LANDÍVAR
;ARQUITECTURA DEL COMPUTADOR I
;DIEGO ANDRÉS GIL MORALES - 1084720
;CARLOS ANTONIO POP ARROYO - 1069920
;CALCULADORA

.MODEL LARGE
.STACK 64
.DATA
;=======================================================================
;---------------------------------------------------------
;---------------------------------------------------------
;=========================================================
.CODE
;=========================================================
;---------------------------------------------------------
CLEANSCREEN: ;Función que realiza una limpieza de la pantalla del DOS
MOV AH, 00H
MOV AL, 03H
INT 10H
RET
;---------------------------------------------------------
REGCLEAN: ;Función que se encarga de limpiar los registros AX, BX y DX
XOR AX, AX
XOR BX, BX
MOV DX, 0
RET
;---------------------------------------------------------
UPLOADDATA: ;Función que se encarga de cargar los datos de las variables al segmento DS
MOV AX, @data
MOV DS, AX

MOV AX, VIDEO_SEG
MOV ES, AX           ;Esto se comentará temporalmente
ASSUME ES:VIDEO_SEG
RET
;---------------------------------------------------------
MSJSHOW MACRO MSJ ;Función que se encarga de mostrar una cadena en pantalla
MOV AH, 09H
LEA DX, [MSJ]
INT 21H
ENDM
;---------------------------------------------------------
CLEARVIDEOSCREEN PROC ;Procedimiento que realiza una limpieza de la pantalla en modo de video
MOV AX, 0600H
MOV BH, 00	
MOV CX, 0000	
MOV DX, 184FH	
INT 10H
RET
CLEARVIDEOSCREEN ENDP
;---------------------------------------------------------
CLEARBUFFER	PROC ;Procedimiento que realiza una limpieza del buffer
MOV AH, 0CH
MOV AL, 00
INT 21H
RET
CLEARBUFFER	ENDP
;---------------------------------------------------------
STATUS_BUFFER PROC ;Procedimiento que se encarga de ver si hay un buffer del teclado
MOV AH, 011H
INT 16H
RET
STATUS_BUFFER ENDP
;---------------------------------------------------------
PIXELREAD MACRO POSX, POSY, PAG ;PROC ;Función que se encarga de leer un pixel en pantalla
MOV CX, POSX
MOV DX, POSY
MOV BH, PAG
MOV AH, 0DH
INT 10H
ENDM
;---------------------------------------------------------
GRAPHIC_MODE PROC ;Procedimiento que ingresa al modo de video gráfico de 320x200
AND BX, 00	
MOV SI, 00
MOV AH,00H					
MOV AL,13H
INT 10H
RET
GRAPHIC_MODE ENDP
;---------------------------------------------------------
RESTORE_ORIGINAL_MODE PROC ;Procedimeinto que se encarga de restaurar DOS a su modo normal de texto
MOV AL,03H				
MOV AH,00H
INT 10H
RET
RESTORE_ORIGINAL_MODE ENDP
;---------------------------------------------------------
EXITPROGRAM: ;Función que se encarga de realizar la salida a DOS
CALL CLEARBUFFER
CALL RESTORE_ORIGINAL_MODE
MOV AX, 4C00H
INT 21H
RET
;---------------------------------------------------------
KEY_NO_ECO PROC ;Función que lee un input de tecla sin eco
MOV AH, 07H
INT 21H
RET
KEY_NO_ECO ENDP
;---------------------------------------------------------
DELAY MACRO CXPART1, DXPART2 ;Procedimiento que se encarga de hacer un pequeño delay
AND AX, 00
AND CX, 00
AND DX, 00
MOV AH, 86H
MOV CX, CXPART1
MOV DX, DXPART2
INT 15H
ENDM
;---------------------------------------------------------
MOVE_CURSOR MACRO COL, ROW ;Macro que posiciona el cursor
MOV DH, ROW
MOV DL, COL
MOV BH, 0
MOV AH, 02H
INT 10H
ENDM
;---------------------------------------------------------
PIXEL_DRAW MACRO COLOR, PAG, POSX, POSY ;Proceso que se encarga de dibujar un pixel con los parámetros solicitados
MOV CX, POSX
MOV DX, POSY
MOV AH, 0CH
MOV AL, COLOR ;COLOR
MOV BH, PAG ;PAGINA
INT 10H
ENDM
;---------------------------------------------------------
;---------------------------------------------------------
;---------------------------------------------------------
;---------------------------------------------------------
;=========================================================
MAIN PROC FAR
;---------------------------------------------------------
.STARTUP
CALL UPLOADDATA
;---------------------------------------------------------
MAIN ENDP
END MAIN
;---------------------------------------------------------
;=========================================================