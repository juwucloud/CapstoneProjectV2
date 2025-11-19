/* Use a checked-in public key for reproducible keypairs.
   Generate the keypair locally and commit only the public key to the repo
   at `keys/wp_key.pub`. Keep the private key (`keys/wp_key`) on your machine
   and do NOT commit it. */

resource "aws_key_pair" "wp_key" {
  key_name   = "wp_key"
  public_key = file("${path.module}/keys/wp_key.pub")
}

