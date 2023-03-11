 resource "azuread_application" "linkedin_app" {
   display_name = "Linked In Profile"
   owners           = [data.azuread_client_config.current.object_id]

   web {
     redirect_uris = ["https://linkedinprofiletak.azurewebsites.net/.auth/login/aad/callback"]

     implicit_grant {
       access_token_issuance_enabled = true
       id_token_issuance_enabled     = true
     }
   }
 }
 resource "azuread_application_password" "linkedin_app" {
   display_name = "Generated by terraform"
   application_object_id = azuread_application.linkedin_app.object_id
 }
