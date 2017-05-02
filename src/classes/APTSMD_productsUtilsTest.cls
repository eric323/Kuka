@isTest(SeeAllData=true)
public class APTSMD_productsUtilsTest { 
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
    public static APTSMD_CyberSourceSettings__c css_x;
    public static  APTSMD_CyberSourceSettings__c css_y;
    public static APTSMD_CyberSourceSettings__c css_z;
    public static Apttus_Config2__ClassificationName__c className;
    public static Apttus_Config2__ClassificationHierarchy__c classHierarchy;
    public static  Apttus_Config2__ProductOptionGroup__c productOptionGroup;
    public static Apttus_Config2__ProductAttributeGroup__c testAttributeGroup;
    public static Apttus_Config2__ProductAttributeGroupMember__c testAttributeGroupMember;
    
    public static string strCategoryID;
    public static string strProductID;
    public static string strPriceListID;
    
    public static ID testProductID;
    public static ID testAttributeGroupID;
    public static ID testPriceListID;
    
    @isTest static void init(){
        testProduct = APTSMD_testUtils.getproduct();
        testPriceList = APTSMD_testUtils.getPriceList();
        testPLI = APTSMD_testUtils.getPriceListItem(testProduct, testPriceList);
        testAccount = APTSMD_testUtils.getAccount();
        testContact = APTSMD_testUtils.getContact(testAccount);
        testUser = APTSMD_testUtils.getUser();
        testContact.OwnerId = UserInfo.getUserId();
        update testContact;
        testOpportunity = APTSMD_testUtils.getOpportunity(testAccount);
        testProposal = APTSMD_testUtils.getProposal(testAccount, testOpportunity, testPriceList);
        testLocation = APTSMD_testUtils.getLocation(testAccount);  
        testOrder = APTSMD_testUtils.getOrder(testPriceList, testProposal, testAccount, testOpportunity, testLocation, testUser);
        testConifg = APTSMD_testUtils.getProductConfiguration('test', testPriceList, testProposal, testOrder);
        testLineItem = APTSMD_testUtils.getLineItem(testConifg, testProduct, testPriceList, testPLI);
        testLineItem.Apttus_Config2__ProductId__c = testProduct.id;
        update testLineItem;
        testProductOption = APTSMD_testUtils.getproduct();
        testStore = APTSMD_testUtils.getStore();
        testStore.APTSMD_Price_List__c = testPriceList.id;
        testStore.APTSMD_Banner_Image__c = 'test';
        testStore.APTSMD_Store_Logo__c = 'test';
        testStore.APTSMD_Promotion1__c = 'test';
        testStore.APTSMD_Promotion2__c = 'test';
        testStore.APTSMD_Promotion2__c = 'test';
        testStore.APTSMD_Page_Title__c = 'test';
        update testStore;
        APTSMD_Product_Recommendation__c x = new APTSMD_Product_Recommendation__c(APTSMD_Recommendation_Type__c = 'Top Deal',APTSMD_Store__c = testStore.Id);
        
        //Custom Settings
        css_x = new APTSMD_CyberSourceSettings__c(name = 'CS_MERCHANT_ID', APTSMD_Value__c = 'test');
        insert css_x;
        css_y = new APTSMD_CyberSourceSettings__c(name = 'CS_CC_ACCEPT', APTSMD_Value__c = 'test');
        insert css_y;
        css_z = new APTSMD_CyberSourceSettings__c(name = 'CS_END_POINT_URL', APTSMD_Value__c = 'test');
        insert css_z;
        
        //hierarchy for category hierarchy
        className = new Apttus_Config2__ClassificationName__c();
        className.Apttus_Config2__HierarchyLabel__c = 'testLabel';
        className.Apttus_Config2__Active__c = true;
        
        insert className;
        
        //category hierarchy for product option group
        classHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
        classHierarchy.Apttus_Config2__HierarchyId__c = className.id;
        classHierarchy.Apttus_Config2__Label__c = 'classHierarchy';
        insert classHierarchy;
        
        //product option group
        productOptionGroup = new Apttus_Config2__ProductOptionGroup__c();
        productOptionGroup.Apttus_Config2__OptionGroupId__c = classHierarchy.id;
        productOptionGroup.Apttus_Config2__Sequence__c = 1;
        insert productOptiongroup;
        
        //attribute group
        testAttributeGroup = new Apttus_Config2__ProductAttributeGroup__c();
        insert testAttributeGroup;
        
        //attribute group member
        
        //string IDs
        strCategoryID = string.valueOf(className.Id);
        strProductID = string.valueOf(testProduct.ID);
        strPriceListID = string.valueOf(testPriceList.Id);
        
        //ids
        testProductID = testProduct.id;
        testAttributeGroupID = testAttributeGroup.Id;
        testPriceListID = testPriceList.Id;
    }
    
