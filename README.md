# Description

Plasmoid for KDE Plasma 5 that fetches data from [Genius](https://genius.com) about whatever you are listening on Spotify.

# WARNING

This applet is causing the desktop to crash in Plasma 5.18.5, KDE Frameworks 5.70.0, Qt 5.15. Not sure what of those components are causign the crash yet, but I'll be after that.

If you have this in your desktop you probably will see a black screen after login, to fix the crash manually edit the file ``~/.config/plasma-org.kde.plasma.desktop-appletsrc`` and manyally remove the Plasma Genial entry or just delete the file (If deleted most of your desktop configurations will be gone). After the changes just re-login.

# Demo

<img src="demo.gif">

# Installation Guide

## Via KDE Store

1. Open the "Add Widgets" dialog of your desktop
2. Go to "Get New Widgets" in the bottom
3. Click "Download New Plasma Widgets"
4. Search for "Genial"
5. Click "Install"
6. Drag the plasmoid to your desktop!

## Via OCS

**Note:** [ocs-url](https://www.opendesktop.org/p/1136805/) or [ocs-store](https://www.opendesktop.org/p/1175480/) are required!

1. Go to the [KDE Store Genial page](https://store.kde.org/p/1320258/)
2. Click "Install"
3. Select the latest file
4. Click "Install"
5. Click "Launch Application" if asked
6. Open the "Add Widgets" dialog of your desktop and drag the plasmoid!


## Via Command Line

### Install
- ``$ git clone https://github.com/NathanPB/plasma5-genial.git``
    - Or download the project and unzip it

- ``$ cd plasma5-genial``
- ``$ ./install.sh``

### Upgrade

- ``$ git clone https://github.com/NathanPB/plasma5-genial.git``
    - Or download the project and unzip it

- ``$ cd plasma5-genial``
- ``$ ./upgrade.sh``


### Remove
- ``$ kpackagetool5 -t Plasma/Applet --remove dev.nathanpb.plasmagenial``
    - Or use the uninstall script: ``$ ./uninstall.sh``

# Supports at this moment
  - Spotify
  
We are planning to support every single player that uses [mpris2 specification](https://specifications.freedesktop.org/mpris-spec/2.2/)

# License

Copyright (C) 2019 Nathan P. Bombana

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
