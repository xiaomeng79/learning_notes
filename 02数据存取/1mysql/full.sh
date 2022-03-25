#!/bin/sh

TODAY=`date +%Y%m%d%H%M`
#YESTERDAY=`date -d"yesterday" +%Y%m%d%H%M`
USEROPTIONS="--user=root --password=Abcd_1234"
TMPFILE="/var/innobackup_$TODAY.$$.tmp"
#$$脚本执行的进程ID
MYCNF=/etc/my.cnf
BACKUPDIR=/data/backup # 备份的主目录
FULLBACKUPDIR=$BACKUPDIR/full # 全库备份的目录
INCRBACKUPDIR=$BACKUPDIR/incr # 增量备份的目录
HOSTIP=`ip a |grep inet|tail -2|head -1|awk -F" " '{print $2}'|awk -F"/" '{print $1}'`

#############################################################################
# pre check
#############################################################################
# Check options before proceeding
if [ ! -x $INNOBACKUPEXFULL ]; then
  echo "$INNOBACKUPEXFULL does not exist."
  exit 1
fi

if [ ! -d $BACKUPDIR ]; then
  mkdir -p $BACKUPDIR
fi

if [ -z "`mysqladmin $USEROPTIONS status | grep 'Uptime'`" ] ; then
  echo "HALTED: MySQL does not appear to be running."
  exit 1
fi

if ! `echo 'exit' | mysql -s $USEROPTIONS` ; then
  echo "HALTED: Supplied mysql username or password appears to be incorrect (not copied here for security, see script)."
  exit 1
fi

# Some info output
echo "----------------------------"
echo
echo "$0: MySQL backup script"
echo "started: `date`"
echo

# Create fullbackup directory if not exist.
if [ ! -d $FULLBACKUPDIR ]; then
  mkdir -pv $FULLBACKUPDIR
else
  rm -fr $FULLBACKUPDIR/*
fi

#############################################################################
# begin backup
#############################################################################
cd $FULLBACKUPDIR
#delete the full backup file before today
rm -rf ./* ../incr/* /var/*.tmp
innobackupex --defaults-file=$MYCNF $USEROPTIONS $FULLBACKUPDIR > $TMPFILE 2>&1
if [ -z "`tail -1 $TMPFILE | grep 'completed OK!'`" ] ; then
  echo "innobackupex failed:";
  echo "---------- ERROR OUTPUT from innobackupex ----------"
  exit 1
else
  #备份成功 获取这次备份的目录
  THISBACKUP=`cat $TMPFILE|grep "Backup created in directory" |awk -F"'" '{print$2}'`
  CURDIR=`cat $TMPFILE|grep "Backup created in directory" |awk -F"'" '{print$2}'|awk -F "/" '{print$5}'`
  echo "Databases backed up successfully to: $THISBACKUP"
  tar -zcf ip_proxy.$TODAY.full.tar.gz $CURDIR
  scp -l 150 ip_proxy.$TODAY.full.tar.gz root@127.0.0.1:/backup/mysql
  if [ $? = 0 ]; then
    echo "scp fullbackup file successfully"
  else
    echo "Error with scp."
  fi
fi
#---------------

# Cleanup
#echo "delete tar files of 3 days ago"
#find $BACKUPDIR/ -mtime +3 -name "*.tar.gz"  -exec rm -rf {} \;

echo
echo "completed: `date`"
exit 0