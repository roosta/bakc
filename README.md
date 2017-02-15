# bakc
Simple file backup utility. Nothing special, just something to expedite backing up single files and adding timestamp.
I made this cause I kept wanting a backup of a file prior to editing it so I can roll back if necessary and it all got rather tedious to keep appending timestamp and retaining the path of the file.

## Installation
```shell
git clone https://github.com/roosta/bakc && \
cd bakc && \
chmod u+x install.sh && \
./install.sh
```

The install script assumes that $HOME/bin is in $path. Change this in install.sh if this is undesirable.
The installer simply symlinks bin file and copies the rc file to ~/.bakcrc.

## Configuration
.bakcrc allows two config options.
bakc__backup_path is the location you want the files backed up to.
bakc__file_suffix is whatever you want as a suffix for backed up files. By default it creates a timestamp.

```shell
bakc__backup_path=~/backup
bakc__file_suffix=$(date +"%Y-%m-%d@%T")
```

## Usage
```shell
bakc ~/src/bakc/bakc.sh                                                                                                                                 [
# backed up '/home/[user]/src/bakc/bakc.sh' to /home/[user]/backup/home/[user]/src/bakc/bakc.sh~2017-02-12@21:20:12
```

Includes the option of placing it in working dir and only appending a .bak file extension
```shell
bakc -w file.txt
# Created test.txt.bak here (pwd)
```

Also included is the option to remove source file after backup:
```shell
bakc -wR file.txt
# Created file.txt.bak here (/home/[user]/[path])
# removed 'file.txt'
```

It takes a relative path, and/or multiple files and follow symlinks:
```shell
bakc ~/.zprofile ~/.zshenv
# backed up '/home/[user]/.zshenv' to /home/[user]/backup/home/[user]/.zshenv~2017-02-12@22:01:40
# backed up '/home/[user]/.zprofile' to /home/[user]/backup/home/[user]/.zprofile~2017-02-12@22:01:40

bakc -w ~/.zshenv ~/.zprofile
# Created /home/[user]/.zshenv.bak here (/home/[user]/src/bakc)
# Created /home/[user]/.zprofile.bak here (/home/[user]/src/bakc)
```
