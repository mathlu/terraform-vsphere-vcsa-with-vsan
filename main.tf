################################################################################
################################################################################
################################################################################
###                                                                          ###
### Name: terraform-vsphere-vcsa                                             ###
### Description: [Terraform] Module to create and deploy VMware VCSA         ###
### Last Modified: fparry(2020-10-14T10:44:56-04:00)                         ###
### License: MIT (See LICENSE.txt in the root of this repository for more    ###
###   information.)                                                          ###
###                                                                          ###
################################################################################
################################################################################
################################################################################

locals {
  vctemplate_out = templatefile("${path.module}/template/vctemplate.json.tpl", {
    esxihostname       = var.vcbuild_esxihostname
    esxiusername       = var.vcbuild_esxiusername
    esxipassword       = var.vcbuild_esxipassword
    deployment_network = var.vcbuild_deployment_network
    thin_disk_mode     = var.vcbuild_thin_disk_mode
    deployment_option  = var.vcbuild_deployment_option
    vchostname         = var.vcbuild_vchostname
    ip_family          = var.vcbuild_ip_family
    network_mode       = var.vcbuild_network_mode
    vcrootpassword     = var.vcbuild_vcrootpassword
    vcssopassword      = var.vcbuild_vcssopassword
    ntp_servers        = var.vcbuild_ntp_servers
    ssh_enable         = var.vcbuild_ssh_enable
    sso_domain_name    = var.vcbuild_sso_domain_name
    vcfqdn             = var.vcbuild_vcfqdn
    vcipaddress        = var.vcbuild_vcip
    dnsserver          = var.vcbuild_dnsserver
    ipprefix           = var.vcbuild_ipprefix
    gateway            = var.vcbuild_gateway
    ceip_enabled       = var.vcbuild_ceip_enabled
    datacenter         = var.vcbuild_datacenter
    cluster            = var.vcbuild_cluster
    vsan_cache_disk    = var.vcbuild_cache_disk
    vsan_capacity_disk = var.vcbuild_capacity_disk
  })
}
resource "local_file" "vcbuild_output" {
  filename = "/home/runner/vctemplate-vsan.json"
  content  = local.vctemplate_out
}
resource "null_resource" "vc" {
  provisioner "local-exec" {
    command = "/home/runner/vcenter/vcsa-cli-installer/lin64/vcsa-deploy install --accept-eula --acknowledge-ceip --no-ssl-certificate-verification --verbose /home/runner/vctemplate-vsan.json"
  }
}
