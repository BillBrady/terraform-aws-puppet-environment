#--------------------------------------------------------------
# This module creates the puppet master resources
#--------------------------------------------------------------

#--------------------------------------------------------------
# Resources: Build Puppet Master Configuration
#--------------------------------------------------------------
data "template_file" "init" {
    template = "${file("modules/puppet/bootstrap/bootstrap_pe.tpl")}"
    vars {
        master_name   = "${var.name}"
        master_fqdn   = "${var.name}.${var.domain}"
        git_pri_key   = "${file("${var.git_pri_key}")}"
        git_pub_key   = "${file("${var.git_pub_key}")}"
        git_url       = "${var.git_url}"
        eyaml_pri_key = "${file("${var.eyaml_pri_key}")}"
        eyaml_pub_key = "${file("${var.eyaml_pub_key}")}"
        user_name     = "${var.user_name}"
        version       = "${var.pe_version}"
    }
}

resource "aws_instance" "puppet" {

  ami                         = "${var.ami}"
  instance_type               = "m4.large"
  associate_public_ip_address = "true"
  subnet_id                   = "${var.subnet_id}"
  key_name                    = "${var.sshkey}"

  tags {
    Name = "${var.name}.${var.domain}"
    department = "tse"
    project = "Demo"
    created_by = "${var.user_name}"
    termination_date = "2020-06-01T19:59:02.539657+00:00"
  }
  user_data = "${data.template_file.init.rendered}"
}