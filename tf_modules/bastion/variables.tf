/** Name of the instance. Will be used to create a "Name" tag, and
    also to give names to other components like security group,
    IAM role, IAM instance profile, etc.
*/
variable "name" {
  type = string
}

/* ID of the VPC where the bastion is to be launched. We cannot derive it
 * from the name
 */
variable "vpc_id" {
  type = string
}

/* EC2 AMI ID to use for launching the bastion EC2 instance.
 * Note: our user_data.sh assumes we are using Amazon Linux 2.
 */
variable "ami" {
  type = string
}

/* EC2 instance type to use for the bastion instance. */
variable "instance_type" {
  type    = string
  default = "t3a.small"
}

/* ID of a public subnet in which to launch the instance. */
variable "subnet_id" {
  type = string
}

/* Name of the EC2 SSH Keypair to use */
variable "key_name" {
  type = string
}

/* Additional tags to apply to all resources created by this module.
 */
variable "common_tags" {
  type = map
}
