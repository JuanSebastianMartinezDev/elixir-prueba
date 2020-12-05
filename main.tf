

provider "aws" {
	region = var.my_region
	access_key = var.my_access_key
	secret_key = var.my_secret_key
}

resource "aws_instance" "final" {
	ami = var.my_ami
	instance_type = var.my_instance_type
	key_name = "testfabio"
	user_data = <<-EOF
	        #!/bin/bash

					sudo yum update -y
				  sudo amazon-linux-extras install epel -y
					sudo yum install nginx

					sudo yum install postgresql postgresql-server postgresql-devel -y
					sudo service postgresql initdb
					sudo service postgresql start
					sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses='*'/"  /var/lib/pgsql/data/postgresql.conf
					sudo sed -i "s/#port = 5432/port = 5432/" /var/lib/pgsql/data/postgresql.conf
					sudo sed -i "s/peer/trust/" /var/lib/pgsql/data/pg_hba.conf
					sudo sed -i "s/ident/trust/" /var/lib/pgsql/data/pg_hba.conf
					sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password 'postgres';"
					sudo systemctl restart postgresql.service


					sudo yum install ncurses-devel openssl-devel
					sudo yum update
					sudo amazon-linux-extras install apel
					curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
					sudo wget https://erlang.org/download/otp_src_23.1.tar.gz
					sudo tar -zxvf otp_src_23.1.tar.gz
					sudo rm otp_src_23.1.tar.gz
					cd otp_src_23.1/
					sudo yum groupinstall "Development Tools" -y
					sudo ./configure
					sudo make
					sudo make install

					sudo wget https://github.com/elixir-lang/elixir/archive/v1.11.zip
					sudo unzip v1.11.zip
					sudo rm v1.11.zip
					cd v1.11
					sudo make
					sudo make install

		    EOF

	tags = {
		Name = "instancia_fabio"
	}
	vpc_security_group_ids = [aws_security_group.securitygroup.id]
}
#--------------------------------
resource "aws_security_group" "securitygroup" {
	name = "terraform-tcp-security-group-Fabio"

	ingress {
			from_port = 80
			to_port = 80
			protocol = "tcp"
			cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
			from_port   = 22
			to_port     = 22
			protocol    = "tcp"
			cidr_blocks = ["0.0.0.0/0"]
	}
  egress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
	egress {
      from_port = 22
      to_port = 22
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}
