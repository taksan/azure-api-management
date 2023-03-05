variable "resource_group_location" {
  type = string
}

variable "api_publisher_name" {
  type = string
}

variable "api_publisher_email" {
  type = string
}

variable "linked_api_users" {
  type = map(object({
    first_name = string
    last_name  = string
    password = string
  }))

  description = "Map of users that have developer access to the linkedin api"
}
