# FlashTools
Bash script to flash GrapheneOS on mobile phone hosted by Ubuntu or Fedora

GrapheneOS improves the security of an Android phone. So I went to
grapheneos.org/install to give it a try.

<p>The WebUSB-based installer just requires the latest Google Chrome
browser. There are only three buttons to the procedure:- 1-Unlock
bootloader, 2-Download Release, and 3-Flash Release. This did not work
on my Linux Ubuntu computer because after doing steps 1 and 2, step 3
said I must do step 2 which was already done. I could not fix this
because there was no evidence to help me trace root cause of the
problem. Unfortunately, UIs are only easy until
there is a problem. Solving the problem is difficult because the
operational logic is mostly hidden.</p>

<p>Next I tried the CLI Install Guide. I copy-pasted all those
highlighted command-lines into a script.  Scripting includes testing
steps that may fail. My script reduces typing tedium because text that
repeats or that may change are declared once at the beginning of the
file. This makes it easier to resuse the script for different releases,
different phone, and different computer. I tested the script on
<b>Ubuntu-23.04, Xubuntu, and Fedora-38 XFCE spin</b>. All good.</p>

Anyone who wants the script can download it from github. The license
is permissive.

Install Script as follows:-
* cd
* ...android folder should not exist yet
* ls android
* git clone https://github.com/bobmc-rmm/FlashTools.git
* mv FlashTools android
* cd android
* chmod u+x setup.sh

<p>The setup.sh has 2 parts. Part 1 configures the Linux OS and your user
account so that the future USB phone connection will work. The phone
does not need to be connected for part1. Part 2 downloads the phone
firmware and flashes the phone. It issues prompts when you must press
phone buttons.</p>

Run it like:-
*  cd ~/android
*  ./setup.sh p1
*  restart computer to realize the latest change
*  ./setup.sh p2

<p>Part1 only needs to be run once after you change the $PNAME and $REV
at the top of the script. Part2 can be repeated for flashing another
identical phone.</p>
...