    //TESTS
    
    static testMethod void testGetProductConfig(){
        Test.startTest();
        init();

 		//Category for Category Hierarchy(Apttus_Config2__HierarchyId__c)
        Apttus_Config2__ClassificationName__c testClassName = new Apttus_Config2__ClassificationName__c();
        testClassName.Apttus_Config2__HierarchyLabel__c = 'testLabel';
        testClassName.Apttus_Config2__Active__c = true;
        
        insert testClassName;
        
        //Category Hierarchy for Product Option group(Apttus_Config2__OptionGroupId__c)
        Apttus_Config2__ClassificationHierarchy__c testClassHierar = new Apttus_Config2__ClassificationHierarchy__c();
        testClassHierar.Apttus_Config2__HierarchyId__c = testClassName.id;
        testClassHierar.Apttus_Config2__Label__c = 'classHierarchy';
        insert testClassHierar;
        
        //Product Option Group for Product Component(Apttus_Config2__ProductOptionGroupId__c)
        Apttus_Config2__ProductOptionGroup__c testOptionGroup = new Apttus_Config2__ProductOptionGroup__c(Apttus_Config2__OptionGroupId__c = testClassHierar.id
                                                                                                          , Apttus_Config2__Sequence__c = 3);
      
        insert testOptionGroup;
        
        //bundle product
        Product2 testBundleProduct = new Product2(Name = 'testBundle', Apttus_Config2__ConfigurationType__c = 'Bundle', Apttus_Config2__HasOptions__c = true);
        
        insert testBundleProduct;
 
        //Option Component (Option) for Bundle
        Apttus_Config2__ProductOptionComponent__c testOption = new Apttus_Config2__ProductOptionComponent__c(Apttus_Config2__Sequence__c = 1                                                                                                  
                                                                                                             , Apttus_Config2__ParentProductId__c = testBundleProduct.id
                                                                                                             , Apttus_Config2__ProductOptionGroupId__c = testOptionGroup.id);
        insert testOption;

        Apttus_Config2__PriceListItem__c testPriceListItem = new Apttus_Config2__PriceListItem__c(Apttus_Config2__Description__c = 'testPriceListItem'
                                                                                                 , Apttus_Config2__PriceListId__c = testPriceList.Id
                                                                                                 , Apttus_Config2__ProductId__c = testBundleProduct.id);
        insert testPriceListItem;
        
        testPriceList.APTSMD_District__c = 'Guest';
        update testPriceList;


        User pu = APTSMD_testUtils.getPortalUser(APTSMD_testUtils.PortalType.PowerPartner, null, true);
        
        testPriceList.APTSMD_District__c = 'Dealer';
        update testPriceList;
        
        System.runAs(pu){
        List<APTSMD_ProductOptionGroupWrapper> testBundle = APTSMD_productsUtils.getBundleConfigurations(String.valueOf(testBundleProduct.id));        
  
        
        APTSMD_ProductWrapperClass prod = new APTSMD_ProductWrapperClass(testBundleProduct.Id);
        prod.hasOptions = true;
       	prod.hasAttributes = true;
        
        APTSMD_ProductWrapperClass prodWrapper =  APTSMD_productsUtils.getProductConfigurations(prod);
        }
        
        system.debug('Before the CPQ');
        Apttus_CPQApi.CPQ.ProductOptionGroupSearchResultDO resultOG = Apttus_CPQApi.CPQWebService.getOptionGroupsForPriceListProduct(String.valueOf(testPriceList.id), String.valueOf(testBundleProduct.id));
        System.debug('result OG   ' + resultOG);
        
        Test.stopTest();
    }
    
