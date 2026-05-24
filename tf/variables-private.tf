variable "compartment_id" {
  type        = string
  description = "The compartment to create the resources in"
  default     = "ocid1.user.oc1..aaaaaaaa5v32pgayaszlsb25y5wkfhriwucijfy6and2kod3j4vydzgl6m3a"
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
  default     = ["IYfK:SA-SAOPAULO-1-AD-1", "IYfK:SA-SAOPAULO-1-AD-1"]
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
