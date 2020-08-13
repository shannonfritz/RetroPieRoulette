# RetroPie Roulette
A RetroPie Exhibition that randomly loads a ROM for a while then another, and another...

# How?
Just save the `autostart.sh` to your RetroPie under `/opt/retropie/configs/all/` and then edit the settings to your liking.

    mv /opt/retropie/configs/all/autostart.sh /opt/retropie/configs/all/autostart.sh.BAK
    wget https://github.com/shannonfritz/RetroPieRoulette/raw/master/autostart.sh /opt/retropie/configs/all/autostart.sh
    nano /opt/retropie/configs/all/autostart.sh

# What?
As much as I like my classic video games, I don't really play them that much, if at all.  So after I set up a [RetroPie](https://retropie.org.uk/), I didn't want that effort to go to waste by just sitting there on my desk, so I decided to find a way to make the thing sort of "play itself".  I didn't want to get real elaborate with button presses or actual game play, but I did figure out how to load a random ROM for a couple minutes, then load another one.  Most games have some kind of demo gameplay, but some just sit at a start screen.  So not all ROMs are great candidates for this "carousel" sort of random ROM loads, but there are pleanty of them that are.

## Automatic Loading ROMs
RetroPie runs an `autostart.sh` script when it first loads, and normally it just launches the `emulationstation` front end.  I found [a post on the RetroPie forum](https://retropie.org.uk/forum/topic/5287/autostart-nes-rom-at-startup/4) that describes **how to launch a ROM directly using `runcommand.sh`** which looks something like this:

    /opt/retropie/supplementary/runcommand/runcommand.sh 0 _SYS_ nes "/home/pi/RetroPie/roms/nes/Rampage (U).zip"

I wanted the ROM to run but only for a couple minutes before loading a different one, and so I decided to use the `timeout` command which can force a process to exit after a certain time.  I also needed to use `--foreground` otherwise the emulator never showed on the display.

    timeout --foreground 30 /opt/retropie/supplementary/runcommand/runcommand.sh 0 _SYS_ nes "/home/pi/RetroPie/roms/nes/Rampage (U).zip"

Once I had that, I found the timeout command was killing the runcommnd script, but the actual emulator was still running and I ended up with several ROMs going at the same time, so I added the use of `pkill` to stop retroarch and then `sleep` to rest for a few seconds.

    timeout --foreground 30 /opt/retropie/supplementary/runcommand/runcommand.sh 0 _SYS_ nes "/home/pi/RetroPie/roms/nes/Rampage (U).zip"; pkill retroarch; sleep 5

That is the core of how the ROMs are loaded.

## Randomly Selecting ROMs
Next up, I needed a way to randomly pick a ROM to play.  To do that, I decided to create an array of the ROMs I wanted to use.  I am not real happy with this method, as I think it would be better to get a directory listing of all the ROMs on disk, then randomly pick one of them to load, but this array method let's me be real particular about whar ROMs should be used in the Roulette.  So it was GoodEnough(tm).

    romlist=(
        'nes "/home/pi/RetroPie/roms/nes/Rampage (U).zip"'
        'nes "/home/pi/RetroPie/roms/nes/Super Mario Bros (E).zip"'
        'snes "/home/pi/RetroPie/roms/snes/Teenage Mutant Ninja Turtles IV - Turtles in Time (U) [!].zip"'
        'snes "/home/pi/RetroPie/roms/snes/Mortal Kombat (U) [!].zip"'
        'megadrive "/home/pi/RetroPie/roms/megadrive/Michael Jackson'\''s Moonwalker (JUE) (REV 00) [!].bin"'
        'megadrive "/home/pi/RetroPie/roms/megadrive/Sonic the Hedgehog (JUE) [!].bin"'
            )

Randomly picking a ROM from the array is a matter of using the `RANDOM` bash function and the length of the array itself.

    echo ${romlist[RANDOM%${#romlist[@]}]}

## Scheduling Power ON and OFF
Next, I had to decide how long to run the Roulette loop for, and at first I just did a loop of 10 ROMs with `while [ $i -lt 10 ]; do` but then tried using a loop that would run until 7:30pm with `while [ $(date +%H%M) -lt 1930 ]; do`.  But I wanted to make sure the RetroPie would shutdown at some point too, so I went a different slightly direction...

Instead, I just scheduled a shutdown at 7:30pm, then ran the while loop "forever".

    shutdown -h 19:30
    while [ 1 ]; do    
      eval "timeout --foreground 5m /opt/retropie/supplementary/runcommand/runcommand.sh 0 _SYS_ ${romlist[RANDOM%${#romlist[@]}]}; pkill retroarch; sleep 2"
    done

One trick here was the string value from the array didn't execute unless I wrapped the whole command with `eval`.

# Summary
So now I have a device that will load up a random ROM and run it for about 5 minutes, then closes it and runs another one over an over again until 7:30 and then shutsdown.  The final step is to turn the actual device ON, and to do that I have my RetroPie connected to a wifi smart outlut which is on it's own schedule to power ON in the mornings and then OFF just after the scheduled shutdown of the RetroPie.  This keeps things pretty simple, but powers on and off nice and clean.


# Tweaks and Tips

## SSH
To set any of this up I wanted to use PuTTY to get a remote console with SSH.  This is really easy by just placing an empty "`ssh`" text file in the root of the "boot" volume on the SD card.  Default username and password is pi/raspberry and [you should change that](https://www.raspberrypi.org/blog/a-security-update-for-raspbian-pixel/).  Once you log in with the pi account just run `passwd` and set a new password.  Dont worry, RetroPie will still autolaunch, but at least your raspbian host will not be sitting there with default creds waiting to be taken over.

## Loading screens
When a ROM is loading, there is a text based splash screen that appears for a few seconds.  It's not real polished so if you wanted to have someting "prettier" you can simply save a "launching.png" image in the configs directory of the emulated platform.  I found [another post on the RetroPie forum](https://retropie.org.uk/forum/topic/4611/runcommand-system-splashscreens) that includes images and instructions you can follow.

Here is a quick example of how to fetch the launching images for a few platforms if you're logged in via SSH
    
    wget https://github.com/ehettervik/es-runcommand-splash/raw/master/snes/launching.png -O /opt/retropie/configs/snes/launching.png
    wget https://github.com/ehettervik/es-runcommand-splash/raw/master/nes/launching.png -O /opt/retropie/configs/nes/launching.png
    wget https://github.com/ehettervik/es-runcommand-splash/raw/master/megadrive/launching.png -O /opt/retropie/configs/megadrive/launching.png

## Installing RetroPie
I you want to set up a RetroPie device, then I would [look at the official setup guide](https://retropie.org.uk/docs/Manual-Installation/).  You basically install the Raspbian OS first and then install RetroPie on that.

    git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git
    cd RetroPie-Setup
    chmod +x retropie_setup.sh
    sudo ./retropie_setup.sh

Use the setup script to set Emulation Station to start automatically on boot, which will be written to the autostart.sh script.

Then copy your ROMs to the `~/RetroPi/roms/nes` directory (or whatever system emulator you installed)
