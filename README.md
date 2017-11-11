# SaRpg
This was the first software project that I ever wrote. I can't remember exactly, but I probably began writing this when I was 10 (1998). It's written in QuickBASIC, as it was a very beginner friendly language and also availabe on my first computer, which was an [Intel 80386](https://en.wikipedia.org/wiki/Intel_80386) with Windows 3.1. Later on I switch to Pentium models and Windows 95/98. This is why some files are uppercase only and some files have lower case (SARPG.BAS vs map4.map).

The main file is SARPG.BAS. The *.map files are the various rooms that you walked around in. The other files are mainly data files for monsters and items. I've included a screenshots folder so you don't have to download DOSBox to see the game in action.

### Early versions
I found two earlier versions of the game that were located in separate folders. The earliest version was a simple labyrinth game without any RPG elements really. The objective was to exit through a door and in order to do that you needed to find some keys. It's also the only version that contains a "backstory" for the game:

> Mr. <player> has been used to fight for the land in the distance.
Because that land is threatened by some aliens from the outer space.
They... äh, just play the game and have some fun because I won't write
any more!!!

It's a nice reflection of my age at the time and what I prioritized in gaming. 

The "early" version seems to be in some debugging state where I've now introduced encounters and a second map. There were no fighting system implemented yet though so the popup window closes as soon as I press any key.

At some point during the development between "early" and the current version I started playing [Tibia](https://secure.tibia.com). This seems to have influenced the game a lot in terms of monsters and items that I introduced. I.e. I reference "Amulet of Life" which is an item that was introduced in Tibia in december 2002, so most likely I introduced that item into SaRpg in 2003. I was also influenced by the [Drakar och Demoner](https://en.wikipedia.org/wiki/Drakar_och_Demoner) (swedish version of Dungeons and Dragons), which I played a lot at the time. This manifested itself in gameplay elements like "critical" hits.

I was surprised at how easy it was to read the code. There is a lot of comments explaining various parts of the code. I should not that evern though it looks as if everything is in one big file, in the QuickBasic editor you accessed subroutines separately. Everything below the comments about how to get Magic Sword and Amulet of Life are subroutines which were accessed like [this](quickbasic-subroutines.png).