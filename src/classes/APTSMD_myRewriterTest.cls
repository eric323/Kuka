@isTest
public class APTSMD_myRewriterTest {
    static testMethod void testConstr(){
        APTSMD_myRewriter test = new APTSMD_myRewriter();
        PageReference pageRef = new PageReference('http://www.google.com');
        list<PageReference> lstPageRef = new list<PageReference>();
        lstPageRef.add(pageRef);
        
        PageReference output = test.mapRequestUrl(pageRef);
        
        list<PageReference> lstOutputPageReference = new list<PageReference>();
        
        lstOutputPageReference = test.generateUrlFor(lstOutputPageReference);
    }
    
    static testMethod void testSKOBoot(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standte', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testtorg.com');
        ApexPages.currentPage().getHeaders().put('https://apttuscommunity-14f1600abf5.force.com', 'test');
        PageReference pageRef = new PageReference('/apex/ActiveParticipant'); 
        System.Test.setCurrentPage(pageRef);
        System.runAs(u){
            //having problems with Network.getNetworkId()
            //APTSMD_SKOBootStrapTemplateController test = new APTSMD_SKOBootStrapTemplateController();
        }
    }
}