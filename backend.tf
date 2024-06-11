terraform {
  backend "consul" {
    path    = "terraform/state/flex-aws"
	lock = true
  }
}
