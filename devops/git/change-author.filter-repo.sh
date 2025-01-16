#!/bin/sh

# mailmap is a file where each line has the format:
# New Name <new@email.com> <old@mail.com>
git filter-repo --mailmap ../mailmap
