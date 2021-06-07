data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "jenkinsmaster" {
  key_name   = "jenkinsmaster"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTBbLPNTg7aE65bA2T5PqYU5LIRas5ohXUh/cQDCTMkc0anR6y6NIlQP26sEykfdsuAxun/nqeC969MVmT9PmGrXAtiXHgw1hrdDDM83Lo0sMiLmUfJ9jraYS+hEUbdLtRChlDmAPW3KE84oXOWvweHK35NtKyXrT8XzqZEXVaJc6grTF2ywL6HN4+9NhyR7J4Enku3ku5DSC5t4Of7RRHhQTH52Edb5bo8f6m4gNRFU4PxAt9uTkSMJft1ymWYHt2Zv7QrYXgkrrh29aYnn4/KoxPeankdrNRu/dOcWWTd1f5A5AZza379yxjEaMzZlFndS8+1pDpHBN2LiP+R+XL8axWh1DWd8qe8a7QgckJ5uVbRw/nnqmikCi8cbxuohmrTCCSd94A0utHoTdgTPLT7d083SiKc5+43gYnra2oU19rzNJC5G1Nd+SMs3RVPtqaaDv9+c25zX/BErg4E7MwKCRYqueAnq9P3Ehgix/sPjf1I1ku+0zzu7iV4K0o1us= deeptesh@localserver"
}

resource "aws_instance" "jenkinsmaster" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  availability_zone           = "us-east-1a"
  key_name                    = "jenkinsmaster"
  root_block_device {
    volume_size = "30"
    volume_type = "gp2"
  }
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.jenkins_traffic_rules.id]
  user_data              = file("jenkinsinit.sh")


  tags = {
    Name = "JenkinsMaster"
  }
}
output "instance_public_ip" {
  value = aws_instance.jenkinsmaster.public_ip
}
