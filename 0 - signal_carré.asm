; Programme pour générer un signal carré sur une broche

; Définition des adresses des variables
CPT1    EQU H'20'
CPT2    EQU H'21'

; Configuration du microcontrôleur
List p=16F876A
Include "p16F876A.inc"

org 0x000    ; Point d'entrée du programme
GOTO PROG_PRINCIPAL    ; Aller au programme principal

; Sous-programme pour la temporisation
tempo
    MOVLW D'255'    ; Charger la valeur 255 dans le registre W
    MOVWF CPT2      ; Copier W dans CPT2

BOUCLE_2
    MOVWF CPT1      ; Copier la valeur de CPT2 dans CPT1

BOUCLE_1
    DECFSZ CPT1,1   ; Décrémenter CPT1 et sauter si zéro
    GOTO BOUCLE_1   ; Aller à BOUCLE_1

    DECFSZ CPT2,1   ; Décrémenter CPT2 et sauter si zéro
    GOTO BOUCLE_2   ; Aller à BOUCLE_2
    RETURN          ; Retourner du sous-programme

; Programme principal
PROG_PRINCIPAL
    BSF STATUS,RP0  ; Mettre à 1 le bit RP0 du registre STATUS (accès à la banque 1)
    BCF STATUS,RP1  ; Mettre à 0 le bit RP1 du registre STATUS (accès à la banque 1)

    BCF TRISB,2     ; Configurer le bit 2 du registre TRISB en sortie
    BCF STATUS,RP0  ; Remettre à 0 le bit RP0 du registre STATUS (accès à la banque 0)

BOUCLE	
    BSF PORTB,2     ; Mettre à 1 le bit 2 du registre PORTB (activer la broche)
    CALL tempo      ; Appeler le sous-programme tempo (temporisation)
    BCF PORTB,2     ; Remettre à 0 le bit 2 du registre PORTB (désactiver la broche)
    CALL tempo      ; Appeler le sous-programme tempo (temporisation)
    GOTO BOUCLE     ; Retourner à BOUCLE pour répéter le processus

END
