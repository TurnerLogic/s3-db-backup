#!/bin/bash

# Visit https://github.com/turnerlogic/s3-db-backup for complete information.
# (c) Turner Logic, LLC. Distributed under the GNU GPL v2.0.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create a temp directory if one doesn't already exist.
if [ ! -d "$SCRIPT_DIR/temp" ]; then
    mkdir $SCRIPT_DIR/temp
fi

TEMP=$SCRIPT_DIR/temp

for SITE_CONFIG in $(ls $SCRIPT_DIR/config)
do
    # Reset all configuration options.
    DBHOST=localhost
    DBPORT=3306
    DBUSER=''
    DBPASS=''
    DBNAME=''
    S3BUCKET=''
    S3REGION=''
    AWS_ACCESS_KEY_ID=''
    AWS_SECRET_ACCESS_KEY=''
    AWS_DEFAULT_REGION=''

    echo Backing up $SITE_CONFIG...

    # Load configuration for this site.
    source $SCRIPT_DIR/config/$SITE_CONFIG

    DUMP_FILE=$TEMP/$DBNAME-$(date +%Y-%m-%d).sql

    # Dump the MySQL DB to a file.
    mysqldump \
        --host $DBHOST \
        --port $DBPORT \
        --user=$DBUSER \
        --password="$DBPASS" \
        $DBNAME > $DUMP_FILE
    
    if [ $? -eq 0 ]; then
        # Backup succeeded, zip file and transfer file to S3.
        gzip ${DUMP_FILE}

        AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
        AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
        AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
        aws s3 cp $DUMP_FILE.gz s3://$S3BUCKET/$SITE_CONFIG/

        # Keep the most recent backup locally.
        mv $DUMP_FILE.gz $SCRIPT_DIR/last_backup/$SITE_CONFIG.sql.gz
    else
        echo "MySQL backup failed."
        exit 255
    fi
done
