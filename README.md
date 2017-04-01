#**cisco**
##cisco-commands.sh
This script will take a list of hosts and commands from a file and run them, sending the output to the screen and writing to a file identified by fileID.
    
    Usage:
        cisco-commands.sh 'host-file' 'commands-file' 'fileID'
    Ex:
        cisco-commands.sh hosts.txt commands.txt interfaces