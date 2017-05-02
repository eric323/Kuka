@isTest
public class APTSMD_FeatureDataTest {
    public static Product2 testProduct;
    public static Apttus_Config2__PriceList__c testPriceList;
    public static Apttus_Config2__PriceListItem__c testPLI;
    public static Contact testContact;
    public static Account testAccount;
	public static Opportunity testOpportunity;
    public static Apttus_Config2__Order__c testOrder;
    public static Apttus_Proposal__Proposal__c testProposal;
    public static Apttus_Config2__ProductConfiguration__c testConifg;
    public static Apttus_Config2__LineItem__c testLineItem;
    public static Product2 testProductOption;
    public static APTSMD_Store__c testStore;
    public static Apttus_Config2__AccountLocation__c testLocation;
    public static User testUser;
    
     @isTest static void init(){
         testProduct = APTSMD_testUtils.getproduct();
         testPriceList = APTSMD_testUtils.getPriceList();
         testPLI = APTSMD_testUtils.getPriceListItem(testProduct, testPriceList);
         testAccount = APTSMD_testUtils.getAccount();
         testContact = APTSMD_testUtils.getContact(testAccount);
         testOpportunity = APTSMD_testUtils.getOpportunity(testAccount);
         testProposal = APTSMD_testUtils.getProposal(testAccount, testOpportunity, testPriceList);
         testLocation = APTSMD_testUtils.getLocation(testAccount);
         testUser = APTSMD_testUtils.getUser();
         testOrder = APTSMD_testUtils.getOrder(testPriceList, testProposal, testAccount, testOpportunity, testLocation, testUser);
         testConifg = APTSMD_testUtils.getProductConfiguration('test', testPriceList, testProposal, testOrder);
         testLineItem = APTSMD_testUtils.getLineItem(testConifg, testProduct, testPriceList, testPLI);
         testLineItem.Apttus_Config2__ProductId__c = testProduct.id;
         update testLineItem;
         testProductOption = APTSMD_testUtils.getproduct();

    }
    
    static testMethod void tesTConstr(){
        init(); 
        
        APTSMD_FeatureData feature = new APTSMD_FeatureData(string.valueOf(testProduct.Id), 'feature');
        
        APTSMD_FeatureData featureToCompare = new APTSMD_FeatureData(string.valueOf(testProduct.Id), 'feature');
        
        integer x = feature.compareTo(featureToCompare);
    }
    
}