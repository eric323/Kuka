@isTest(SeeAllData=false)
public class APTSMD_categoriesUtilsTest {
    static testMethod void testGetCatForPriceList(){
        //INIT//START
        Product2 testProduct = APTSMD_testUtils.getproduct();
        Apttus_Config2__PriceList__c testPriceList = APTSMD_testUtils.getPriceList();
        Account testAccount = APTSMD_testUtils.getAccount();
        Contact testContact = APTSMD_testUtils.getContact(testAccount);
        testContact.FirstName = 'Guest';
        testContact.LastName = 'User';
        update testContact;
        User testUser = APTSMD_testUtils.getUser();
        Apttus_Config2__ClassificationName__c testCategory = APTSMD_testUtils.getCategory();
        
        APTSMD_CategoryWrapperClass testCat = new APTSMD_CategoryWrapperClass();
        testCat.expandsubcategory = false;
        
        String PLId = string.valueOf(testPriceList.id);
        
        //TEST// getCategoriesForPriceList
        List<APTSMD_CategoryWrapperClass> testListWrapper = APTSMD_categoriesUtils.getCategoriesForPriceList(PLId);
        
        //ASSERT//
        System.assertNotEquals(null, testListWrapper);
        
        //TEST// getSubCategoriesbySoql
        List<APTSMD_CategoryWrapperClass> testCatWrapper = APTSMD_categoriesUtils.getSubCategoriesbySoql(testCategory.id);
        
        //ASSERT//
        System.assertNotEquals(null, testCatWrapper);
        
        //TEST// getCagtegoriesbySOql, no param
        List<APTSMD_CategoryWrapperClass>  testGetCategoriesbySoql = APTSMD_categoriesUtils.getCategoriesbySoql();
        
        //ASSERT//
        System.assertNotEquals(null, testGetCategoriesbySoql);
    }
    
    static testMethod void testGetCategories(){
        //START INIT
        //test user
         User testUser = APTSMD_testUtils.getUser();
        
        //test price list 
        Apttus_Config2__PriceList__c testPriceList = APTSMD_testUtils.getPriceList();
        //price list parent
        Apttus_Config2__PriceList__c testPriceListParent = APTSMD_testUtils.getPriceList();
        String PLId = string.valueOf(testPriceListParent.id);
        testPriceList.Apttus_Config2__BasedOnPriceListId__c = testPriceListParent.id;
        update testPriceList;
        
        //test account
        Account testAccount = APTSMD_testUtils.getAccount();
        
        //test contact
       	Contact testContact = APTSMD_testUtils.getContact(testAccount);
        testContact.FirstName = 'Guest';
        testContact.LastName = 'User';
        update testContact;
       
		//test Price List Category
        Apttus_Config2__PriceListCategory__c priceListCat = new Apttus_Config2__PriceListCategory__c();
        priceListCat.Apttus_Config2__PriceListId__c = testPriceListParent.Id;
        insert priceListcat;
        //END// INIT

        //TEST// Method getCateogries
        Apttus_CPQApi.CPQ.CategorySearchResultDO testresult = APTSMD_categoriesUtils.getCategories(testPriceListParent, PLId);
        System.debug('testResult Categories ' + testResult.Categories);
        
        //ASSERT//
        System.assertNotEquals(null, testresult);
       
        //TEST// prepareWrapper
        List<APTSMD_CategoryWrapperClass> testCatWrap =  APTSMD_categoriesUtils.prepareWrapper(testresult);
    }
    
    static testMethod void testGetCategoriesNullPLI(){
        //START// INIT
        Apttus_Config2__PriceList__c testPriceList = APTSMD_testUtils.getPriceList();
        Apttus_Config2__PriceList__c testPriceListParent = APTSMD_testUtils.getPriceList();
        String PLId = string.valueOf(testPriceListParent.id);
        Account testAccount = APTSMD_testUtils.getAccount();
        
        User testUser = APTSMD_testUtils.getPortalUser(APTSMD_testUtils.PortalType.PowerPartner, null, true);
		
        Apttus_Config2__PriceListCategory__c priceListCat = new Apttus_Config2__PriceListCategory__c();
        priceListCat.Apttus_Config2__PriceListId__c = testPriceListParent.Id;
        insert priceListcat;
        
   		testPriceList.Apttus_Config2__BasedOnPriceListId__c = testPriceListParent.id;
        update testPriceList;
        
        Apttus_Config2__PriceList__c categoryDisctrict = APTSMD_testUtils.getPriceList();
        categoryDisctrict.APTSMD_District__c = testAccount.APTSMD_Dealer_del__c;
		upsert categoryDisctrict;		
        //END//INIT
        
        //TEST// getCategories with null PLI
        System.runAs(testUser){
            Apttus_CPQApi.CPQ.CategorySearchResultDO testresult2 = APTSMD_categoriesUtils.getCategories(testPriceListParent, null);
        }
    }
    
    static testMethod void testSubCategoryExtract(){
        Apttus_Config2__ClassificationName__c className = new Apttus_Config2__ClassificationName__c();
        className.Apttus_Config2__HierarchyLabel__c = 'testLabel';
        insert className;
        
        Apttus_Config2__PriceList__c testPriceList = APTSMD_testUtils.getPriceList();
        
        Apttus_Config2__PriceListCategory__c priceListCat = new Apttus_Config2__PriceListCategory__c();
        priceListCat.Apttus_Config2__PriceListId__c = testPriceList.Id;
        priceListCat.Apttus_Config2__HierarchyId__c = className.id;
        priceListCat.Apttus_Config2__Sequence__c = 1;
        insert priceListcat;

        
        Apttus_CPQApi.CPQ.CategorySearchResultDO categroryResult = Apttus_CPQApi.CPQWebService.getCategoriesForPriceList(testPriceList.id);
        
        System.debug('CAT RES' + categroryResult);
    }
}