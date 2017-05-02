@isTest
public class APTSMD_CyberSourceUtilTest {
    @isTest static void init(){
        APTSMD_CyberSourceSettings__c x = new APTSMD_CyberSourceSettings__c(name = 'CS_MERCHANT_ID', APTSMD_Value__c = 'infodev');
        insert x;
        APTSMD_CyberSourceSettings__c y = new APTSMD_CyberSourceSettings__c(name = 'CS_CC_ACCEPT', APTSMD_Value__c = 'test');
        insert y;
        APTSMD_CyberSourceSettings__c z = new APTSMD_CyberSourceSettings__c(name = 'CS_END_POINT_URL', APTSMD_Value__c = 'http://api.salesforce.com/foo/bar');
        insert z;
    }
    
    static testMethod void testConstructor(){      
        //init
        Test.setMock(HttpCalloutMock.class, new APTSMD_MockHttpResponseGenerator());
        
        HttpResponse res = APTSMD_CalloutClass.getInfoFromExternalService();
        
        init();
        
        //execute
        APTSMD_CyberSourceUtility testCyber = new APTSMD_CyberSourceUtility();
        
        testCyber.parseResponse(res);
          
        //assert
        System.assertNotEquals(null, testCyber);
        
        APTSMD_CyberSource_CC_AuthRequest testAuthreq = new APTSMD_CyberSource_CC_AuthRequest();
        
        testCyber.sendCCAuthRequest(testAuthreq, true);
        
    }   
}