@isTest(SeeAllData=true)
public class APTSMD_GreenTechMaintTest {
    static testMethod void testUpdateCustomSetting(){
       
        //https://kuka--EcommDev.cs82.my.salesforce.com
		Test.startTest();
        //need APTSMD_Site__c
        APTSMD_Site__c site = new APTSMD_Site__c();
        site.Name = 'Ecommerce';
        site.CurrencyIsoCode = 'USD';
        insert site;

		//'TIER1 Hardware and Software'
		APTSMD_Store__C testStore = new APTSMD_Store__C(Name = 'TIER1 Hardware and Software', APTSMD_Site_URL__c = 'kuka--EcommDev.cs82.my.salesforce.com');
        insert testStore;
        
        APTSMD_GreenTechMaintenance.updateCustomSettings();
        APTSMD_GreenTechMaintenance.updatePartnerURL();
        APTSMD_GreenTechMaintenance.updateStoreImageIdFields();
        Test.stopTest();
    }
}