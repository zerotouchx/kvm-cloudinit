provider "libvirt" {
    uri = "qemu+ssh://tesla@oregon.anatolia.io/system"
}

resource "libvirt_volume" "centos71-test" {
  name = "centos71-test"
  format = "qcow2"
  pool = "KVMGuests"
  #qcow2 will be cloud-init compatible qcow2 disk image
  #https://cloud.centos.org/centos/7/images/
  source =  "http://oregon.anatolia.io/qcow2-repo/centos71-cloud.qcow2"
}


data "template_file" "user_data" {
 template = file("${path.module}/cloud_init.cfg")
}

data "template_file" "meta_data" {
 template = file("${path.module}/network_config.cfg")
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name           = "cloudinit.iso"  
  user_data      = data.template_file.user_data.rendered
  meta_data      = data.template_file.meta_data.rendered
  pool           = "KVMGuests"
}


resource "libvirt_domain" "centos71-test" {
 autostart = "true"
  name   = "centos71-test"
  memory = "2048"
  vcpu   = 2
  running = "true"
  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  network_interface {
      network_name = "default"
  }

 disk {
       #scsi = "true"
       volume_id = libvirt_volume.centos71-test.id
  }
console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

}


          
