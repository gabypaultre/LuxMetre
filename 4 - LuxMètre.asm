List p=16F876A                  ;indique le pic utilis�. Mettre la r�f�rence du PIC utilis�
    Include "p16F876A.inc"      ;indique le fichier de congfiguration du pic
 
 
    ORG 0x000                   ;Cette directive pr�cise l'adresse � partir de laquelle le uC commence � mettre le code dans la m�moire Flash


GOTO PROG_PRINCIPAL


;D�finition des fonctions


CONFIGURATION_PORTS
    BSF 	STATUS,RP0
    BCF		STATUS,RP1		; Banque 1	
    BCF     TRISB,0			; RB0 d�finit comme E
    BCF     TRISB,1         ; RB1 d�finit comme RS   
    CLRF    TRISC			; Port C en sortie pour le bus de donn�es du LCD
    BSF     TRISA,0    		; RA0 en entr�e analogique
    BCF 	STATUS,RP0
    BCF		STATUS,RP1		; Banque 0
    RETURN



INITIALISATION_LCD
    CALL    TEMPO
    BCF     PORTB,1			; RS � 0
    MOVLW   B'00111100'		; Function Set
    MOVWF   PORTC
    BSF     PORTB,0
    BCF     PORTB,0			; Front descendant pour E 

    CALL    TEMPO
    BCF     PORTB,1
    MOVLW   B'00001100'		; Display ON
    MOVWF   PORTC
    BSF     PORTB,0
    BCF     PORTB,0

    CALL    TEMPO
    BCF     PORTB,1
    MOVLW   B'00000001'		; Display Clear
    MOVWF   PORTC
    BSF     PORTB,0
    BCF     PORTB,0

    CALL    TEMPO
    BCF     PORTB,1
    MOVLW   B'00000110'		; Entry Mode Set
    MOVWF   PORTC
    BSF     PORTB,0
    BCF     PORTB,0
    
    RETURN



INITIALISATION_CAN

    BCF 	STATUS,RP0
    BCF		STATUS,RP1		; Banque 0
    MOVLW   B'01000001'		; Fosc/8, channel 0 (RA0,AN0), conversion non d�but�e
    MOVWF   ADCON0			; Charger le registre ADCON0
    BSF 	STATUS,RP0
    BCF		STATUS,RP1		; Banque 1
    MOVLW   B'00001110'		; ADFM=0 => justifi� � gauche, AN0/RA0 en analogique
    MOVWF   ADCON1			; Charger le registre ADCON1
    BCF		STATUS,RP0
    BCF		STATUS,RP1		; Banque 0
    RETURN

LECTURE_CAN
    BSF 	ADCON0,GO_DONE	; Mettre le bit 2 de ADCON0 � 1 (GO) pour lancer la conversion
    RETURN




AFFICHER
    MESURE		EQU 	0x34
    CENTAINE	EQU		0x35
    DIZAINE		EQU		0x36
    UNITE		EQU		0x37

    CALL        TEMPO
    BCF         PORTB,1					; RS � 0
    MOVLW       B'00000001'				; Return Home
    MOVWF       PORTC
    BSF         PORTB,0
    BCF         PORTB,0					; Front descendant pour E 

   
AFFICHER_CENTAINE
    CALL        TEMPO
    BSF         PORTB,1					; RS � 1
    MOVF        MESURE,W 				; Mesure que l'on doit afficher sur le LCD, MESURE charg� dans W
    MOVWF       N						; Charger MESURE dans N
    CALL        Conversion_BCD_ASCII	; Appeler la conversion en BCD_ASCII
    MOVLW       0X30					; Charger l'offset de conversion ASCII dans W
    XORWF       CENTAINE,W				; XOR entre CENTAINE et W (permet de "supprimer" centaine si centaine=0)
    BTFSC       STATUS,Z				; Teste si le bit Z de l'op�ration XOR tel que Z=0
    GOTO        AFFICHER_DIZAINE		; Cas o� Z=1
    MOVF        CENTAINE,W				; Cas o� Z=0   
    MOVWF       PORTC
    BSF         PORTB,0					; Front descendant pour E
    BCF         PORTB,0

    
AFFICHER_DIZAINE
    CALL        TEMPO
    MOVF        DIZAINE,W
    MOVWF       PORTC
    BSF         PORTB,0
    BCF         PORTB,0					; Front descendant pour E	
    

AFFICHER_UNITE

    CALL        TEMPO
    MOVF        UNITE,W
    MOVWF       PORTC
    BSF         PORTB,0
    BCF         PORTB,0					; Front descendant pour E



; AFFICHER "Lux  "

    CALL        TEMPO
    BSF         PORTB,1
    MOVLW       ' '
    MOVWF       PORTC
    BSF         PORTB,0
    BCF         PORTB,0 

    
    CALL        TEMPO
    BSF         PORTB,1
    MOVLW       'L'
    MOVWF       PORTC
    BSF         PORTB,0
    BCF         PORTB,0 

    CALL        TEMPO
    BSF         PORTB,1
    MOVLW       'u'
    MOVWF       PORTC
    BSF         PORTB,0
    BCF         PORTB,0 

    CALL        TEMPO
    BSF         PORTB,1
    MOVLW       'x'
    MOVWF       PORTC
    BSF         PORTB,0
    BCF         PORTB,0 

    CALL        TEMPO
    BSF         PORTB,1
    MOVLW       ' '
    MOVWF       PORTC
    BSF         PORTB,0
    BCF         PORTB,0 

    CALL        TEMPO
    BSF         PORTB,1
    MOVLW       ' '
    MOVWF       PORTC
    BSF         PORTB,0
    BCF         PORTB,0 
  

