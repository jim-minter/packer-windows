#!/bin/bash -ex

TMPDIR=/data/var/tmp packer build -only=qemu windows_2012_r2.json
vagrant box remove windows_2012_r2_libvirt || true
vagrant box add --name windows_2012_r2_libvirt windows_2012_r2_libvirt.box
sudo ln -f /home/jminter/.vagrant.d/boxes/windows_2012_r2_libvirt/0/libvirt/box.img /var/lib/libvirt/images/windows_2012_r2_libvirt_vagrant_box_image_0.img
sudo chown qemu:qemu /var/lib/libvirt/images/windows_2012_r2_libvirt_vagrant_box_image_0.img
sudo chmod 0600 /var/lib/libvirt/images/windows_2012_r2_libvirt_vagrant_box_image_0.img
rm -f windows_2012_r2_libvirt.box
