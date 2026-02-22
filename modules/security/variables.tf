variable "globals" {
  description = "Output from globals module"
  type = object({
    account_id     = string
    env            = string
    global_tags    = map(string)
    project_prefix = string
    name_prefix    = string
    region         = string
  })
}
