# S3 DB Backup Helper

This script can be used to backup a MySQL database to a folder in an S3 bucket. No warranty. USE AT YOUR OWN RISK.

### Clone this script to your home directory:

```
cd ~/
git clone https://github.com/TurnerLogic/s3-db-backup.git
```

### Install the AWS CLI:

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

# Test the aws command and resolve any issues.
aws
```

### Create an IAM policy in AWS:

- Log into the AWS console, select IAM > Policy.
- Click 'Select' on 'Create Your Own Policy'.
- Specify a memorable policy name such as 'BUCKETNAME.CONFIGNAME.s3.backup'.
- Paste the contents of 'sample-iam-policy' and specify your bucket and folder names.

### Create an IAM user in AWS:

- Log into the AWS console, select IAM > Users.
- Click 'Add User'.
- Enter a user name such as 'CONFIGNAME.backup', check 'Programmatic Access', and click next.
- Click 'Attach existing policies directly'.
- Search for the policy created above and check the checkbox next to it, then click 'Next'.
- Click 'Create User', and then use the credentials provided when creating the config file below.

### Create a config file and add all of the necessary credentials:

```
cd ~/s3-db-backup

# Duplicate sample config, adding your configuration name.
# Note that the s3 folder and CONFIGNAME must match.
cp sample-config config/CONFIGNAME
```

### Test the script:

```
./backup.sh
```

### Run on a schedule:

```
# Edit the crontab file.
crontab -e

# Add this line to backup once daily at 2am.
# Replace USERNAME with your actual username.
0 2 * * * /home/USERNAME/s3-db-backup/backup.sh > /home/USERNAME/s3-db-backup/log.txt
```
