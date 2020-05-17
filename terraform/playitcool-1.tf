resource "digitalocean_droplet" "playitcool-1" {
  image              = "ubuntu-18-04-x64"
  name               = "playitcool-1"
  region             = "fra1"
  size               = "s-1vcpu-1gb"
  private_networking = true
  # vpc_uuid           = digitalocean_vpc.default.id
  ssh_keys = [
    var.ssh_fingerprint
  ]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "export PATH=$PATH:/usr/bin",
  #     "sudo apt-get upgrade -y",
  #     "sudo apt-get update -y",
  #     "sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common git -y",
  #     "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
  #     "sudo apt-key fingerprint 0EBFCD88",
  #     "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
  #     "sudo apt-get update -y",
  #     "sudo apt-get install docker-ce docker-ce-cli containerd.io -y",
  #     "mkdir /app && cd /app",
  #     "docker run -p 4000:80 -d nginx"
  #   ]
  # }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get upgrade -y",
      "sudo apt-get update -y",
      "sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common git -y",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo apt-key fingerprint 0EBFCD88",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt-get update -y",
      "sudo apt-get install docker-ce docker-ce-cli containerd.io -y",
      "mkdir /app && cd /app",
      "git clone https://github.com/SnakesCantWearHats/play_it_cool.git .",
      "SECRET_KEY_BASE=$(date +%s | sha256sum | base64 | head -c 32 ; echo)",
      "TOKEN_SECRET=$(date +%s | sha256sum | base64 | head -c 32 ; echo)",
      "RAW_DATABASE_URL=\"${digitalocean_database_cluster.default_postgres.private_uri}\"",
      "DATABASE_URL=\"ecto$(echo $RAW_DATABASE_URL | tail -c +11 | head -c -17)?ssl=true\"",
      "sudo docker build . -t playitcool --build-arg DATABASE_URL=$DATABASE_URL --build-arg PORT=4000 --build-arg SECRET_KEY_BASE=$SECRET_KEY_BASE --build-arg TOKEN_SECRET=$TOKEN_SECRET",
      "sudo docker run -p 80:4000 -d playitcool"
    ]
  }
}

output "playitcool-1-ip" {
  value = digitalocean_droplet.playitcool-1.ipv4_address
}

