## Start Process
`setsid ./test.sh  < /dev/null &> copy/test.log &`
## Dump Process
`sudo criu dump -t $(pgrep test.sh) -v4 -o dump.log`
or
`sudo criu dump --tree $(pgrep test.sh) --leave-stopped`
## SCP
`scp -P 2225 -r /home/mininet/GIT/NFV_Containernet/CheckPointMigration/CRIU-Examples/copy/* mininet@172.16.117.50:/home/mininet/GIT/NFV_Containernet/CheckPointMigration/CRIU-Examples/copy/`
## View Images
`crit decode -i core-1791.img --pretty`

## Restore Process
`sudo criu restore -d -vvv -o restore.log && echo OK`
