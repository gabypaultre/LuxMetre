# Luxmètre - Système de Mesure de Luminosité

## Description

Ce projet consiste à concevoir et réaliser un **luxmètre**, un système capable de mesurer et afficher l’intensité lumineuse ambiante (en Lux). Développé à l’aide du microcontrôleur **PIC16F876A**, ce projet combine des éléments matériels et logiciels pour une mesure précise et un affichage en temps réel.

---

## Structure du Projet

Le projet est divisé en deux parties principales :

1. **Hardware** : Conception et assemblage des composants électroniques nécessaires.
2. **Software** : Programmation en assembleur pour le microcontrôleur, incluant la gestion des données capturées et leur affichage.

---

## 1. Hardware

### Composants Utilisés

- **Microcontrôleur PIC16F876A** : Cœur du système, responsable du traitement des données.
- **Capteur de luminosité TEMT6000** : Capte la lumière ambiante et fournit une tension analogique.
- **Écran LCD 16x2** : Affiche les résultats en Lux.
- **Régulateur de tension L7805** : Alimente le circuit avec une tension stable de 5V.
- **Divers** :
 - Potentiomètre pour ajuster la luminosité de l’écran.
 - LED et interrupteur pour indiquer et contrôler l’alimentation.
 - Résistances, condensateurs, et diodes pour la stabilité et la sécurité du circuit.

Le matériel a été assemblé sur un PCB conçu sur mesure, optimisant l’espace et la robustesse.

---

## 2. Software

Le code source est entièrement écrit en **assembleur** et se trouve dans ce dépôt. Il comprend plusieurs modules interconnectés pour gérer les différentes fonctionnalités du système.

### Codes Inclus

- **`0 - signal_carré.asm`** : Génération d’un signal carré pour validation des temporisations.
- **`1 - CAN.asm`** : Configuration et gestion du module ADC pour convertir les signaux analogiques en numériques.
- **`2 - LCD_Ligne1_Ligne2.asm`** : Gestion de l’affichage sur l’écran LCD.
- **`3 - BCD_ASCII.asm`** : Conversion des données numériques en format lisible pour l’affichage (Binaire → BCD → ASCII).
- **`4 - LuxMètre.asm`** : Code principal intégrant toutes les fonctionnalités, depuis la capture des données jusqu’à leur affichage en Lux.

### Fonctionnalités Logicielles

- **Lecture de la lumière ambiante** : Les données analogiques captées par le capteur sont converties en numérique via le module ADC du microcontrôleur.
- **Traitement des données** : Les données brutes sont traitées et converties en unités lisibles (Lux).
- **Affichage dynamique** : Les résultats sont affichés en temps réel sur un écran LCD.

---

## Guide d’Utilisation

### Prérequis
- MPLAB IDE pour compiler le code assembleur.
- Un programmateur Pickit pour flasher le microcontrôleur.
- Une alimentation 5V stable pour le circuit.
