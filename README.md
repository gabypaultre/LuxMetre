# Luxmètre - Système de Mesure de Luminosité

## Introduction

Ce projet consiste à concevoir et réaliser un **luxmètre**, un système capable de mesurer l’intensité lumineuse ambiante (en Lux). Développé à l’aide du microcontrôleur **PIC16F876A**, il combine des éléments matériels et logiciels pour fournir une mesure précise et un affichage en temps réel.

Le système utilise un capteur de luminosité TEMT6000 pour mesurer la lumière ambiante, un microcontrôleur pour traiter les données, et un écran LCD pour afficher les résultats.

## Objectifs du projet

- **Mesure de la luminosité** : Conversion de la lumière ambiante en unités de Lux à l’aide du capteur TEMT6000.
- **Traitement des données** : Conversion des données analogiques en numériques via le module ADC du microcontrôleur.
- **Affichage en temps réel** : Affichage dynamique des résultats sur un écran LCD 16x2.

## Contenu du dépôt

Ce dépôt contient les fichiers suivants :

### Fichiers sources

- **[0 - signal_carré.asm](./0%20-%20signal_carré.asm)** : Génération d’un signal carré pour validation des temporisations.
- **[1 - CAN.asm](./1%20-%20CAN.asm)** : Configuration et gestion du module ADC pour la conversion des signaux analogiques en numériques.
- **[2 - LCD_Ligne1_Ligne2.asm](./2%20-%20LCD_Ligne1_Ligne2.asm)** : Gestion de l’affichage des données sur l’écran LCD.
- **[3 - BCD_ASCII.asm](./3%20-%20BCD_ASCII.asm)** : Conversion des données numériques (Binaire → BCD → ASCII) pour l’affichage.
- **[4 - LuxMètre.asm](./4%20-%20LuxMètre.asm)** : Code principal, intégrant toutes les fonctionnalités, de la capture des données jusqu’à leur affichage en Lux.

### Autres fichiers

- **[README.md](./README.md)** : Ce fichier.
- **[images/Luxmetre_PCB.png](./images/Luxmetre_PCB.png)** : Schéma du circuit du luxmètre.
  
---

Ce projet permet d’acquérir une compréhension pratique et théorique de la conception et de la réalisation d'un luxmètre, en intégrant les aspects matériels et logiciels.
