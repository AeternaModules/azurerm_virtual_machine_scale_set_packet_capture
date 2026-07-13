variable "virtual_machine_scale_set_packet_captures" {
  description = <<EOT
Map of virtual_machine_scale_set_packet_captures, attributes below
Required:
    - name
    - network_watcher_id
    - virtual_machine_scale_set_id
    - storage_location (block):
        - file_path (optional)
        - storage_account_id (optional)
Optional:
    - maximum_bytes_per_packet
    - maximum_bytes_per_session
    - maximum_capture_duration_in_seconds
    - filter (block):
        - local_ip_address (optional)
        - local_port (optional)
        - protocol (required)
        - remote_ip_address (optional)
        - remote_port (optional)
    - machine_scope (block):
        - exclude_instance_ids (optional)
        - include_instance_ids (optional)
EOT

  type = map(object({
    name                                = string
    network_watcher_id                  = string
    virtual_machine_scale_set_id        = string
    maximum_bytes_per_packet            = optional(number)
    maximum_bytes_per_session           = optional(number)
    maximum_capture_duration_in_seconds = optional(number)
    storage_location = object({
      file_path          = optional(string)
      storage_account_id = optional(string)
    })
    filter = optional(list(object({
      local_ip_address  = optional(string)
      local_port        = optional(string)
      protocol          = string
      remote_ip_address = optional(string)
      remote_port       = optional(string)
    })))
    machine_scope = optional(object({
      exclude_instance_ids = optional(list(string))
      include_instance_ids = optional(list(string))
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.virtual_machine_scale_set_packet_captures : (
        length(v.name) > 0
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.virtual_machine_scale_set_packet_captures : (
        v.maximum_capture_duration_in_seconds == null || (v.maximum_capture_duration_in_seconds >= 1 && v.maximum_capture_duration_in_seconds <= 18000)
      )
    ])
    error_message = "must be between 1 and 18000"
  }
  validation {
    condition = alltrue([
      for k, v in var.virtual_machine_scale_set_packet_captures : (
        v.machine_scope == null || (v.machine_scope.exclude_instance_ids == null || (alltrue([for x in v.machine_scope.exclude_instance_ids : length(x) > 0])))
      )
    ])
    error_message = "must not be empty"
  }
  validation {
    condition = alltrue([
      for k, v in var.virtual_machine_scale_set_packet_captures : (
        v.machine_scope == null || (v.machine_scope.include_instance_ids == null || (alltrue([for x in v.machine_scope.include_instance_ids : length(x) > 0])))
      )
    ])
    error_message = "must not be empty"
  }
  # Note: 7 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

