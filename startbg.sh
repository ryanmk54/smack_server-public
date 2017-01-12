!#/bin/bash
rm -rf ~/projects/*
rm nohup.sh
export BOOGIE="mono /home/ubuntu/boogie/Binaries/Boogie.exe"
export CORRAL="mono /home/ubuntu/corral/bin/Release/corral.exe"
export LOCKPWN="mono /home/ubuntu/lockpwn/Binaries/lockpwn.exe"
nohup rails server -b ec2-52-53-187-90.us-west-1.compute.amazonaws.com &