RETURN





TEMPO
    CPT1    EQU     0x77
    CPT2    EQU     0x78

    MOVLW   D'125'				; D�finir 125 dans W
    MOVWF   CPT2        		; Copier W dans CPT2

LOOP_TEMPO_2
    MOVWF   CPT1

LOOP_TEMPO_1
    NOP
    DECFSZ  CPT1,1				; D�cr�mente tant que CPT1 n'est pas �gale � 0 et le mets � jour
    GOTO    LOOP_TEMPO_1

    DECFSZ  CPT2,1				; D�cr�mente tant que CPT2 n'est pas �gale � 0 et le mets � jour
    GOTO    LOOP_TEMPO_2
    RETURN




DIVISION
    DIVIDENDE	EQU	0x30
    DIVISEUR    EQU	0x31
    QUOTIENT	EQU	0x32
    RESTE		EQU	0x33

    BCF		STATUS,C		; Mettre le bit C (Carry) � 0		
    MOVWF   DIVISEUR        ; R�cup�rer le diviseur
    CLRF    QUOTIENT        ; Initialiser le quotient � 0
    MOVF    DIVIDENDE,w
    MOVWF   RESTE           ; Initialiser le reste � dividende
    

LOOP_DIV

    MOVF    DIVISEUR,w		; Charger le diviseur dans W
    SUBWF   RESTE,f			; Reste <- Reste - Diviseur
    BTFSS   STATUS,C		; Tester si C=1
    GOTO    D_INF_d			; Cas o� C=0 
    GOTO    D_SUP_d         ; Cas o� C=1

D_SUP_d
    MOVF    QUOTIENT,w
    INCF    QUOTIENT,f		; Incr�menter le quotient
    GOTO    LOOP_DIV

D_INF_d
    MOVF    DIVISEUR,w
    ADDWF   RESTE,f			; Corriger le reste tel que Reste <- Reste + Diviseur
    GOTO    EXIT_DIV
    
EXIT_DIV

    RETURN




Conversion_BCD_ASCII

    N	EQU	0x38

    ; Conversion BCD_ASCII pour les Unit�s
    MOVF        N,W
    MOVWF       DIVIDENDE        
    MOVLW       D'10'
    CALL        DIVISION        
    MOVLW       0X30			; Offset de conversion ASCII
    ADDWF       RESTE,W         ; Pour convertir le reste de la division
    MOVWF       UNITE
    
    ; Conversion BCD_ASCII pour les Dizaines
    MOVF        QUOTIENT,W
    MOVWF       DIVIDENDE        
    MOVLW       D'10'
    CALL        DIVISION        
    MOVLW       0X30                  
    ADDWF       RESTE,W 
    MOVWF       DIZAINE
    
    ; Conversion BCD_ASCII pour les Centaines
    MOVF        QUOTIENT,W
    MOVWF       DIVIDENDE        
    MOVLW       D'10'
    CALL        DIVISION        
    MOVLW       0X30                   
    ADDWF       RESTE,W          
    MOVWF       CENTAINE
    RETURN





CALCUL_MESURE
	
	;Diviser par 2^3
	RRF	MESURE,f	; 1�re rotation � droite
	BCF	STATUS,C	; Bit C � 0
	RRF	MESURE,f	; 2�me rotation � droite
	BCF	STATUS,C	; Bit C � 0
	RRF	MESURE,f	; 3�me rotation � droite
		

	;Multiplier par 3
	MOVF	MESURE,W
	ADDWF	MESURE,W
	ADDWF	MESURE,f

	RETURN


;*************************************************************************************************
;                                                                                                *  
;                           PROG_PRINCIPAL							 *
;                                                                                                *
;*************************************************************************************************

PROG_PRINCIPAL
	CALL CONFIGURATION_PORTS
	CALL INITIALISATION_LCD
	CALL INITIALISATION_CAN
	CALL AFFICHER

DEBUT
	CALL LECTURE_CAN

FIN_CONVERSION
	BTFSC	ADCON0,GO_DONE		; Tester si le bit 2 de ADCON0 est � 0 (DONE) pour savoir quand la conversion est termin�e
	GOTO	FIN_CONVERSION		; Cas o� le bit 2 de ADCON0 est � 1 (GO)

	MOVF	ADRESH, W			; Cas o� le bit 2 de ADCON0 est � 0 (DONE)
	MOVWF	MESURE
	CALL	CALCUL_MESURE
	CALL	AFFICHER

    GOTO	DEBUT    			; Permet d'�viter de reconfigurer les ports ainsi que les initialisations du LCD et CAN
    END