provider "google" {
  credentials = "${file("${var.credentials}")}"
  project     = "${var.gcp_project}"
  region      = "${var.region}"
}


resource "google_compute_address" "consulip" {
  name   = "${var.consul_instance_ip_name}"
  region = "${var.consul_instance_ip_region}"
}


resource "google_compute_instance" "consul" {
  name         = "${var.instance_name}"
  machine_type = "n1-standard-2"
  zone         = "us-east1-b"

  tags = ["name", "consul", "http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "centos-7-v20180129"
    }
  }

  // Local SSD disk
  #scratch_disk {
  #}

  network_interface {
    network    = "${var.consulvpc}"
    subnetwork = "${var.consulsub}"
    access_config {
      // Ephemeral IP
      nat_ip = "${google_compute_address.consulip.address}"
    }
  }
  metadata = {
    name = "consul"
  }

  metadata_startup_script = "sudo yum update -y;sudo yum install git -y; sudo git clone https://github.com/Diksha86/consul.git; cd consul; sudo chmod 777 /consul/*; sudo sh consul.sh"
}
