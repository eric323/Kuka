/**
 * An apex page controller that supports self registration complete page
 */
/**********************************************************************
Name:  CommunityCompleteController
======================================================
Purpose: Controller for KUKA_communitiesCompletePage pages
======================================================
History
-------
Date        AUTHOR                          DETAIL
11/01/2017  Andreas Meyer                   INITIAL
3/10/2017   Arokia Suresh Kumar Joseph		Added source related changes
4/03/2017	Jade Fischer					Used source value to redirect 
*********************************************************************/
public class CommunityCompleteController {

 	public Contact helperContact {get; set;}
    
 	public String sourceURL {get;set;}
 	  //Added code to redirect to starting url using sourceURL Jade Fischer
 	  public PageReference closePage(){
 	  	
 	  	PageReference acctPage ; 
 	  	if(sourceURL != null){
 	  		 acctPage = new PageReference(sourceURL);
 	  	} else {
 	  		acctPage = new PageReference('javascript:window.close()');
 	  	}
  		
        acctPage.setRedirect(true);			
        return acctPage;
   }

    public CommunityCompleteController() {
        // create helper contact
        this.helperContact = new Contact();  
        // get page parameter:
        String hcustomersalutation = ApexPages.currentPage().getParameters().get('customersalutation');  
        
        String hSource = ApexPages.currentPage().getParameters().get('source');
        if (false == String.isBlank(hSource)){
            RedirectURLConfig__c redirectURLConfig = RedirectURLConfig__c.getInstance(hSource.toUpperCase());
            if(null != redirectURLConfig){
           	sourceURL = redirectURLConfig.targetURL__c;
           }
        }  
      
           
        if (false == String.isBlank(hcustomersalutation)){
            this.helperContact.Salutation = hcustomersalutation;
        }              
    }

}