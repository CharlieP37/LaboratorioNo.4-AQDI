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
COUNT DW 0
COUNT2 DW 0
COUNT3 DW 0
COUNT4 DW 0
TEMP1 DW 0
TEMP2 DW 0
TEMP3 DW 0
TEMPDB1 DB 0
TEMPDB2 DW 0
TEMPDB3 DW 0
TEMPRESNUM1 DB 0
TEMPRESNUM2 DB 0
RESULTTEMP1 DB 0
RESULTTEMP2 DB 0
NUM1 DB 0
NUM2 DB 0
SIGN DB 0
PLUS_ASCII DB 43 //Signo +
MINUS_ASCII DB 45 //Signo -
ASTERISK_ASCII DB 42 //Signo *
SLASH_ASCII DB 47 //Signo /
EQUALS_ASCII DB 61 //Signo =
ENTER_ASCII DB 13 //Tecla ENTER
BACKSPACE_ASCII DB 8 //Tecla Borrar (Backspace)
ESCAPE_ASCII DB 27 //Tecla ESC
X_ASCII DB 88
x_ASCII DB 120
PROGRAMNAME DB "CALCULATOR","$"
VIDEO_SEG 	SEGMENT AT 0A000H
VID_AREA	DB		1000 DUP (?) ;Esto se comentará temporalmente
VIDEO_SEG 	ENDS
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
SCREEN_CHAR_PRINT MACRO CHAR
MOV DL, CHAR
MOV AH, 02H
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
MOV AH, 00H					
MOV AL, 13H
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
SET_BODY_PARAMETERS MACRO POSX, POSY, XSIZE, YSIZE, COLOR
CALL REGCLEAN
MOV AX, POSX
MOV BX, POSY
MOV TEMP1, AX
MOV TEMP2, BX
CALL REGCLEAN
MOV AX, XSIZE
MOV BX, YSIZE
MOV COUNT3, AX
MOV COUNT4, BX
MOV TEMPDB1, COLOR
ENDM
;---------------------------------------------------------
DRAW_WIDTH:
CALL REGCLEAN
PIXEL_DRAW TEMPDB1, 00H, TEMP1, TEMP2
INC COUNT
INC TEMP1
MOV BX, COUNT
CMP BX, COUNT3
JNG DRAW_WIDTH
RET
;---------------------------------------------------------
DRAW_HEIGHT:
CALL REGCLEAN
MOV AX, TEMP1
SUB AX, COUNT3
SUB AX, 1
MOV TEMP1, AX
INC TEMP2
MOV COUNT, 0
RET
;---------------------------------------------------------
DRAW_BODY:
CALL DRAW_WIDTH
CALL DRAW_HEIGHT
INC COUNT2
MOV BX, COUNT2
CMP BX, COUNT4
JNG DRAW_BODY
RET
;---------------------------------------------------------
RESET_COUNTERS: ;Método que se encarga de resetear las variables usadas como contadores
MOV COUNT, 0
MOV COUNT2, 0
MOV COUNT3, 0
MOV COUNT4, 0
RET
;---------------------------------------------------------
RESET_TEMPS: ;Método que se encarga de resetear las variables usadas como temporales
MOV TEMP1, 0
MOV TEMP2, 0
MOV TEMP3, 0
RET
;---------------------------------------------------------
SUM:
CALL REGCLEAN
MOV AL, NUM1
ADD AL, NUM2
MOV TEMPRESNUM, AX
RET
;---------------------------------------------------------
SUBSTRACTION:
CALL REGCLEAN
MOV AL, NUM1
MOV BL, NUM2
SUB AL, BL
MOV TEMPRESNUM, AX
RET
;---------------------------------------------------------
MULTIPLICATION:
CALL REGCLEAN
MOV AL, NUM1
MOV BL, NUM2
MUL BL
MOV TEMPRESNUM, AX
RET
;---------------------------------------------------------
DIVISION:
CALL REGCLEAN
MOV AL, NUM1
MOV BL, NUM2
DIV BL
MOV RESULTTEMP1, AL
MOV RESULTTEMP2, AH
RET
;---------------------------------------------------------

;---------------------------------------------------------
;---------------------------------------------------------
;=========================================================
MAIN PROC FAR
;---------------------------------------------------------
.STARTUP
CALL UPLOADDATA
;---------------------------------------------------------
CALL CLEANSCREEN
CALL GRAPHIC_MODE
CALL CLEARVIDEOSCREEN
;---------------------------------------------------------

CALL RESET_COUNTERS
CALL RESET_TEMPS

SET_BODY_PARAMETERS 50, 12, 220, 172, 07H ; Buen tamaño calculadora 220x160, Nueva dimension 220x172

CALL DRAW_BODY

CALL RESET_COUNTERS
CALL RESET_TEMPS

;++++++++++++++++++++++++++
SET_BODY_PARAMETERS 50, 12, 220, 15, 01H; Barra con tamaño de 220*15
CALL DRAW_BODY

CALL RESET_COUNTERS
CALL RESET_TEMPS

;++++++++++++++++++++++++++
MOVE_CURSOR 28, 5  ;Ubicaciones Números
SCREEN_CHAR_PRINT 31H
MOVE_CURSOR 29, 5
SCREEN_CHAR_PRINT 32H
MOVE_CURSOR 30, 5
SCREEN_CHAR_PRINT 33H
MOVE_CURSOR 31, 5
SCREEN_CHAR_PRINT 34H
;++++++++++++++++++++++++++
MOVE_CURSOR 7, 2
;SCREEN_CHAR_PRINT 34H
MSJSHOW PROGRAMNAME
;++++++++++++++++++++++++++
MOVE_CURSOR 0, 0
;++++++++++++++++++++++++++
CALL RESET_COUNTERS
CALL RESET_TEMPS

SET_BODY_PARAMETERS 255, 14, 10, 11, 0CH ; Cuadro de X con tamaño de 10*11

CALL DRAW_BODY

CALL RESET_COUNTERS
CALL RESET_TEMPS
;++++++++++++++++++++++++++
CALL KEY_NO_ECO
CALL EXITPROGRAM
;---------------------------------------------------------
;---------------------------------------------------------
MAIN ENDP
END MAIN
;---------------------------------------------------------
;=========================================================