resource "aws_instance" "docker" {
  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-04a8063bf88d0ec0c"] #replace your SG
  subnet_id = "subnet-0534eac854c0e6cce" #replace your Subnet
  ami = data.aws_ami.ami_info.id

  provisioner "remote-exec" {
    connection {
        agent    = "false"
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = aws_instance.docker.public_ip
    }
    inline = [ 
        "sudo yum install -y yum-utils",
        "sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo",
        "sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y",
        "sudo usermod -aG docker ec2-user",
        "sudo systemctl start docker",
        "sudo systemctl daemon-reload",
        "sudo systemctl status docker",
     ]
  }

  tags = {
    Name = "docker-tf"
  }  
}

