List p=16F876A                  ;indique le pic utilisé. Mettre la référence du PIC utilisé
    Include "p16F876A.inc"      ;indique le fichier de congfiguration du pic
 
 
    ORG 0x000                   ;Cette directive précise l'adresse à partir de laquelle le uC commence à mettre le code dans la mémoire Flash


GOTO PROG_PRINCIPAL


;Définition des fonctions


CONFIGURATION_PORTS
    BSF 	STATUS,RP0
    BCF		STATUS,RP1		; Banque 1	
    BCF     TRISB,0			; RB0 définit comme E
    BCF     TRISB,1         ; RB1 définit comme RS   
    CLRF    TRISC			; Port C en sortie pour le bus de données du LCD
    BSF     TRISA,0    		; RA0 en entrée analogique
    BCF 	STATUS,RP0
    BCF		STATUS,RP1		; Banque 0
    RETURN



INITIALISATION_LCD
    CALL    TEMPO
    BCF     PORTB,1			; RS à 0
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
    MOVLW   B'01000001'		; Fosc/8, channel 0 (RA0,AN0), conversion non débutée
    MOVWF   ADCON0			; Charger le registre ADCON0
    BSF 	STATUS,RP0
    BCF		STATUS,RP1		; Banque 1
    MOVLW   B'00001110'		; ADFM=0 => justifié à gauche, AN0/RA0 en analogique
    MOVWF   ADCON1			; Charger le registre ADCON1
    BCF		STATUS,RP0
    BCF		STATUS,RP1		; Banque 0
    RETURN

LECTURE_CAN
    BSF 	ADCON0,GO_DONE	; Mettre le bit 2 de ADCON0 à 1 (GO) pour lancer la conversion
    RETURN




AFFICHER
    MESURE		EQU 	0x34
    CENTAINE	EQU		0x35
    DIZAINE		EQU		0x36
    UNITE		EQU		0x37

    CALL        TEMPO
    BCF         PORTB,1					; RS à 0
    MOVLW       B'00000001'				; Return Home
    MOVWF       PORTC
    BSF         PORTB,0
    BCF         PORTB,0					; Front descendant pour E 

   
AFFICHER_CENTAINE
    CALL        TEMPO
    BSF         PORTB,1					; RS à 1
    MOVF        MESURE,W 				; Mesure que l'on doit afficher sur le LCD, MESURE chargé dans W
    MOVWF       N						; Charger MESURE dans N
    CALL        Conversion_BCD_ASCII	; Appeler la conversion en BCD_ASCII
    MOVLW       0X30					; Charger l'offset de conversion ASCII dans W
    XORWF       CENTAINE,W				; XOR entre CENTAINE et W (permet de "supprimer" centaine si centaine=0)
    BTFSC       STATUS,Z				; Teste si le bit Z de l'opération XOR tel que Z=0
    GOTO        AFFICHER_DIZAINE		; Cas où Z=1
    MOVF        CENTAINE,W				; Cas où Z=0   
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

    MOVLW   D'125'				; Définir 125 dans W
    MOVWF   CPT2        		; Copier W dans CPT2

LOOP_TEMPO_2
    MOVWF   CPT1

LOOP_TEMPO_1
    NOP
    DECFSZ  CPT1,1				; Décrémente tant que CPT1 n'est pas égale à 0 et le mets à jour
    GOTO    LOOP_TEMPO_1

    DECFSZ  CPT2,1				; Décrémente tant que CPT2 n'est pas égale à 0 et le mets à jour
    GOTO    LOOP_TEMPO_2
    RETURN




DIVISION
    DIVIDENDE	EQU	0x30
    DIVISEUR    EQU	0x31
    QUOTIENT	EQU	0x32
    RESTE		EQU	0x33

    BCF		STATUS,C		; Mettre le bit C (Carry) à 0		
    MOVWF   DIVISEUR        ; Récupérer le diviseur
    CLRF    QUOTIENT        ; Initialiser le quotient à 0
    MOVF    DIVIDENDE,w
    MOVWF   RESTE           ; Initialiser le reste à dividende
    

LOOP_DIV

    MOVF    DIVISEUR,w		; Charger le diviseur dans W
    SUBWF   RESTE,f			; Reste <- Reste - Diviseur
    BTFSS   STATUS,C		; Tester si C=1
    GOTO    D_INF_d			; Cas où C=0 
    GOTO    D_SUP_d         ; Cas où C=1

D_SUP_d
    MOVF    QUOTIENT,w
    INCF    QUOTIENT,f		; Incrémenter le quotient
    GOTO    LOOP_DIV

D_INF_d
    MOVF    DIVISEUR,w
    ADDWF   RESTE,f			; Corriger le reste tel que Reste <- Reste + Diviseur
    GOTO    EXIT_DIV
    
EXIT_DIV

    RETURN




Conversion_BCD_ASCII

    N	EQU	0x38

    ; Conversion BCD_ASCII pour les Unités
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
	RRF	MESURE,f	; 1ère rotation à droite
	BCF	STATUS,C	; Bit C à 0
	RRF	MESURE,f	; 2ème rotation à droite
	BCF	STATUS,C	; Bit C à 0
	RRF	MESURE,f	; 3ème rotation à droite
		

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
	BTFSC	ADCON0,GO_DONE		; Tester si le bit 2 de ADCON0 est à 0 (DONE) pour savoir quand la conversion est terminée
	GOTO	FIN_CONVERSION		; Cas où le bit 2 de ADCON0 est à 1 (GO)

	MOVF	ADRESH, W			; Cas où le bit 2 de ADCON0 est à 0 (DONE)
	MOVWF	MESURE
	CALL	CALCUL_MESURE
	CALL	AFFICHER

    GOTO	DEBUT    			; Permet d'éviter de reconfigurer les ports ainsi que les initialisations du LCD et CAN
    END