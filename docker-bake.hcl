group "default" {
  targets = [
    "t1",
    "t2",
  ]
}

variable "TAGS" {
  type    = string
  default = "main"
}

function "tags" {
  params = [image]
  result = [for tag in split(",", TAGS) : "ghcr.io/pirosiki197/${image}:${tag}"]
}

# https://github.com/docker/metadata-action?tab=readme-ov-file#bake-definition
target "docker-metadata-action" {}

target "base" {
  inherits = ["docker-metadata-action"]
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
}

target "t1" {
  inherits = ["base"]
  target   = "t1"
  tags     = tags("test1")
}

target "t2" {
  inherits = ["base"]
  target   = "t2"
  tags     = tags("test2")
}
