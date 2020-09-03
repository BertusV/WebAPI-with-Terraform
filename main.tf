provider "azurerm" {
    version = "2.5.0"
    features {}
}


terraform {
    backend "azurerm" {
        resource_group_name  = "BV_Storage_Resource_Group"
        storage_account_name = "bvstorageaccount"
        container_name       = "terraformstates"
        key                  = "terraform.tfstate"
    }
}

variable "imagebuild" {
  type        = string
  description = "Latest Image Build"
}

resource "azurerm_resource_group" "tf_test" {
    name = "BVTerraformRG"
    location = "Australia East"
}

resource "azurerm_container_group" "tfcg_test" {
    name                    = "bvweatherapi"
    location                = azurerm_resource_group.tf_test.location
    resource_group_name     = azurerm_resource_group.tf_test.name

    ip_address_type     = "public"
    dns_name_label      = "bertusvwapitf"
    os_type             = "Linux"

      container {
      name            = "weatherapi"
      image           = "bertusv/weatherapi:${var.imagebuild}"
        cpu             = "1"
        memory          = "1"

        ports {
            port        = 80
            protocol    = "TCP"
        }
  }

}