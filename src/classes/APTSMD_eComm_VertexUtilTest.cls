@isTest
public class APTSMD_eComm_VertexUtilTest {
    static testMethod void testConstr(){
        APTSMD_eCom_VertexUitlity testUtil = new APTSMD_eCom_VertexUitlity();
    
        System.assertNotEquals(null, testUtil);
    }
    
    static testMethod void testCallout(){
        APTSMD_VertexSetting__c vertexSettings = APTSMD_VertexSetting__c.getOrgDefaults();
        vertexSettings.APTSMD_End_Point__c = 'testEndpoints';
        
        upsert vertexSettings APTSMD_VertexSetting__c.id;
        
        System.Test.setMock(HttpCalloutMock.class, new APTSMD_MockHttpResponseGenerator());
        
        APTSMD_eCom_VertexUitlity testUtil = new APTSMD_eCom_VertexUitlity();

        
        APTSMD_ecom_VertexDetails testVertDetails = new APTSMD_ecom_VertexDetails();
        System.assertNotEquals(null, testVertDetails);
        
        string test = testUtil.doVertexCallout(testVertDetails);
        
        //System.assertNotEquals(null, test);

    }
    
    /*static testMethod void testCallout2(){
        APTSMD_VertexSetting__c vertexCustsett = new APTSMD_VertexSetting__c();
        vertexCustsett.APTSMD_End_Point__c = 'Endpoint.com';
        
        APTSMD_eCom_VertexUitlity testUtil = new APTSMD_eCom_VertexUitlity();
        APTSMD_ecom_VertexDetails testVertDetails = new APTSMD_ecom_VertexDetails();
        
		System.Test.setMock(HttpCalloutMock.class, new APTSMD_MockHttpResponseGenerator());
        
        string test = testUtil.doVertexCallout(testVertDetails);
    }*/
}