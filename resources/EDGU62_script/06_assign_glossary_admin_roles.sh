cat > ~/assign_glossary_admin_roles.sh <<'BASH'
#!/usr/bin/env bash

assign_glossary_admin_roles () {
# Load environment variables
cd ~
source /root/eduvars.txt
echo "Environment variables loaded:"
echo "  SSL_CERT_FILE: $SSL_CERT_FILE"
echo "  REQUESTS_CA_BUNDLE: $REQUESTS_CA_BUNDLE"
echo "  User: $MAIN_ADMIN_USER"
echo ""

echo "Authenticating to SAS Viya..."
sas-viya --profile Default auth login -u "$MAIN_ADMIN_USER" -p "$MAIN_ADMIN_PASSWORD" || return 1

# Configure CLI output
sas-viya --profile Default profile set-output text

# Add user to Glossary Administrator group
export GROUP_ID=Glossary.GlossaryAdministrators
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

assign_glossary_admin_roles
BASH