    static testMethod void testGetPriceList(){
        init();
		
        User pu = APTSMD_testUtils.getPortalUser(APTSMD_testUtils.PortalType.PowerPartner, null, true);
        
        testPriceList.APTSMD_District__c = 'Dealer';
        update testPriceList;
        
        System.runAs(pu){
        id testId = APTSMD_productsUtils.getPriceListId();
        }
    }
    
    static testMethod void testgetBundleConfig(){
        init();
        
        //PriceListCategory 
        Apttus_Config2__PriceListCategory__c priceListCat = new Apttus_Config2__PriceListCategory__c();
        priceListCat.Apttus_Config2__HierarchyId__c = className.Id;
        priceListCat.Apttus_Config2__PriceListId__c = testPriceListID;
        insert priceListCat;
        
        testProduct.Apttus_Config2__HasOptions__c = true;
        Apttus_Config2__ProductOptionGroup__c prodOptionGroup = new Apttus_Config2__ProductOptionGroup__c(Apttus_Config2__OptionGroupId__c = classHierarchy.Id
                                                                                                         , Apttus_Config2__Sequence__c = 1);
        insert prodOptionGroup;
            	
        Apttus_Config2__ProductOptionComponent__c prodOption = new Apttus_Config2__ProductOptionComponent__c(Apttus_Config2__Sequence__c = 1
                                                                                                            , Apttus_Config2__ParentProductId__c = testProduct.Id
                                                                                                            , Apttus_Config2__ProductOptionGroupId__c = prodOptionGroup.id);
        insert prodOption;
        update testProduct;
        
        
       
     
    }
    
    static testMethod void testGetProductAtt(){
        init();
        testProduct.Apttus_Config2__HasAttributes__c = true;
        update testProduct;
        List<APTSMD_ProductAttributeGroupWrapper> testProdAttrbib = APTSMD_productsUtils.getProductAttributes(testProductID);
    }
    
    
    static testMethod void testGetAttributeGroups()
    {
        init();
        APTSMD_Recommended_Product__c recommProd = new APTSMD_Recommended_Product__c();
        recommProd.APTSMD_ShowInFrequentlyPurchase__c = true;
        recommProd.APTSMD_Product__c = testProduct.id;
        insert recommProd;
        
        List<Apttus_Config2__ProductAttributeGroup__c> getAttributeGroups =  APTSMD_productsUtils.getAttributeGroups(testProductID);
    }
    
    static testMethod void testGetAlsoBought(){
        Test.startTest();
        init();
        
		Apttus_Config2__ProductTranslation__c translation = new Apttus_Config2__ProductTranslation__c();
        translation.Apttus_Config2__Language__c= UserInfo.getLanguage();
        insert translation;
        
        Product2 testProduct2 = new Product2(Name = 'TestTwo');
        testProduct2.APTSMD_Number_of_1_Star__c = 5;
        testProduct2.APTSMD_Number_of_2_Star__c = 6;
        testProduct2.APTSMD_Number_of_3_Star__c = 7;
        testProduct2.APTSMD_Number_of_4_Star__c = 8;
        testProduct2.APTSMD_Number_of_5_Star__c = 9;
        testProduct2.IsActive = true;
        insert testProduct2;
        
        list<id> lstProduID = new list<id>();
        lstProduID.add(testProduct.Id);
        lstProduID.add(testProduct2.Id);
                //recomended prod
        APTSMD_Recommended_Product__c recommendedProd = new APTSMD_Recommended_Product__c();
		recommendedProd.APTSMD_Product__c = testProduct2.Id;
        recommendedProd.APTSMD_Recommended_Product__c = testProduct2.id;
        recommendedProd.APTSMD_ShowInFrequentlyPurchase__c = true; 	
        insert recommendedProd;
        
        system.debug( 'TEST Product' + recommendedProd);
        List<APTSMD_ProductWrapperClass>  getAlsoBought = APTSMD_productsUtils.getAlsoBoughtProducts(lstProduID);
        

        
        //test  getFeatureListByProductId(List<Id> prodId)
        APTSMD_Question__c question = new APTSMD_Question__c(APTSMD_Product__c  = testProduct.Id);
        insert question;
        
        System.runAs(testUser){
            Map<string,APTSMD_ProductWrapperClass> testGetFeatureList = APTSMD_productsUtils.getFeatureListByProductId(lstProduID);
        
        }
         
        Set<id> setProductID = new set<id>();
        setProductID.addAll(lstProduID);
        
        //test  Map<Id,Product2> prepareProductMap(Set<Id> prodIds)
         Map<Id,Product2> testPrepareMap =  APTSMD_productsUtils.prepareProductMap(setProductID);
        Test.stoptest();
    }
     
