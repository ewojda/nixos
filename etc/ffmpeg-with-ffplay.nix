{ pkgs ? import <nixpkgs> {}}:

pkgs.ffmpeg.overrideAttrs (old: {
  configureFlags = builtins.filter (flag: flag != "--disable-ffplay") old.configureFlags;
})
