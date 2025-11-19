# SSH key for Terraform / EC2

This folder should contain the public key used by Terraform to create the EC2 `aws_key_pair`.

Steps to generate and use keys (run on your local machine):

1. Generate the keypair locally (this will create `wp_key` and `wp_key.pub`):

```bash
ssh-keygen -t rsa -b 4096 -f ~/Downloads/wp_key -N ""
mkdir -p keys
mv ~/Downloads/wp_key.pub keys/wp_key.pub
```

2. Commit only the public key to the repo:

```bash
git add keys/wp_key.pub
git commit -m "Add public SSH key for EC2" 
git push
```

3. Keep the private key local and do NOT push it. The private key file can be stored safely on your laptop at `~/.ssh/wp_key` or `~/Downloads/wp_key`. Add it to your personal `.gitignore` if needed.

Notes:
- Terraform Cloud / remote runners cannot access your desktop. By committing the public key you ensure Terraform can create the `aws_key_pair` without needing access to your private key.
- Never commit private keys or sensitive files to the repo.
