/*variable "instancetype" {
    type = string
    default = var.types["us-west-2"]
}  */

variable types {
    type = map
    default = {
        us-east-1 = "t2.micro"
        us-west-2 = "t2.nano"

    }
}