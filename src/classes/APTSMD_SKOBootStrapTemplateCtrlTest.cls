@isTest(SeeAllData=false)
public class APTSMD_SKOBootStrapTemplateCtrlTest {
    
    static testMethod void test(){
          Test.startTest();
        User pu = APTSMD_testUtils.getPortalUser(APTSMD_testUtils.PortalType.PowerPartner, null, true);
        PageReference refPage = Page.APTSMD_SKOBootStrapTemplate;
        
        test.setCurrentPage(refPage);
        //need network
        //APTSMD_SKOBootStrapTemplateController ctrl = new APTSMD_SKOBootStrapTemplateController();
        //
        
        Case cs = new Case();
        insert cs;
        
        string jsonCase = JSON.serialize(cs);
        system.runAs(pu){        
       		 string casse = APTSMD_SKOBootStrapTemplateController.refuseTermsAndAgreementCaseCreation (jsonCase);
            
            string termsCond = APTSMD_SKOBootStrapTemplateController.getTermsAndConditionsBody ('notworking', 'thiscode');
        }
         Test.stopTest();
    }
    
    static testMethod void test2(){
        Test.startTest();
        User pu = APTSMD_testUtils.getPortalUser(APTSMD_testUtils.PortalType.PowerCustomerSuccess, null, true);

        PageReference pr = new PageReference('https://qkdev-kukaprod.cs84.force.com/ecomm');
		
        Test.setCurrentPage(pr);
        ApexPages.currentPage().getHeaders().put('Host', 'qkdev-kukaprod.cs84.force.com/ecomm');
        
        //networkmember memb = [select networkid from NetworkMember where memberid = :pu.id limit 1];


        List<User> existingPortalUsers = [SELECT id, profileId, userRoleId FROM User WHERE UserRoleId <> null AND username = 'zlevov@apttus.com'];      
        System.runAs(pu){
           
            Test.setMock(HttpCalloutMock.class, new APTSMD_MockHttpResponseGenerator());

            System.debug('Page ' + ApexPages.currentPage().getHeaders().get('Host'));

            System.debug('net ' + Network.getNetworkId());
			
            System.debug(APTSMD_Utils.isLoggedIn());
            try{
			APTSMD_SKOBootStrapTemplateController control = new APTSMD_SKOBootStrapTemplateController();
            }
            catch(Exception e){
                
            }
                
                
        }
        
        Test.stopTest();
    }
}