/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class CommunitiesForgotPasswordController {
    public String username {get; set;}  
    public String usernameWithExtension {get; set;}   
     public String errorMessage {get; set;} 
       
    public CommunitiesForgotPasswordController() {
      usernameWithExtension = '';
      errorMessage = '';
    
    }
	
  	public PageReference forgotPassword() {  
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
               usernameWithExtension = username + usernameExtensionStr;
          }
                         
            boolean success = Site.forgotPassword(usernameWithExtension);
  		    PageReference pr = Page.KUKA_CommunitiesPasswordConfirmation;
  		    pr.getParameters().put('username',usernameWithExtension);
  		    pr.setRedirect(true);
  		
  	    	if (success && Site.isValidUsername(usernameWithExtension)) {
         		
  			   return pr;
  		   }else {
  		   	  errorMessage = 'Invalid Username';
  	          return null; 
  		   }
  		 
        }
        catch (Exception ex) {        	errorMessage = ex.getMessage();            return null;
        }
    
  		
  		
  	}
}