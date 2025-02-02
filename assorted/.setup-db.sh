#!/usr/bin/env bash
if [ -z "$1" ]
  then
    echo "No File name given !!"
    exit 1
fi
if [ -z "$2" ]
  then
    echo "No Database name given !!"
    exit 1
fi
echo "########################## WARNING ########################################"
echo "Existing Database $2 and filestore for $2 will be dropped"
echo "###########################################################################"

dropdb $2
rm -r ~/.local/share/Odoo/filestore/$2
createdb $2 --encoding=Unicode

mkdir odoodb-unziped
cd odoodb-unziped

echo "Attempting  Extraction of backup file : $1 "
if [[ $1 == *.zip ]]
then
    unzip -o $1
    echo "Finished extracting zip  $1 "
elif [[ $1 == *.sql.gz ]]
then
    gunzip --keep $1
    echo "Finished extracting gunzip  $1 "
else
    echo "Unknown file $1 requires manual extraction"
    cd ..
    rm -r odoodb-unziped
    exit 1
fi


if [[ $1 == *.zip ]]
then
    echo "Setting up the filestore  for DB $s under ~/.local/share/Odoo/filestore/ "
    mv filestore ~/.local/share/Odoo/filestore/
    mv ~/.local/share/Odoo/filestore/filestore ~/.local/share/Odoo/filestore/$2
    echo "Moved file store to ~/.local/share/Odoo/filestore/$2"
    psql $2 < dump.sql
elif [[ $1 == *.sql.gz ]]
then
    backup_name="$(echo "$1" | cut -f 1 -d '.').sql"
    psql $2 < $backup_name
else
    echo "Unknown file $1 requires manual extraction"
    cd ..
    rm -r odoodb-unzipped
    exit 1
fi

cd ..
rm -r odoodb-unziped

uuid=$(uuidgen)
echo "Cleaning Database :  $1"
psql -c "UPDATE ir_cron SET active='f';" -d $1
psql -c "UPDATE ir_mail_server SET active='f';" -d $1
psql -c "UPDATE res_users SET login='admin',password='admin',active='t' WHERE id=1;" -d $1
psql -c "UPDATE res_users SET login='admin2',password='admin',active='t' WHERE id=2;" -d $1
psql -c "UPDATE res_users SET login='admin',password=null,active='t',password_crypt='\$pbkdf2-sha512\$25000\$WqsVQiiFkJIyxnjPmTPGGA\$wFyWXkZTOzKD5ZXttnJUuaVJJeLiYRpk5Rf06N6QpH8c7KHGof9OSzjlv4EJLi3U.rxe.ag4QuEPSA7oW6F6Bg' WHERE id=1;" -d $1
psql -c "UPDATE res_users SET login='admin2',password=null,active='t',password_crypt='\$pbkdf2-sha512\$25000\$WqsVQiiFkJIyxnjPmTPGGA\$wFyWXkZTOzKD5ZXttnJUuaVJJeLiYRpk5Rf06N6QpH8c7KHGof9OSzjlv4EJLi3U.rxe.ag4QuEPSA7oW6F6Bg' WHERE id=2;" -d $1
psql -c "UPDATE ir_config_parameter SET value = '2040-01-01 00:00:00' WHERE key = 'database.expiration_date';" -d $1
psql -c "UPDATE ir_config_parameter SET value = '$uuid' WHERE key = 'database.uuid';" -d $1
psql -c "UPDATE ir_ui_view SET active = 'f' WHERE id in (SELECT id FROM ir_ui_view WHERE  name like '%saas trial assets%');" -d $1
psql -c "DELETE FROM ir_attachment WHERE name like '%assets_%';" -d $1


echo "Database $1 is ready Administrator login with username & password : admin (<= v11) and if admin2 (>= v12) and password admin"
