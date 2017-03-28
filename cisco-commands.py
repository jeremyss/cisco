#!/bin/python

import sys
import pexpect

outout = ''
def connect(host, username, password):
    output = ''
    try:
        chan = pexpect.spawn("ssh -o StrictHostKeyChecking=no " + username + "@" + host, timeout=10)
        chan.expect(".*assword.*")
        chan.sendline(password)
        return chan
    except pexpect.ExceptionPexpect:
        print "SSH failed, trying telnet\n"
    try:
        chan = pexpect.spawn("telnet " + host, timeout=10)
        chan.expect(r"sername:.*")
        chan.sendline(username)
        chan.expect(r"assword:.*")
        chan.sendline(password)
        chan.expect('#')
        chan.sendline("exit")
        return output
    except pexpect.ExceptionPexpect:
        print "Telnet failed, connection failed\n"

username = raw_input("username: ")
password = raw_input("password: ")
host = raw_input("host: ")

output1 = connect(host, username, password)
print output1
