/**********************************************************************
Name:  CommunityCompleteControllerTest
======================================================
Purpose:

Unittest Class for CommunityCompleteController
======================================================
History
-------
Date            AUTHOR                      DETAIL
12/01/2017      Andreas Meyer               INITIAL
30/3/2017      Arokia Suresh Kumar 			add test methods the source redirect functionality
*********************************************************************/
@isTest(seeAllData=false)
private class CommunityCompleteControllerTest {
   
    static testMethod void testCommunityCompleteController() {
        CommunityCompleteController controller = new CommunityCompleteController();
        System.assert(controller.helperContact.Salutation == null);         
    }
    
   
    static testMethod void testCommunityCompletePageParameterValidation() {
        CommunityCompleteController controller = new CommunityCompleteController();       
        System.assert( controller.sourceURL == null);         
    }
    
   
    static testMethod void testCommunityCompletePageParameter() {
        Test.setCurrentPageReference(new PageReference('Page.KUKA_communitiesCompletePage')); 
        System.currentPageReference().getParameters().put('source', 'Connect');
        CommunityCompleteController controller = new CommunityCompleteController();
       
       
    }
    
      static testMethod void testCompletePageCloseFailure() {
        Test.setCurrentPageReference(new PageReference('Page.KUKA_communitiesCompletePage')); 
        System.currentPageReference().getParameters().put('source', 'Connect');
        CommunityCompleteController controller = new CommunityCompleteController();
        PageReference page=  controller.closePage(); 
         System.assertNotEquals( page, null);
       
    }
    
      static testMethod void testCompletePageClose() {
        Test.setCurrentPageReference(new PageReference('Page.KUKA_communitiesCompletePage')); 
        System.currentPageReference().getParameters().put('source', 'Connect');
        RedirectURLConfig__c ZInstance1 = new RedirectURLConfig__c( targetURL__c = 'https://kuka.connect.com',Name='CONNECT');
        insert ZInstance1;
        CommunityCompleteController controller = new CommunityCompleteController();
        PageReference page=  controller.closePage(); 
         System.assertNotEquals( page, null);
       
    }
    
    
}