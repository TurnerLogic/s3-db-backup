# S3 DB Backup Helper

This script can be used to backup a MySQL database to a folder in an S3 bucket. No warranty. USE AT YOUR OWN RISK.

### First, install the AWS CLI:

```
pip install awscli --upgrade --user
```

### Make sure that your path is set properly:

```
# Make sure path is set correctly.
vim ~/.bash_profile

# Add this line if it is missing.
export PATH=~/.local/bin:$PATH

# Save and then source the file.
source ~/.bash_profile
```

### Create an IAM policy in AWS:

- Log into the AWS console, select IAM > Policy.
- Click 'Select' on 'Create Your Own Policy'.
- Specify a memorable policy name such as 'bucket-site-s3-write'.
- Paste the contents of 'sample-iam-policy' and specify your bucket and folder names.

### Create an IAM user in AWS:

- Log into the AWS console, select IAM > Users.
- Click 'Add User'.
- Enter a user name such as 'site-name.dev-backup', check 'programmatic access', and click next.
- Click 'Attach existing policies directly'.
- Search for the policy created above and check the checkbox next to it, then click 'Next'.
- Click 'Create User', and then use the credentials provided when creating the config file below.

### Create a config file and add all of the necessary credentials:

```
cp sample-config config\site-name.dev
```

### Test the script:

```
./backup.sh
```

### Add to a cron to run on a schedule:

```
# Edit your crontab file.
crontab -e

# Add this line to backup once daily at 2am.
0 2 * * * ~/s3_db_backup/backup.sh > ~/s3_db_backup/log.txt
```
