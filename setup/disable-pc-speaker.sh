# remove the modules
rmmod pcspkr
rmmod snd_pcsp

# blacklist the modules (alternative)
echo 'blacklist pcspkr' >>./nobeep.conf
echo 'blacklist snd_pcsp' >>./nobeep.conf
mv ./nobeep.conf /etc/modprobe.d/
