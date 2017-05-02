global class LightningForgotPasswordController {

    public LightningForgotPasswordController() {

    }

    @AuraEnabled
    public static String forgotPassword(String username, String checkEmailUrl) {
        try {
          
          //@Arokia Suresh Kumar
          // Added the code to handle userlogin without extension        
          if(username != null) { 
               communitySelfRegSettings__c usernameExtension = communitySelfRegSettings__c.getInstance('usernameExtension');
               String usernameExtensionStr ='';
               if(null != usernameExtension && !(username.contains(usernameExtension.value__c))){
                  if(usernameExtension.id == null) {                     usernameExtensionStr = '.kuka';                  
                      } else{
                      // read values
                      usernameExtensionStr = usernameExtension.value__c;          
                   }
               }              
               username = username + usernameExtensionStr;
          }
              //***********************************************
        	
            Site.forgotPassword(username);
            ApexPages.PageReference checkEmailRef = new PageReference(checkEmailUrl);
            checkEmailRef.getParameters().put('username',username);
            if(!Site.isValidUsername(username)) {
                return Label.Site.invalid_email;
            }
            aura.redirect(checkEmailRef);            return null;
        }
        catch (Exception ex) {
            return ex.getMessage();
        }
    }

}