# Authentication Logs Email Notifier

This Bash script sends email notifications about authentication events in a Linux OS.

## Table of Contents

- [Description](#description)
- [Installation](#installation)
- [Options](#options)
- [Requirements](#requirements)
- [Installation](#installation)
- [Examples](#examples)

## Description

This script provides a convenient way to monitor and receive email notifications about authentication events, including successful and failed logins, in a Linux operating system. It extracts authentication logs from the system and sends periodic email reports to the specified recipient.

## Installation and Usage

1. Clone this repository: `git clone git@github.com:ShchokinViktor/auth_logs_notifier.git`.
2. Navigate to the project directory: `cd auth_logs_notifier`.
3. Make the script executable: `chmod +x auth_logs_notifier.sh`.
4. Run the script with `sudo` privileges: `sudo ./auth_logs_notifier.sh`.

## Options

- `-h`: Display the help message.
- `-p <period>`: Set the time period for sending logs (e.g., 1h, 12h).
- `-r <recipient>`: Set the recipient email address.

## Requirements

- Linux operating system.
- Access to authentication logs (requires appropriate permissions).
- `mail` command for sending emails.

## Examples

- Send logs every 6 hours to `user@example.com`:
`sudo ./auth_logs_notifier.sh -p 6h -r user@example.com`
