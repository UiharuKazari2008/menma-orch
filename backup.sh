##### Remote Control
ipmi_host=<host or ip>
ipmi_user=<username>
ipmi_pass=<password>
##### Backup Server
backup_data=<host or ip>
backup_dir=<folder>
##### Sources
source_dir=<folder or folder of links>
source_skip=<file list of excluded items>
##### Other
source_mount=<file list of source mount points>
backup_mount=<mount point to backup server>
log=<file to store rsync log>

echo "Menma DPS v0.1 - Data Proccesser"
echo "Starting Menma Array................"
ipmitool -H $ipmi_host -U $ipmi_user -P $ipmi_pass chassis power on
echo "Waiting for system to become ready................."
until ping -c 1 $backup_data > /dev/null
do
        sleep 30;
done
echo "Prepating Dirs..............."
mount $backup_mount
while read mountp
do
	mount $mountp
done <$source_mount
echo "Backing up files..............."
rsync -rLtpogb --progress --exclude-from=$source_skip --log-file=$log $source_dir $backup_dir
echo "BACKUP COMPLETE!"
echo "Shutting down Menma..............."
sleep 60
umount $backup_mount -l
ipmitool -H $ipmi_host -U $ipmi_user -P $ipmi_pass chassis power soft
echo "Unmount..............."
while read mountp
do
       umount $mountp -l
done <$source_mount

echo "OPERATION COMPLETE"
