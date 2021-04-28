#!/bin/bash

# note: the ssh tunnel itself happens on default port 22

# connection to 127.0.0.1:2121 will be forwarded to 1.2.3.4:8181
# local port:remote host:remote port
ssh -L 2121:1.2.3.4:8181 user@1.2.3.4

# reverse tunnel: the remote client will connect to this local computer
# 1.2.3.4:2121 => localhost:8181
ssh -R 2121:localhost:8181 user@1.2.3.4

# dynamic
ssh -D 2121 user@1.2.3.4
