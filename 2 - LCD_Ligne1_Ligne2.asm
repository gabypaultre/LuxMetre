CPT1   EQU   H'20'    ; Compteur pour les routines de temporisation.
CPT2   EQU   H'21'    ; Second compteur pour les routines de temporisation.

List p=16F876A           ; Spécifie le type de PIC utilisé.
Include "p16f876a.inc"   ; Inclut le fichier d'en-tête pour le PIC16F876A.

; Vecteur de démarrage après RESET
org 0x000                ; Adresse de début du programme.
GOTO PROG_PRINCIPAL      ; Saut au programme principal après le reset.

; Routine de temporisation de 30ms
tempo 
    MOVLW  D'255'            ; Charge 255 dans W pour la temporisation.
    MOVWF  CPT2              ; Copie W dans CPT2.
BOUCLE_2
    MOVWF  CPT1
BOUCLE_1
    NOP                      ; Instruction sans opération pour consommer du temps.
    DECFSZ CPT1,1            ; Décrémente CPT1 jusqu'à 0 et continue.
    GOTO   BOUCLE_1
    
    DECFSZ CPT2,1            ; Décrémente CPT2 jusqu'à 0 et continue.
    GOTO   BOUCLE_2
    RETURN

; Configuration des ports pour l'écran LCD
Config_PORTS
    BSF STATUS,RP0           ; Sélection de la banque 1 des registres.
    BCF STATUS,RP1           ; Assure que RP1 est à 0.
    BCF TRISB,0              ; Configure RB0 comme sortie pour E.
    BCF TRISB,1              ; Configure RB1 comme sortie pour RS.
    CLRF TRISC               ; Configure PORTC comme sortie pour les données.
    BCF STATUS,RP0           ; Retour à la banque 0.

    RETURN

; Initialisation de l'écran LCD
INIT_LCD
    CALL tempo               ; Appel de la temporisation.
    BCF PORTB,1              ; RS à 0 pour les commandes.
    MOVLW B'00111100'        ; Fonction set: 8 bits, 2 lignes, police 5x8.
    MOVWF PORTC
    BSF PORTB,0              ; E à 1.
    BCF PORTB,0              ; E à 0.

    CALL tempo
    BCF PORTB,1
    MOVLW B'00001100'        ; Display ON, Cursor OFF, Blink OFF.
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BCF PORTB,1
    MOVLW B'00000001'        ; Clear display.
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BCF PORTB,1
    MOVLW B'00000110'        ; Entry mode set: Increment, no shift.
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    RETURN

; Affichage de "ESME_2024" sur la première ligne
Affichage_L1
    CALL tempo
    BCF PORTB,1              ; RS à 0 pour les commandes.
    MOVLW B'00000010'        ; Return home.
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    ; Ecriture de chaque caractère sur l'écran
    CALL tempo
    BSF PORTB,1              ; RS à 1 pour les données.
    MOVLW 'E'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW 'S'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW 'M'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW A'E'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW A'_'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW A'2'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW A'0'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW A'2'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW A'4'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

RETURN

; Affichage de "ESME_2024" sur la deuxième ligne
Affichage_L2
    CALL tempo
    BCF PORTB,1              ; RS à 0 pour les commandes.
    MOVLW B'11000000'        ; Positionne le curseur au début de la deuxième ligne.
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    ; Ecriture de chaque caractère sur l'écran
    CALL tempo
    BSF PORTB,1              ; RS à 1 pour les données.
    MOVLW 'E'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW 'S'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW 'M'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW 'E'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW '_'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW '2'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW '0'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW '2'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    CALL tempo
    BSF PORTB,1
    MOVLW '4'
    MOVWF PORTC
    BSF PORTB,0
    BCF PORTB,0

    RETURN

PROG_PRINCIPAL
    CALL Config_PORTS
    CALL INIT_LCD
    CALL Affichage_L1
    CALL Affichage_L2

END
