CPT1   EQU   H'20'    ; Compteur pour la routine de d�lai.
CPT2   EQU   H'21'    ; Second compteur pour la routine de d�lai.

List p=16F876A           ; Sp�cifie le type de PIC utilis�.
Include "p16f876a.inc"   ; Inclut le fichier d'en-t�te pour le PIC16F876A.

; Vecteur de d�marrage apr�s RESET
org 0x000               ; Adresse de d�but du programme.
GOTO PROG_PRINCIPAL     ; Saut au programme principal apr�s le reset.

; Routine de temporisation
tempo
    MOVLW   D'255'      ; Charge la valeur 255 dans W pour le d�lai.
    MOVWF   CPT2        ; Copie W dans CPT2.

BOUCLE_2
    MOVWF   CPT1
BOUCLE_1
    DECFSZ  CPT1,1      ; D�cr�mente CPT1 jusqu'� 0.
    GOTO    BOUCLE_1

    DECFSZ  CPT2,1      ; D�cr�mente CPT2 jusqu'� 0.
    GOTO    BOUCLE_2        
    RETURN

; Programme principal
PROG_PRINCIPAL
    ; Configuration de ADCON1 pour le mode analogique
    BSF  STATUS,RP0        ; Acc�s � la banque 1.
    BCF  STATUS,RP1        ; RP1 est � 0.
    MOVLW b'00001110'      ; Configure ADCON1 pour que les ports soient analogiques.
    MOVWF ADCON1

    ; Configuration de TRISA et TRISC
    BSF  TRISA,0           ; Configure RA0 comme entr�e (pour le potentiom�tre).
    CLRF TRISC             ; Configure PORTC comme sortie.

    ; Configuration de ADCON0 pour d�marrer la conversion
    BCF  STATUS,RP0        ; Retour � la banque 0.
    BCF  STATUS,RP1        ; RP1 est � 0.
    MOVLW b'01000001'      ; S�lectionne RA0 pour la conversion et active le module ADC.
    MOVWF ADCON0

ConversionBegin
    BSF  ADCON0,2      ; D�marre la conversion.
EndConversion
    BTFSC ADCON0,2     ; Attend que la conversion soit termin�e.
    GOTO  EndConversion
    MOVF  ADRESH,W     ; D�place le r�sultat de la conversion dans W.
    MOVWF PORTC        ; Envoie le r�sultat sur PORTC.
    CALL  tempo        ; Appelle la routine de d�lai.
    GOTO  ConversionBegin  ; Recommence la conversion.

END                    ; Indique la fin du programme.
