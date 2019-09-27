# Description

Plasmoid for KDE Plasma 5 that fetches data from [Genius](https://genius.com) about whatever you are listening on Spotify.

# Demo

<img src="demo.gif">

# Installation Guide

## Install
- $ git clone https://github.com/NathanPB/plasma5-genius-integration.git
    - Or download the project and unzip it

- $ cd plasma5-genius-integration
- $ ./install.sh

## Upgrade

- $ git clone https://github.com/NathanPB/plasma5-genius-integration.git
    - Or download the project and unzip it

- $ cd plasma5-genius-integration
- $ ./upgrade.sh


## Remove
- $ kpackagetool5 -t Plasma/Applet --remove dev.nathanpb.plasmagenius
    - Or use the uninstall script: $ ./uninstall.sh

# Supports at this moment
  - Spotify
  
We are planning to support every single player that uses [mpris2 specification](https://specifications.freedesktop.org/mpris-spec/2.2/) 
