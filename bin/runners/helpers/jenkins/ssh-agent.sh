#!/usr/bin/expect -f
# shellcheck disable=all

set timeout 10
set host [lindex $argv 0]
set user "ubuntu"

# Check if BW_SESSION is set
if { [info exists env(BW_SESSION)] == 0 || [string length $env(BW_SESSION)] == 0 } {
    set session_file "$env(HOME)/.cache/bw-session"
    if {[file exists $session_file]} {
        set env(BW_SESSION) [exec cat $session_file]
    } else {
        puts "🔐 Bitwarden session not found."
        puts "➡️  Run this in your terminal before retrying:"
        puts "   export BW_SESSION=\$(bw unlock --raw)"
        exit 1
    }
}

# Retrieve password from Bitwarden
set password [exec bw get password "Ubuntu – Jenkins Build Agent Password"]

# Start SSH session
spawn ssh $user@$host
expect {
    "yes/no" {
        send "yes\r"
        exp_continue
    }
    -re {.*[Pp]assword.*:} {
        sleep 0.3
        send -- "$password\r"
    }
    timeout {
        exit 1
    }
    eof {
        exit 1
    }
}
interact
