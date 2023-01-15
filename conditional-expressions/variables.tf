variable access_key {
    type = string
    default = ""
}

variable secret_key {
    type = string
    default = ""
}

variable types {
    type = map
    default = {
        prod = "t2.micro"
        dev = "t2.nano"

    }
}

variable is_test {

}