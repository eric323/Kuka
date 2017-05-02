@isTest(SeeAllData=true)
public class APTSMD_OrderUtilsTest {
    public static Product2 testProduct;
    public static Apttus_Config2__PriceList__c testPriceList;
    public static Apttus_Config2__PriceListItem__c testPLI;
    //public static Contact testContact;
    public static Account testAccount;
	public static Opportunity testOpportunity;
    public static Apttus_Config2__Order__c testOrder;
    public static Apttus_Proposal__Proposal__c testProposal;
    public static Apttus_Config2__ProductConfiguration__c testConifg;
    public static Apttus_Config2__LineItem__c testLineItem;
    public static Product2 testProductOption;
    public static Apttus_Config2__AccountLocation__c testLocation;
    public static User testUser;
    public static String strOrdId;
    public static String strCartId;
    public static String strProductId;
    public static String strLineItemId;
    public static String strPriceListId;
    public static String strAccountId;
    
    @isTest static void init()
    {
        testProduct = APTSMD_testUtils.getproduct();
        testPriceList = APTSMD_testUtils.getPriceList();
        testPLI = APTSMD_testUtils.getPriceListItem(testProduct, testPriceList);
        testAccount = APTSMD_testUtils.getAccount();
        //testContact = APTSMD_testUtils.getContact(testAccount);
        //testContact.FirstName = 'Guest';
        //testContact.LastName = 'User';
        //update testContact;
        testOpportunity = APTSMD_testUtils.getOpportunity(testAccount);
        testProposal = APTSMD_testUtils.getProposal(testAccount, testOpportunity, testPriceList);
        testLocation = APTSMD_testUtils.getLocation(testAccount);
        testUser = APTSMD_testUtils.getUser();
		testOrder = APTSMD_testUtils.getOrder(testPriceList, testProposal, testAccount, testOpportunity, testLocation, testUser);
        testConifg = APTSMD_testUtils.getProductConfiguration('test', testPriceList, testProposal, testOrder);
		testLineItem = APTSMD_testUtils.getLineItem(testConifg, testProduct, testPriceList, testPLI);
        testProductOption = APTSMD_testUtils.getproduct();
        
        strOrdId = String.valueOf(testOrder.id);
        strCartId = String.valueOf(testConifg.id);
        strProductId = String.valueOf(testProduct.id);
        strLineItemId = String.valueOf(testLineItem.id);
        strPriceListId = String.valueOf(testPriceList.id);
        strAccountId = String.valueOf(testAccount.id);
    }
    
    static testMethod void testGetOrderHistory()
    {
        init();
       
        APTSMD_OrderUtils orderDetails = new APTSMD_OrderUtils();
        
        APTSMD_OrderDetails orderHistory = APTSMD_OrderUtils.GetOrderHistory(strOrdId, strCartId);
        
        APTSMD_cartWrapper wrapper = APTSMD_cartUtils.getCartDetails(strPriceListId);
        
        APTSMD_ProposalDetails proposalDetails = APTSMD_OrderUtils.createQuote(strPriceListId, wrapper);
        
    }
    
    static testMethod void testSaveOrder()
    {
    	init();
        
        Test.startTest();
        APTSMD_OrderDetails orderHistory = APTSMD_OrderUtils.GetOrderHistory(strOrdId, strCartId);
        orderHistory.multipleShipment = false;
		orderHistory.BillTo_Account_Id = strAccountId;
        orderHistory.ShipTo_Account_Id = strAccountId;
        string saveOrder = APTSMD_OrderUtils.SaveOrderDetails(orderHistory);
        Test.stopTest();
        
        System.assertNotEquals(null, saveOrder);
    }
    
    static testMethod void testCloneOrder()
    {
        init();
        Test.startTest();
        Apttus_Config2__Order__c cloneOrder = APTSMD_OrderUtils.cloneOrder(strOrdId);
        Test.stopTest();
        System.assertNotEquals(null, cloneOrder);
    }
    
    static testMethod void testReorderFunction()
    {
        init();
        Test.startTest();
        testConifg.Apttus_Config2__BusinessObjectId__c = strOrdId;
        update testConifg;
        APTSMD_cartData cartData =  APTSMD_OrderUtils.reorderFunction(strOrdId, strCartId);
        Test.stopTest();
        
        System.assertNotEquals(null, cartData);
    }
}