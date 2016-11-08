# bakc
simple file backup utility

Backup script to speed up the process of backing up system files, appending a date-time and a .bak extension and placing it in my backup dir in home with both hostname and source path. Also includes the option of placing it in working dir and only appending a .bak. 

takes the options: -w, h currently and default behavior is to add it to current users backup dir

```shell
$ cd /tests
$ bakc -w test.file
# result:
# ./test.file.bak

$ bakc test.file
# result:
# ~/.backup/[hostname]/tests/test.file-2015-03-17_10-28-01.bak

```

