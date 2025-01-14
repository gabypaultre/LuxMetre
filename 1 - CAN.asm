CPT1   EQU   H'20'    ; Compteur pour la routine de délai.
CPT2   EQU   H'21'    ; Second compteur pour la routine de délai.

List p=16F876A           ; Spécifie le type de PIC utilisé.
Include "p16f876a.inc"   ; Inclut le fichier d'en-tête pour le PIC16F876A.

; Vecteur de démarrage après RESET
org 0x000               ; Adresse de début du programme.
GOTO PROG_PRINCIPAL     ; Saut au programme principal après le reset.

; Routine de temporisation
tempo
    MOVLW   D'255'      ; Charge la valeur 255 dans W pour le délai.
    MOVWF   CPT2        ; Copie W dans CPT2.

BOUCLE_2
    MOVWF   CPT1
BOUCLE_1
    DECFSZ  CPT1,1      ; Décrémente CPT1 jusqu'à 0.
    GOTO    BOUCLE_1

    DECFSZ  CPT2,1      ; Décrémente CPT2 jusqu'à 0.
    GOTO    BOUCLE_2        
    RETURN

; Programme principal
PROG_PRINCIPAL
    ; Configuration de ADCON1 pour le mode analogique
    BSF  STATUS,RP0        ; Accès à la banque 1.
    BCF  STATUS,RP1        ; RP1 est à 0.
    MOVLW b'00001110'      ; Configure ADCON1 pour que les ports soient analogiques.
    MOVWF ADCON1

    ; Configuration de TRISA et TRISC
    BSF  TRISA,0           ; Configure RA0 comme entrée (pour le potentiomètre).
    CLRF TRISC             ; Configure PORTC comme sortie.

    ; Configuration de ADCON0 pour démarrer la conversion
    BCF  STATUS,RP0        ; Retour à la banque 0.
    BCF  STATUS,RP1        ; RP1 est à 0.
    MOVLW b'01000001'      ; Sélectionne RA0 pour la conversion et active le module ADC.
    MOVWF ADCON0

ConversionBegin
    BSF  ADCON0,2      ; Démarre la conversion.
EndConversion
    BTFSC ADCON0,2     ; Attend que la conversion soit terminée.
    GOTO  EndConversion
    MOVF  ADRESH,W     ; Déplace le résultat de la conversion dans W.
    MOVWF PORTC        ; Envoie le résultat sur PORTC.
    CALL  tempo        ; Appelle la routine de délai.
    GOTO  ConversionBegin  ; Recommence la conversion.

END                    ; Indique la fin du programme.
