echo generTxt

read -p "Please Select The DB You Want To Backup : " dbback
DATE=$(date)
sudo mysqldump --no-create-info --tab=./ $dbback_$DATE.txt
