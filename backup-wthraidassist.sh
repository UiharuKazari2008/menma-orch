##### RAID
md_raid=/dev/md0
##### RSync
source_dir=<folder or folder of links>
backup_dir=<folder or folder of links>
source_skip=<file list of excluded items>
##### Mount
source_mount=<file list of source mount points>
backup_mount=<mount point to backup server>
log=<file to store rsync log>

echo "Menma DPS v0.2 - Data Proccesser (with RAID Assistant)"
echo "Preparing System..."
mdadm --ass $md_raid
mount $backup_mount
mount $source_mount
sleep 5
echo "Backing up files..."
rsync -rLtpogb --progress --exclude-from=$source_skip --log-file=$log $source_dir $backup_dir
#echo "--------------------------------------------"
#cat $log; rm $log
#echo "--------------------------------------------"
echo "BACKUP COMPLETE!"
sleep 60
echo "Unmount..."
while read mountp
do
       umount $mountp -l
done <$backup_mount
while read mountp
do
       umount $mountp -l
done <$source_mount
sleep 15
mdadm --stop $md_raid

echo "OPERATION COMPLETE, Now safe to remove disks and power off"
