#!/bin/sh

# Don't ignore dotfiles in wildcards
shopt -s dotglob

sudo cp etc/* /etc/nixos/

cp home/* /home/emil
