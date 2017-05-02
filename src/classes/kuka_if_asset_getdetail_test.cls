/*
 * @Description : Test class for kuka_if_asset_getdetail apex class
 * -----------------------------------------------------------------------------
 *  Developer           Date        Comments
 * -----------------------------------------------------------------------------
 *  Arokia Joseph     2016-11-23    Initial Version
 *
 */
@isTest(seeAllData=false)
public class kuka_if_asset_getdetail_test {
     private static string strBaseUrl;
     private static Asset assetObj;
     private static Account accountObj;
    private static Contact testContact;
    
     @isTest 
     static void init() {
        
          accountObj = new Account(Name='Test Account',ShippingStreet='AndersonMill Road',ShippingCity='Austin',ShippingState='Texas',
                         ShippingCountry='USA',ShippingPostalCode='78650',BillingStreet='AndersonMill Road',BillingCity='Austin',BillingState='Texas',
                        BillingCountry='USA',BillingPostalCode='78650');                       
          insert accountObj;
         testContact = APTSMD_testUtils.getContact(accountObj);
         
         ChatterGroupID_Mirror__c testChatterGroup = new ChatterGroupID_Mirror__c(ID__c = '123124523');
         insert testChatterGroup;
         
          assetObj = new Asset(Name='Test Record', AccountId = accountObj.Id ,SerialNumber='123456', Quantity=1, ContactId = testContact.id, ChatterGroup__c = testChatterGroup.id);
          insert assetObj;
     
          strBaseUrl= System.URL.getSalesforceBaseUrl().getHost();
    }
    
 
     static testMethod void test_GetAssetFound(){  
         init();
         Test.StartTest();         
         kuka_if_asset_getdetail assetGetDetailObj = new kuka_if_asset_getdetail();
      
         String serialNumber = String.valueOf(123456);   
         RestRequest req = new RestRequest();
         RestResponse res = new RestResponse();
         req.requestURI = 'https://+strBaseUrl+/services/apexrest/getassetdetail/'+serialNumber+'';  
         req.httpMethod = 'GET';
         
         
         RestContext.request = req;         
         kuka_if_asset_getdetail.ResponseHandler responseHandlerObj = kuka_if_asset_getdetail.GET();  
         System.assertEquals(responseHandlerObj.Message, 'Success : Found Asset');
  
         Test.stopTest();
      }
    
      static testMethod void test_GetAssetNotFound(){  
         Test.StartTest();
         kuka_if_asset_getdetail assetGetDetailObj = new kuka_if_asset_getdetail();
        
         String serialNumber = String.valueOf(12345);   
         RestRequest req = new RestRequest();
         RestResponse res = new RestResponse();
         req.requestURI = 'https://+strBaseUrl+/services/apexrest/getassetdetail/'+serialNumber+'';  
         req.httpMethod = 'GET';
        
         RestContext.request = req;
         kuka_if_asset_getdetail.ResponseHandler responseHandlerObj = kuka_if_asset_getdetail.GET();
         System.assertEquals(responseHandlerObj.Message, 'Asset Not Found');
         Test.stopTest();
       }
   
    
      
    
}