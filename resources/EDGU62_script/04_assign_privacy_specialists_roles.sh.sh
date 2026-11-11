cat > ~/assign_privacy_specialists_roles.sh <<'BASH'
#!/usr/bin/env bash

assign_privacy_specialists_roles () {
# Load environment variables
source /root/eduvars.txt
echo "Environment variables loaded:"
echo "  SSL_CERT_FILE: $SSL_CERT_FILE"
echo "  REQUESTS_CA_BUNDLE: $REQUESTS_CA_BUNDLE"
echo "  User: $MAIN_ADMIN_USER"
echo ""

echo "Authenticating to SAS Viya..."
sas-viya --profile Default auth login -u "$MAIN_ADMIN_USER" -p "$MAIN_ADMIN_PASSWORD"

# Set repository path
export MYREPO=dgu
export UPLOAD_REPORT=~/upload_report.json
echo "Assumes: SAS Viya CLI Default profile created with valid access token"
echo ""

# Upload JSON file containing groups and rules
echo "Uploading JSON file containing groups and rules..."
sas-viya --profile Default profile set-output text
sas-viya --profile Default transfer upload --file ~/${MYREPO}/files/groups/privacy_group_rules.json > ${UPLOAD_REPORT}

# Read the package ID from the upload report
fileid=$(grep "Id" $UPLOAD_REPORT | awk '{print $2}')
echo "Package ID: ${fileid}"

# Import the package
echo "Importing package with ID ${fileid}..."
export IMPORT_STATUS=$(sas-viya --profile Default -q transfer import --id $fileid)
echo "Import status: $IMPORT_STATUS"
echo ""

# Add user to privacy group
export GROUP_ID=privacy
echo "Adding user to $GROUP_ID group..."
echo "Current group members:"
GROUP_MEMBERS=$(sas-viya --profile Default identities list-members --group-id $GROUP_ID)
echo "$GROUP_MEMBERS"
echo ""

echo "Adding Fiona to the group..."
sas-viya --profile Default identities add-member --group-id $GROUP_ID --user-member-id Fiona

echo "Updated group members:"
GROUP_MEMBERS=$(sas-viya --profile Default identities list-members --group-id $GROUP_ID)
echo "$GROUP_MEMBERS"
echo ""
echo " ✓  Done adding users to ${GROUP_ID} group"
cd ~
}

assign_privacy_specialists_roles
BASH