#!/usr/bin/expect
match_max 99999

if { [lindex $argv 0] == "-h" || [lindex $argv 0] == "--help" } {
    puts "\nUsage:\n\tcisco-commands.expect \'host-file\' \'commands-file\' \'fileID\'\nEx:\n\tcisco-commands.expect hosts.txt commands.txt interfaces\n";
    exit 1;
} elseif { [lindex $argv 0] == "" } {
    puts "\nUsage:\n\tcisco-commands.expect \'host-file\' \'commands-file\' \'fileID\'\nEx:\n\tcisco-commands.expect hosts.txt commands.txt interfaces\n";
    exit 1;
}


#Get username and password
send_user "Username: "
expect_user -re "(.*)\n" {set user $expect_out(1,string)}
send_user "Password: "
stty -echo
expect_user -re "(.*)\n" {set password $expect_out(1,string)}
send_user "\n"
stty echo
#End get username and password

set timeout 5
set prompt "#"  ;# -- main activity
set DATE [exec date +%0m-%0d-%0y-%0H-%0M-%0S]

proc dostuff { query DATE host commands } {
;# do something with currenthost
    send -- "terminal length 0\r"
    expect "#"
    #run commands in commands file
    foreach commnd [split $commands "\n"] {
        exp_log_file -a $host-$query-$DATE.txt
        send -- "$commnd\r"
        expect "#"
        send -- "\r"
    }
    #End run commands in commands file
return}   ;# -- start of task

#Open hosts file
set hostsFile [lindex $argv 0]
set fd [open $hostsFile r]
set hosts [read -nonewline $fd]
close $fd
#End open hosts file

#Open commands file
set commandsFile [lindex $argv 1]
set fd [open $commandsFile r]
set commands [read -nonewline $fd]
close $fd
#End open commands file

#Set file name
set query [lindex $argv 2]
#End set file name

foreach host [split $hosts "\n" ] {
    spawn /usr/bin/telnet $host
        while (1) {
            expect  {
                "sername: " {
                    send -- "$user\r"
                }
                "assword: " {
                    send -- "$password\r"
                }
	            "ogin: " {
                    send -- "$user\r"
                }
                "assword: " {
                    send -- "$password\r"
                }
                "$prompt" {
                    dostuff $query $DATE $host $commands
	                break
                }
            }
        }
    expect "$prompt"
    send -- "exit\r"
}
expect eof