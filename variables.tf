#-------------------------------------------------------------------------------
# AMI
#-------------------------------------------------------------------------------

variable "disk_type" {
  type        = "string"
  description = "Volume type - ebs (magnetic) or gp2 (SSD)."
}

variable "instance_type" {
  type = "string"
  description = "Type of instance to be created. t2.mico, m4.large, etc."
}

#-------------------------------------------------------------------------------
# RDS
#-------------------------------------------------------------------------------
