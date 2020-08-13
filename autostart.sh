# How to load a ROM directly
# https://retropie.org.uk/forum/topic/5287/autostart-nes-rom-at-startup/4
#/opt/retropie/supplementary/runcommand/runcommand.sh 0 _SYS_ nes "/home/pi/RetroPie/roms/nes/Rampage (U).zip"

# Populate an array with a lit of ROMs, including their platform
# This could be more fancy (directory list all the roms to build an array), but this works for me.
romlist=(
'nes "/home/pi/RetroPie/roms/nes/Rampage (U).zip"'
'nes "/home/pi/RetroPie/roms/nes/Excitebike (E).zip"'
'nes "/home/pi/RetroPie/roms/nes/Double Dragon (E).zip"'
'nes "/home/pi/RetroPie/roms/nes/Bubble Bobble (U).zip"'
'nes "/home/pi/RetroPie/roms/nes/Contra (U).zip"'
'nes "/home/pi/RetroPie/roms/nes/Galaga (U).zip"'
'nes "/home/pi/RetroPie/roms/nes/Super Mario Bros (E).zip"'
'nes "/home/pi/RetroPie/roms/nes/RC Pro-Am (PC10).zip"'
'nes "/home/pi/RetroPie/roms/nes/Joust (U).zip"'
'nes "/home/pi/RetroPie/roms/nes/Space Invaders (J).zip"'
'nes "/home/pi/RetroPie/roms/nes/Tetris (U).zip"'
'snes "/home/pi/RetroPie/roms/snes/Teenage Mutant Ninja Turtles IV - Turtles in Time (U) [!].zip"'
'snes "/home/pi/RetroPie/roms/snes/Super Mario World (E) (V1.1) [!].zip"'
'snes "/home/pi/RetroPie/roms/snes/Killer Instinct (U) (V1.1) [!].zip"'
'snes "/home/pi/RetroPie/roms/snes/Super Metroid (E) [!].zip"'
'snes "/home/pi/RetroPie/roms/snes/Super Mario Kart (E) [!].zip"'
'snes "/home/pi/RetroPie/roms/snes/Earthworm Jim (U) [!].zip"'
'snes "/home/pi/RetroPie/roms/snes/Mega Man X (U) (V1.1) [!].zip"'
'snes "/home/pi/RetroPie/roms/snes/Mortal Kombat (U) [!].zip"'
'snes "/home/pi/RetroPie/roms/snes/Mortal Kombat II (U) (V1.0) [!].zip"'
'snes "/home/pi/RetroPie/roms/snes/Mortal Kombat 3 (U) [!].zip"'
'snes "/home/pi/RetroPie/roms/snes/X-Men - Mutant Apocalypse (U) [f2].zip"'
'megadrive "/home/pi/RetroPie/roms/megadrive/Michael Jackson'\''s Moonwalker (JUE) (REV 00) [!].bin"'
'megadrive "/home/pi/RetroPie/roms/megadrive/Altered Beast (JU) (REV 01) [!].bin"'
'megadrive "/home/pi/RetroPie/roms/megadrive/Sonic the Hedgehog (JUE) [!].bin"'
'megadrive "/home/pi/RetroPie/roms/megadrive/Sonic the Hedgehog 2 (JUE) [!].bin"'
'megadrive "/home/pi/RetroPie/roms/megadrive/Sonic and Knuckles (JUE) [!].bin"'
'megadrive "/home/pi/RetroPie/roms/megadrive/Smash TV (JUE) [!].bin"'
   )

# Shutdown the system at 7:30pm (I'll turn it back on with a wifi smart outlet)
# NOTE: You will not be able to SSH in within 5mins of the scheduled shutdown!
shutdown -h 19:30

# randomly load a ROM from the list for a while, over and over, forever.
while [ 1 ]; do
  # use eval to execute the string from the array
  # use timeout to run for a short time
  # use pkill to ensure the emulator exits
  # use sleep to reset for a few seconds between loops
  eval "timeout --foreground 5m /opt/retropie/supplementary/runcommand/runcommand.sh 0 _SYS_ ${romlist[RANDOM%${#romlist[@]}]}; pkill retroarch; sleep 2"
done

#emulationstation #auto
