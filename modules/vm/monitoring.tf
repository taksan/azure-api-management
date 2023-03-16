resource "azurerm_virtual_machine_extension" "vm_log_agent" {
  name                 = "AzureMonitorLinuxAgent"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Monitor"
  type                 = "AzureMonitorLinuxAgent"
  type_handler_version = "1.24"
  auto_upgrade_minor_version = "true"
}

resource "azurerm_virtual_machine_extension" "da" {
  depends_on                = [ azurerm_virtual_machine_extension.vm_log_agent ]
  name                       = "DependencyAgentLinux"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentLinux"
  type_handler_version       = "9.5"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
}

resource "azurerm_monitor_data_collection_rule" "vm_dcr" {
  name                = "${var.vm_name}-dcr"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  destinations {
    log_analytics {
      workspace_resource_id = var.log_analytics_workspace.id
      name                  = "${var.vm_name}-destination-analytics"
    }

    azure_monitor_metrics {
      name = "${var.vm_name}-destination-metrics"
    }
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["${var.vm_name}-destination-metrics"]
  }

  data_flow {
    streams      = ["Microsoft-ServiceMap", "Microsoft-InsightsMetrics", "Microsoft-Syslog"]
    destinations = ["${var.vm_name}-destination-analytics"]
  }

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers            = ["\\VmInsights\\DetailedMetrics"]
      name                          = "perfCounterDataSource60"
    }
    syslog {
      name           = "syslog-datasource"
      streams        = ["Microsoft-Syslog"]
      facility_names = [
        "auth",
        "authpriv",
        "cron",
        "daemon",
        "mark",
        "kern",
        "local0",
        "local1",
        "local2",
        "local3",
        "local4",
        "local5",
        "local6",
        "local7",
        "lpr",
        "mail",
        "news",
        "syslog",
        "user",
        "uucp"
      ]
      log_levels     = [
        "Debug",
        "Info",
        "Notice",
        "Warning",
        "Error",
        "Critical",
        "Alert",
        "Emergency"
      ]
    }
    extension {
      streams        = ["Microsoft-ServiceMap"]
      extension_name = "DependencyAgent"
      name           = "DependencyAgentDataSource"
    }
  }
  tags = merge(var.default_tags, local.tags)
}

# associate to a Data Collection Rule
resource "azurerm_monitor_data_collection_rule_association" "vm_dcra" {
  name                    = "${var.vm_name}-vm-dcra"
  target_resource_id      = azurerm_linux_virtual_machine.vm.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.vm_dcr.id
  description             = "${var.vm_name} vm data collection association"
}
