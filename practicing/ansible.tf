#createing ansible-ec2 instance using terraform for practicing

resource "aws_instance" "ansible" {
    ami = "ami-09c813fb71547fc4f"
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.allow_ssh_terraform.id]

    tags = {
        Name = "ansible-server"
    }

#For remote exec; need conection block
connection {
  type     = "ssh"
  user     = "ec2-user"
  password = "DevOps321"
  host     = self.public_ip
}

#Creation time Provision: Provisioners will execute at the timw resource creation
  provisioner "remote-exec" {
    inline = [
      "sudo dnf install ansible -y",
    ]
}
}
resource "aws_security_group" "allow_ssh_terraform" {
    name = "allow-all-ports-ansible"
    description = "Allow port 22 for ssh access"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name = "ansible"
    }
}
