#!/usr/bin/env python
# Python Remote Administration Tool
# Created By: Reylan Teo

# Libraries

# Banner for display
Banner = """

"""
# Help menu
help_menu = """
        [+] Arguments:
            <username>.rat ------------ Access Target Via Config File
            -d, --dfig <vps_user> ----- Download RAT Config File 
            -s, --setup --------------- Setup VPS
            -m, --man ----------------- OnlyRAT Manual
            -v, --version ------------- OnlyRAT Version
            -u, --update -------------- Update OnlyRAT
import random as r
            -r, --remove -------------- Uninstall OnlyRAT
            -h, --help  --------------- Help Menu

        [+] Example:
            onlyrat bluecosmo.rat
"""

# Option menu
options_menu = """
        [+] Command and Control:
            [orconsole] -------------- Remote Console
            [fix orconsole] ---------- Fix Remote Console
            [upload] ----------------- Upload Files to Target PC
            [download] --------------- Download Files from Target PC
            [set connection local] --- Sets Connection to Local
            [set connection remote] -- Sets Connection to Remote
            [restart] ---------------- Restart Target PC
            [shutdown] --------------- Shutdown Target PC
            [killswitch] ------------- Removes OnlyRAT From Target

        [+] Payloads:
            Coming Soon...

        [+] Options:
            [help] ------------------- Help Menu
            [man] -------------------- Onlyrat Manual
            [config] ----------------- Display RAT File
            [version] ---------------- Version Number
            [update] ----------------- Update OnlyRAT
            [uninstall] -------------- Uninstall OnlyRAT
            [quit] ------------------- Quit

            * any other commands will be 
              sent through your terminal

        [*] Select an [option]...
"""

if __name__ == "__main__":
    print("Hello World")