@isTest
public class APTSMD_testUtilsTest {
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
    public static Apttus_Config2__LineItem__c testLineItem2;
    public static Product2 testProductOption;
    public static Apttus_Config2__AccountLocation__c testLocation;
    public static User testUser;
    public static String strOrdId;
    public static String strCartId;
    public static String strProductId;
    public static String strLineItemId;
    public static String strPriceListId;
    public static String strAccountId;

    @isTest static void init() {
        testProduct = APTSMD_testUtils.getproduct();
        testPriceList = APTSMD_testUtils.getPriceList();
        testPLI = APTSMD_testUtils.getPriceListItem(testProduct, testPriceList);
        testAccount = APTSMD_testUtils.getAccount();
        testContact = APTSMD_testUtils.getContact(testAccount);
        testContact.FirstName = 'Guest';
        testContact.LastName = 'User';
        update testContact;
        testOpportunity = APTSMD_testUtils.getOpportunity(testAccount);
        testProposal = APTSMD_testUtils.getProposal(testAccount, testOpportunity, testPriceList);
        testLocation = APTSMD_testUtils.getLocation(testAccount);
        testUser = APTSMD_testUtils.getUser();
        testOrder = APTSMD_testUtils.getOrder(testPriceList, testProposal, testAccount, testOpportunity, testLocation, testUser);
        testConifg = APTSMD_testUtils.getProductConfiguration('test', testPriceList, testProposal, testOrder);
        testLineItem = APTSMD_testUtils.getLineItem(testConifg, testProduct, testPriceList, testPLI);
        testLineItem2 = APTSMD_testUtils.getLineItem2(testConifg, testProduct, testPriceList, testPLI);
        testProductOption = APTSMD_testUtils.getproduct();

        strOrdId = String.valueOf(testOrder.id);
        strCartId = String.valueOf(testConifg.id);
        strProductId = String.valueOf(testProduct.id);
        strLineItemId = String.valueOf(testLineItem.id);
        strPriceListId = String.valueOf(testPriceList.id);
        strAccountId = String.valueOf(testAccount.id);
        
         //APTSMD_Store__c stor =  APTSMD_testUtils.getStore();
        APTSMD_testUtils.addPricebookEntries();
        
        Apttus_Config2__ClassificationName__c cat = APTSMD_testUtils.getCategory();

                        User portUs = APTSMD_testUtils.getPortalUser(APTSMD_testUtils.PortalType.PowerPartner, null, true);

    }
    
    static testMethod void testMock(){
        APTSMD_MockHttpResponseGenerator mockGenerator = new APTSMD_MockHttpResponseGenerator();
        
        httpRequest req = new HttpRequest();
        req.setMethod('GET');
        HTTPResponse response = mockGenerator.respond(req);
        
        Test.setMock(HttpCalloutMock.class, new APTSMD_MockHttpResponseGenerator());
    }
    
    static testMethod void testt(){
        Test.startTest();
        APTSDMP_WrapperUtils wrap = new APTSDMP_WrapperUtils();

        init();
        
        APTSDMP_GetLineItems line = new APTSDMP_GetLineItems();
        id oId = APTSDMP_GetLineItems.oId;
        
        List<Apttus_Config2__LineItem__c> lstLineItems =  APTSDMP_GetLineItems.getLineItems();
        test.stopTest();
    }
    
    /*
    static testMethod void test3(){
       kuka_if_asset_getdetail.ResponseHandler respHand = kuka_if_asset_getdetail.GET();
        
        
    }*/
    
    static testMethod void test4(){
        APTSMD_orderHistory ordHistory = new APTSMD_orderHistory();
        
        APTSMD_orderHistory.orderlineitem ordLine = new APTSMD_orderHistory.orderlineitem();
        ordLine.ProdName = 'test';
        ordLine.Quantity = 2;
        ordLine.Netprice = 100;
        ordLine.lineItemPrice = 50;
    }
    
    static testMethod void test5(){
        Product2  testProductWra = APTSMD_testUtils.getproduct();
        
        //Schema.getGlobalDescribe().get('Apttus_Config2__ProductAttributeGroup__c').getDescribe().fields.getMap().get('apttus_config2__businessobject__c').getDescribe().getLabel();
        APTSMD_ProductAttributeWrapper wrap = new APTSMD_ProductAttributeWrapper('apttus_config2__businessobject__c', 'Apttus_Config2__ProductAttributeGroup__c');
        
        List<APTSMD_ProductAttributeWrapper> lstAttrWrap = new list<APTSMD_ProductAttributeWrapper>();
        lstAttrWrap.add(wrap);
        
      	 APTSMD_ProductAttributeGroupWrapper atrGroupWrap = new APTSMD_ProductAttributeGroupWrapper('test', lstAttrWrap);
    }
    
}