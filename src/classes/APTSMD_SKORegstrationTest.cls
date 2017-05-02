@isTest(SeeAllData=true)
public class APTSMD_SKORegstrationTest {
            enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess }
    
    static testMethod void testConstr(){
        APTSMD_SKORatePlansTable skoRatePlanstable = new APTSMD_SKORatePlansTable();
        
        APTSMD_SKORegistration registrationWitHParam = new APTSMD_SKORegistration(skoRatePlanstable);
        
        Test.setCurrentPageReference(new PageReference('Page.APTSMD_SKOBootStrapTemplate'));
        System.currentPageReference().getParameters().put('url', 'testurl');
        Test.setMock(HttpCalloutMock.class, new APTSMD_MockHttpResponseGenerator());
        
        Id p = [select id from profile where name='Partner Community User'].id;
       
        Account ac = new Account(Name='Test Account',ShippingStreet='AndersonMill Road',ShippingCity='Austin',ShippingState='Texas',
                         ShippingCountry='USA',ShippingPostalCode='78650',BillingStreet='AndersonMill Road',BillingCity='Austin',BillingState='Texas',
                        BillingCountry='USA',BillingPostalCode='78650');
        insert ac; 
       
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id, Salutation = 'Mr.');
        insert con;  
                  
        User user = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='USA',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/Los_Angeles', username='testerApex@noemail.com');
       
        insert user;
        Test.startTest();
        system.runAs(user) {
             String communityId = Network.getNetworkId();
            System.debug('### community ID '+communityId);
             //APTSMD_SKOBootStrapTemplateController bootStrapControl = new APTSMD_SKOBootStrapTemplateController();
        }
        APTSMD_SKORegistration registration = new APTSMD_SKORegistration();
       	Test.stopTest();
        
	
    }
    
    static testMethod void PortalUser(){

        
        User pu = APTSMD_testUtils.getPortalUser(APTSMD_testUtils.PortalType.PowerPartner, null, true);
        System.debug('User PU ' + pu);
        
        System.runAs(pu){

            system.debug('community ID ' + [select name, isPortalEnabled
                             from user
                            where id = :UserInfo.getUserId()].isPortalEnabled);
			system.debug('user profile ' + pu.ProfileId);
            system.debug('community ID ' + Network.getNetworkId());
            Test.setCurrentPageReference(new PageReference('Page.APTSMD_SKOBootStrapTemplate'));
            System.currentPageReference().getParameters().put('url', 'testurl');
            //APTSMD_SKOBootStrapTemplateController bootStrapControl = new APTSMD_SKOBootStrapTemplateController();
        }
    }
    
    static testMethod void getContact(){
         APTSMD_SKORatePlansTable skoRatePlanstable = new APTSMD_SKORatePlansTable();
        
        APTSMD_SKORegistration registrationWitHParam = new APTSMD_SKORegistration(skoRatePlanstable);
        
        Account regAcc = registrationWitHParam.acc;
        
        System.assertNotEquals(null, regAcc);
        
		registrationWitHParam.con = APTSMD_testUtils.getContact(regAcc);      	
        
        PageReference submitedPage = registrationWithParam.submit();
        
    }
}