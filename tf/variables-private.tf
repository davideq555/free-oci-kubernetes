variable "compartment_id" {
  type        = string
  description = "The compartment to create the resources in"
  default     = "ocid1.tenancy.oc1..aaaaaaaai57sijr7g2fia5fvunkrjh62u7rc4dvxxjswr7qka3pdjj2qkp4a"
}
variable "region" {
  type        = string
  description = "The region to provision the resources in"
  default     = "sa-saopaulo-1"
}
variable "ssh_public_key" {
  type        = string
  description = "The SSH public key to use for connecting to the worker nodes"
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKIwKAHzN7ikGyxpwvHelNfus2fOaAlp3fMW0/rgXG+k deqa@gideon"
}
variable "bastion_allowed_ips" {
  type        = list(string)
  description = "List of IP prefixes allowed to connect via bastion"
  default     = ["187.62.94.135/32"]
}
variable "ad_list" {
  type        = list
  description = "List of length 2 with the names of availability regions to use"
  default     = ["evwi:SA-SAOPAULO-1-AD-1", "evwi:SA-SAOPAULO-1-AD-1"]
}
variable "git_token" {
  description = "Git PAT"
  sensitive   = true
  type        = string
  default     = null
}
variable "git_url" {
  description = "Git repository URL"
  default     = "https://github.com/davideq555/free-oci-kubernetes"
  type        = string
  nullable    = false
}
