Unite EQU H'20'          ; Adresse mémoire pour l'unité.
Dizaine EQU H'21'        ; Adresse mémoire pour la dizaine.
Centaine EQU H'22'       ; Adresse mémoire pour la centaine.
NOMBRE EQU H'23'         ; Adresse mémoire pour le nombre.
CPT1 EQU H'24'           ; Compteur 1 pour les routines de temporisation.
CPT2 EQU H'25'           ; Compteur 2 pour les routines de temporisation.

List p=16F876A           ; Spécifie le type de PIC utilisé.
Include "p16F876A.inc"  ; Inclut le fichier de configuration pour le PIC16F876A.

org 0x000                ; Adresse de début du programme.
GOTO PROG_PRINCIPAL      ; Saut au programme principal après le reset.

tempo
    MOVLW D'255'         ; Charge 255 dans W pour la temporisation.
    MOVWF CPT2           ; Copie W dans CPT2.
BOUCLE_2
    MOVWF CPT1
BOUCLE_1
    NOP
    DECFSZ CPT1,1        ; Décrémente CPT1 jusqu'à 0.
    GOTO BOUCLE_1

    DECFSZ CPT2,1        ; Décrémente CPT2 jusqu'à 0.
    GOTO BOUCLE_2
    RETURN

INIT_LCD
    CALL tempo
    BCF PORTB,1
    MOVLW B'00111100'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BCF PORTB,1
    MOVLW B'00001100'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BCF PORTB,1
    MOVLW B'00000001'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BCF PORTB,1
    MOVLW B'00000110'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

RETURN

Config_PORTS
    BSF STATUS,RP0
    BCF STATUS,RP1
    BCF TRISB,0
    BCF TRISB,1
    CLRF TRISC
    BCF STATUS,RP0

RETURN

CAN
    ; Configuration de ADCON0
    BCF STATUS,RP0
    BCF STATUS,RP1
    MOVLW B'01000101'     ; RA0 pour la conversion
    MOVWF ADCON0

    ; Configuration de ADCON1
    BSF STATUS,RP0
    BCF STATUS,RP1
    MOVLW B'00001110'
    MOVWF ADCON1

    ; TRISC en sortie
    MOVLW b'00000000'
    MOVWF TRISC

    ; Lancement de la conversion et attente de la fin
ConversionBegin
    BSF ADCON0,2
EndConversion
    BTFSC ADCON0,2
    GOTO EndConversion

    ; Déplacement du résultat de la conversion à NOMBRE
    MOVF ADRESH,W
    MOVWF NOMBRE
RETURN

CBN_To_ASCII
    SUB100
    MOVLW D'100'
    SUBWF NOMBRE,1
    BTFSC STATUS,Z
    GOTO  FinConversionCentaine
    BTFSS STATUS,C
    GOTO  Branch
    INCF  Centaine
    GOTO  SUB100

Branch
    ADDWF NOMBRE,1

ConversionDizaine
    MOVLW D'10'
    SUBWF NOMBRE,1
    BTFSC STATUS,Z
    GOTO  FinConvertionDizaine
    BTFSS STATUS,C
    GOTO FinConversionUnite
    INCF Dizaine
    GOTO ConversionDizaine

FinConversionCentaine
    INCF Centaine,1
    GOTO ConversionASCII

FinConvertionDizaine
    INCF Dizaine,1
    GOTO ConversionASCII

FinConversionUnite
    ADDWF NOMBRE,1
    MOVF NOMBRE,0
    MOVWF Unite
    GOTO ConversionASCII

ConversionASCII
    MOVLW D'48'
    ADDWF Centaine,1
    ADDWF Dizaine,1
    ADDWF Unite,1
RETURN

Affichage_L1
    CALL tempo
    BCF PORTB,1
    MOVLW B'00000010'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVF Centaine,W
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVF Dizaine,W
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVF Unite,W
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW A' '
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW A'<'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW A'-'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW A' '
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW A'C'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW A'A'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW A'N'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0
RETURN

PROG_PRINCIPAL
    CALL Config_PORTS
    CALL INIT_LCD

    ; Initialisation des valeurs des variables
    MOVLW D'00'
    MOVWF Unite
    MOVWF Dizaine
    MOVWF Centaine

    ; Exécution du programme principal
    CALL CAN
    CALL CBN_To_ASCII
    CALL Affichage_L1

    ; Boucle infinie
boucleinfinie
    NOP
    GOTO boucleinfinie

END
