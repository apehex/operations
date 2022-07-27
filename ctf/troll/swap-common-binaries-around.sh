# backup
mv /usr/bin/nano /usr/bin/nano.bak
mv /usr/bin/vi /usr/bin/vi.bak
mv /usr/bin/vim /usr/bin/vim.bak

# switch
cp /usr/bin/vi /usr/bin/nano
cp /usr/bin/nano /usr/bin/vi; cp /usr/bin/nano /usr/bin/vim
cp /usr/bin/nano /usr/bin/emacs
