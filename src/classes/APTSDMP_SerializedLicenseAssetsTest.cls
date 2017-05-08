/*
 * @Description : Test class for APTSDMP_SerializedLicenseAssets apex class
 *
 *  -----------------------------------------------------------------------------
 *  Developer           Date        Description
 *  -----------------------------------------------------------------------------
 *  Arokia Joseph      2017-05-4   Initial Version  
 */
@isTest(seeAllData=true)
public class APTSDMP_SerializedLicenseAssetsTest {
	//SELECT Id,APTSDMP_Billing_Account__c,APTSDMP_Billing_Account__r.Name,APTSDMP_Controller_Asset__c,
	//APTSDMP_Expiration_Date__c,APTSDMP_Integration_Message__c,APTSDMP_Integration_Status__c,
	//APTSDMP_License_Product__c,APTSDMP_License_Product__r.Name,APTSDMP_Robot_Asset__c,APTSDMP_Status__c,
	//APTSDMP_Activation_Date__c,APTSDMP_Product_Name__c,APTSDMP_Account_Name__c FROM APTSDMP_Serialized_License_Asset__c 
	//WHERE APTSDMP_Billing_Account__c =: AcctId AND APTSDMP_Status__c=:'Active'
	
    private static Account objAccount;
    private static APTSDMP_Serialized_License_Asset__c objSerializedLicenseAsset;
    private static Product2 objLicenseProduct;
   
   // private static APTSDMP_Robot_Asset__c objRobotAsset;
    
    
    

}