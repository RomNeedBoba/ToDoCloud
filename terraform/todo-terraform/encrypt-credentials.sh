# #!/bin/bash
# aws kms encrypt \
#   --key-id 528b8b0a-2293-4d17-9dea-0814d1b443ec \
#   --plaintext fileb://db-creds.yml \
#   --output text \
#   --query CiphertextBlob \
#   > db-creds.yml.encrypted