    static testMethod void testGetGuidedProd(){
        init();
        
        className.Apttus_Config2__Active__c = true;
        className.Name = 'TestCategory';
        update className;
        
        //PriceListCategory 
        Apttus_Config2__PriceListCategory__c priceListCat = new Apttus_Config2__PriceListCategory__c();
        priceListCat.Apttus_Config2__HierarchyId__c = className.Id;
        priceListCat.Apttus_Config2__PriceListId__c = testPriceListID;
        insert priceListCat;
        
        User pu = APTSMD_testUtils.getPortalUser(APTSMD_testUtils.PortalType.PowerPartner, null, true);
        
        System.runAs(pu){
            List<APTSMD_ProductWrapperClass> testGudedProd = APTSMD_productsUtils.getGuidedProducts(strPriceListID, strCategoryID);
            
            //test getTopDealProducts
        	List<APTSMD_ProductWrapperClass> testGetTopDeals =  APTSMD_productsUtils.getTopDealProducts(strProductID, strPriceListID, strCategoryID);
            
            //test getPickedUpproducts
             List<APTSMD_ProductWrapperClass> testGetPickedUpprod = APTSMD_productsUtils.getPickedUpProducts(strProductID, strPriceListID, strCategoryID);
            
            //test getPastOrderProducts
             List<APTSMD_ProductWrapperClass> testGetPastOrderProdycts = APTSMD_productsUtils.getPastOrderProducts(strProductID, strPriceListID, strCategoryID);
            
            //test getContractedPrices
            Map<String,Apttus_Config2__PriceListItem__c> testGetContractedPrices =  APTSMD_productsUtils.getContractedPrices('00023x12', strPriceListID);
            
            //test getRecommendedProducts
            List<APTSMD_ProductWrapperClass> testGetRecommendedProd = APTSMD_productsUtils.getRecommendedProducts(strProductID, strPriceListID, strCategoryID);
            
            //test prepareProductWrapper
            set<id> setProdId = new set<id>();
            setProdId.add(testProduct.id);
             List<APTSMD_ProductWrapperClass> testPrepareProdWrap =  APTSMD_productsUtils.prepareProductWrapper(setProdId, strPriceListID, strCategoryID);
            
            //test getProdOnCategory
            //Apttus_Config2__ProductHierarchyView__c x = new Apttus_Config2__ProductHierarchyView__c();
            //Apttus_Config2__HierarchyId__c(classHierarchy), Apttus_Config2__ChildLevel__c(3), Apttus_Config2__ParentLevel__c(1)]Apttus_Config2__ChildProductId__c
            //insert x;
            Apttus_Config2__ProductHierarchyView__c productHierView = new Apttus_Config2__ProductHierarchyView__c(Apttus_Config2__HierarchyId__c = className.id
                                                                                                                 , Apttus_Config2__ChildLevel__c = 3
                                                                                                                 , Apttus_Config2__ParentLevel__c = 1
                                                                                                                 , Apttus_Config2__ChildProductId__c = testProduct.Id
                                                                                                                 , Apttus_Config2__PriceListId__c = testPriceList.Id);
            insert productHierView;
            testPriceList.APTSMD_District__c = 'Dealer';
            update testPriceList;
            
            List<APTSMD_ProductWrapperClass> testGetProdOnCat = APTSMD_productsUtils.getProductsOnCategories(strPriceListID, strCategoryID, '[Name, IsActive]');
            
            //test getProductsByCat
            List<APTSMD_ProductWrapperClass> testGetProdByCat = APTSMD_productsUtils.getProductsByCategory(strCategoryID);
        }
       
    }

    static testMethod void productClas(){
            
            APTSMD_ProductWrapperClass.customerAlsoBought test = new APTSMD_ProductWrapperClass.customerAlsoBought();
            
            APTSMD_ProductWrapperClass.recommProd recomtest = new APTSMD_ProductWrapperClass.recommProd();
        }
    
    
    
    
    
    
    
    
    
    
     
    
    
    
    
}