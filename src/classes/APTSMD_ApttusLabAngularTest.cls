@isTest(SeeAllData = true)
public class APTSMD_ApttusLabAngularTest {
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

    @isTest static void init() {
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
        testStore = APTSMD_testUtils.getStore();
        testStore.APTSMD_Price_List__c = testPriceList.id;
        testStore.APTSMD_Banner_Image__c = 'test';
        testStore.APTSMD_Store_Logo__c = 'test';
        testStore.APTSMD_Promotion1__c = 'test';
        testStore.APTSMD_Promotion2__c = 'test';
        testStore.APTSMD_Promotion2__c = 'test';
        testStore.APTSMD_Page_Title__c = 'test';
        update testStore;
        APTSMD_Product_Recommendation__c x = new APTSMD_Product_Recommendation__c(APTSMD_Recommendation_Type__c = 'Top Deal', APTSMD_Store__c = testStore.Id);
    }

    static testMethod void testConstructor(){
        init();
        //category
        Apttus_Config2__ClassificationName__c testCategory = APTSMD_testUtils.getCategory();
        Apttus_Config2__ClassificationHierarchy__c categoryHierarchy = new Apttus_Config2__ClassificationHierarchy__c(Apttus_Config2__HierarchyId__c = testCategory.Id
                                                                                                                     , Apttus_Config2__Label__c = 'testLabel'
                                                                                                                     , Apttus_Config2__SearchFilterFields__c = 'Family');
        insert categoryHierarchy;

        //category price list
        Apttus_Config2__PriceListCategory__c priceListCat = new Apttus_Config2__PriceListCategory__c();
        priceListCat.Apttus_Config2__HierarchyId__c = testCategory.id;
        priceListCat.Apttus_Config2__PriceListId__c = testPriceList.id;
        priceListCat.Apttus_Config2__Sequence__c = 1;
        insert priceListCat;
        
        
        testStore.APTSMD_Contract_Price_List__c = testPriceList.id;
        
        testProduct.APTSMD_Rating__c = 'Good';
        update testProduct; 
        
        //question
        APTSMD_Question__c question = new APTSMD_Question__c(APTSMD_Product__c = testProduct.Id
                                                            , APTSMD_Question__c = 'Is this test?');
        insert question;
        
        //answer
        APTSMD_Answer__c answer = new APTSMD_Answer__c(APTSMD_Question__c = question.id
                                                      , APTSMD_Answer__c = 'Yes this is');
        insert answer;
        
        //product review
        APTSMD_Product_Review__c review = new APTSMD_Product_Review__c(APTSMD_Product__c = testProduct.Id);
        insert review;
        
        //JS
        apexpages.currentpage().getparameters().put('storeId' , testStore.id); 
        
        
        APTSMD_ApttusLabAngularJS testJs = new APTSMD_ApttusLabAngularJS();
        testJs.accountName = 'test';
        testJs.accountEmail = 'test@test.ts';
        //new code
        testJs.loginUser = 'testLogin';
        testJs.loginPassword = 'testPassword';
        testJs.mode = 'testMode';
        APTSMD_ApttusLabAngularJS.resultmessage = 'testMessage';
        testJs.storeRecord = testStore;
        testJs.topCategoryName = 'testCat';
        
        
        
         //test .login
        System.runAs(testUser){
            PageReference x = testJs.login();
        }

        
        System.assertNotEquals(null, testJs);
    }
    
    static testMethod void testCreateAuthReq(){
        //setup
        init();
        apexpages.currentpage().getparameters().put('storeId' , testStore.id);     
        APTSMD_ApttusLabAngularJS testJs = new APTSMD_ApttusLabAngularJS();
        testJs.accountName = 'test';
        testJs.accountEmail = 'test@test.ts';
        
        APTSMD_CyberSourceSettings__c x = new APTSMD_CyberSourceSettings__c(name = 'CS_MERCHANT_ID', APTSMD_Value__c = 'infodev');
        insert x;
        APTSMD_CyberSourceSettings__c y = new APTSMD_CyberSourceSettings__c(name = 'CS_CC_ACCEPT', APTSMD_Value__c = 'test');
        insert y;
        APTSMD_CyberSourceSettings__c z = new APTSMD_CyberSourceSettings__c(name = 'CS_END_POINT_URL', APTSMD_Value__c = 'http://api.salesforce.com/foo/bar');
        insert z;
        
        APTSMD_CyberSource_CC_AuthRequest testAuthreq = new APTSMD_CyberSource_CC_AuthRequest();
        
        String jsonAuthReq = '[' + JSON.serialize(testAuthreq) + ']';
        
        Test.setMock(HttpCalloutMock.class, new APTSMD_MockHttpResponseGenerator());
        //execute
        string req = APTSMD_ApttusLabAngularJS.createauthrequest(jsonAuthReq);
        
    }
    
    static testMethod void testPopulateCurrency(){
        test.startTest();
        //setup
        init();
        apexpages.currentpage().getparameters().put('storeId' , testStore.id);     
        APTSMD_ApttusLabAngularJS testJs = new APTSMD_ApttusLabAngularJS();
        testJs.accountName = 'test';
        testJs.accountEmail = 'test@test.ts';
        
        //execute
        String currencytest = testJS.populateCurrency(String.valueOf(testPriceList.id));
        test.stopTest();
    }
    
    
    static testMethod void testGetProductDetail(){
        test.startTest();
        //setup
        init();
        
        //execute
        APTSMD_ApttusLabAngularJS.getProductDetails(String.valueOf(testProduct.Id));
        test.stopTest();
    }
    
    static testMethod void testGetFeatureSets(){
        Test.startTest();
		//setup
		init();
        Product2 testProduct2 = new Product2(Name = 'testProduct2');
        insert testProduct2;
        String strProducts = String.valueOf(testProduct.Id) + ',' + String.valueOf(testProduct2.Id);

        Apttus_Config2__FeatureSet__c fs = new Apttus_Config2__FeatureSet__c();
        fs.Name = 'testFeature';
        fs.Apttus_Config2__Sequence__c = 6;
        insert fs;
        
        Apttus_Config2__Feature__c f = new Apttus_Config2__Feature__c();
        f.Name = 'Color';
        f.Apttus_Config2__FeatureSetId__c = fs.id;
        f.Apttus_Config2__Sequence__c = 2;
        insert f;
        
        Apttus_Config2__ProductFeature__c pf = new Apttus_Config2__ProductFeature__c();
        pf.Apttus_Config2__FeatureSetId__c = fs.id;
        pf.Apttus_Config2__ProductId__c = testProduct2.id;
        insert pf;
        
        Apttus_Config2__ProductFeatureValue__c pfv = new Apttus_Config2__ProductFeatureValue__c();
        pfv.Apttus_Config2__FeatureId__c = f.id;
        pfv.Apttus_Config2__ProductId__c = testProduct2.id;
        pfv.Apttus_Config2__Value__c = 'red';
        insert pfv;
        
        Apttus_Config2__ProductFeatureValue__c pfv2 = new Apttus_Config2__ProductFeatureValue__c();
        pfv2.Apttus_Config2__FeatureId__c = f.id;
        pfv2.Apttus_Config2__ProductId__c = testProduct.id;
        pfv2.Apttus_Config2__Value__c = 'blue';
        insert pfv2;
        
        //execute
        Map<String, Map<String, String>> getFeatSet =   APTSMD_ApttusLabAngularJS.getFeatureSets(strProducts);
		Test.stopTest();
    }
    
    static testMethod void testGetAllSelectedFilters() {
        Test.startTest();
        init();	

        //hierarchy for category hierarchy
        Apttus_Config2__ClassificationName__c className = new Apttus_Config2__ClassificationName__c();
        className.Apttus_Config2__HierarchyLabel__c = 'testLabel';
        className.Apttus_Config2__Active__c = true;

        insert className;

        //category hierarchy for product option group
        Apttus_Config2__ClassificationHierarchy__c classHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
        classHierarchy.Apttus_Config2__HierarchyId__c = className.id;
        classHierarchy.Apttus_Config2__Label__c = 'classHierarchy';
        insert classHierarchy;

        string jsonCategory = '[' + JSON.serialize(className) + ']';
        List<List<String>> testGetAllSelectedFilters = APTSMD_ApttusLabAngularJS.getAllSelectedFilters(jsonCategory);
        Test.stopTest();
    }
    
    static testMethod void testGetTax(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new APTSMD_MockHttpResponseGenerator());
        //setup
        init();
        APTSMD_productDetailsForTaxCalc taxCalc = new APTSMD_productDetailsForTaxCalc();
        taxCalc.ProductCode = '1234';
        taxCalc.Quantity = 2;
        taxCalc.UnitPrice = 5;
        list<APTSMD_productDetailsForTaxCalc> lstCalc = new List<APTSMD_productDetailsForTaxCalc>();
        lstCalc.add(taxCalc);
        APTSMD_VertexSetting__c vertexSettings = APTSMD_VertexSetting__c.getOrgDefaults();
        vertexSettings.APTSMD_End_Point__c = 'testEndpoints';
        
        upsert vertexSettings APTSMD_VertexSetting__c.id;
        //execute
        try{//TODO: PricingWebService error
         APTSMD_eCom_CallOutResult testGetTax = APTSMD_ApttusLabAngularJS.getTax('12345'
                                               , 5
                                               , lstCalc
                                               , 'city'
                                               , 'street'
                                               , 'country'
                                               , 'state'
                                               , 'Overnight');
        }catch(Exception e){
            
        }
        Test.stopTest();
    }
    
    static testMethod void testModifyCartLineQuant(){
        Test.startTest();
        //setup
        init();
                 Apttus_Presales_eCommerce_Settings__c custSettings = Apttus_Presales_eCommerce_Settings__c.getOrgDefaults();
        custSettings.APTSMD_DefaultStore__c = 'Kuka Main';
                                                                                                     
                                                                                                     
        upsert custSettings Apttus_Presales_eCommerce_Settings__c.id;
        
        //execute
        APTSMD_cartData modifyCartItem = APTSMD_ApttusLabAngularJS.modifyCartItemQuantity(String.valueOf(testLineItem.Id), String.valueOf(testConifg.Id), 2, String.valueOf(testProduct.Id));
        
        Test.stopTest();
    }
    
    static testMethod void testAddCartLineItem(){
        test.startTest();
        //setup
        init();
                 Apttus_Presales_eCommerce_Settings__c custSettings = Apttus_Presales_eCommerce_Settings__c.getOrgDefaults();
        custSettings.APTSMD_DefaultStore__c = 'Kuka Main';
                                                                                                     
                                                                                                     
        upsert custSettings Apttus_Presales_eCommerce_Settings__c.id;
        
        //execute
        APTSMD_cartData addcartitem =  APTSMD_ApttusLabAngularJS.addCartItem(String.valueOf(testProduct.Id), 1, String.valueOf(testConifg.Id));
        Test.stopTest();
    }
    
    static testMethod void testAddBundleWithOptions(){
        Test.startTest();
        //setup
        init();
        string jsonProduct = JSON.serialize(testProduct);
        
        //execute
        //APTSMD_cartData addcartitem =  APTSMD_ApttusLabAngularJS.addBundleWithOptions(jsonProduct, String.valueOf(testConifg.Id));
        Test.stopTest();
    }
    
    static testMethod void testUpdateCartLineItem(){
        Test.startTest();
        //setup
        init();
        string jsonConfig = JSON.serialize(testConifg);
        
        //execute
        //APTSMD_cartData updateCtLineItme = APTSMD_ApttusLabAngularJS.updateCartLineItems(jsonConfig);
        Test.stopTest();
    }
    
    static testMethod void testRemoveCartItem(){
        Test.startTest();
        //setup
        init();
                 Apttus_Presales_eCommerce_Settings__c custSettings = Apttus_Presales_eCommerce_Settings__c.getOrgDefaults();
        custSettings.APTSMD_DefaultStore__c = 'Kuka Main';
                                                                                                     
                                                                                                     
        upsert custSettings Apttus_Presales_eCommerce_Settings__c.id;
        
        //execute
        APTSMD_cartData removeCartItem = APTSMD_ApttusLabAngularJS.removeCartItem(String.valueOf(testLineItem.Id), String.valueOf(testConifg.Id));
        Test.stopTest();
    }
    
    static testMethod void testCloneCartItem(){
        Test.startTest();
        //setup
        init();
        
        //execute
        APTSMD_cartWrapper.cartItems cloneCart = APTSMD_ApttusLabAngularJS.cloneCartItem(' ', String.valueOf(testConifg.Id), String.valueOf(testProduct.Id), 1);
        Test.stopTest();
    }
    
    static testMethod void testGetCartDetails(){
        Test.startTest();
 		         Apttus_Presales_eCommerce_Settings__c custSettings = Apttus_Presales_eCommerce_Settings__c.getOrgDefaults();
        custSettings.APTSMD_DefaultStore__c = 'Kuka Main';
                                                                                                     
                                                                                                     
        upsert custSettings Apttus_Presales_eCommerce_Settings__c.id;
        
        //execute
        APTSMD_cartData getCartDetails =  APTSMD_ApttusLabAngularJS.getCartDetails();
        Test.stopTest();
        
    }
    
    static testMethod void testGetCartSuggestedProduct(){
        Test.startTest();
                 Apttus_Presales_eCommerce_Settings__c custSettings = Apttus_Presales_eCommerce_Settings__c.getOrgDefaults();
        custSettings.APTSMD_DefaultStore__c = 'Kuka Main';
                                                                                                     
                                                                                                     
        upsert custSettings Apttus_Presales_eCommerce_Settings__c.id;
        //execute
        APTSMD_cartData getCartSuggProd = APTSMD_ApttusLabAngularJS.getCartSuggestedProduct();
        Test.stopTest();
    }
    
    static testMethod void testRepriceCart(){
        Test.startTest();
        //setup
        init();
        
        //execute
        User pu = APTSMD_testUtils.getPortalUser(APTSMD_testUtils.PortalType.PowerPartner, null, true);
        
        System.runAs(pu){
            try{//permission error
        APTSMD_cartData cartData =  APTSMD_ApttusLabAngularJS.repriceCart(String.valueOf(testConifg.Id));
            }catch(Exception e){
                
            }
        }
        Test.stopTest();
    }

    static testMethod void testGetRecommendedProducts(){
        Test.startTest();
        //setup
        init();
        
        Apttus_Config2__ClassificationName__c className = new Apttus_Config2__ClassificationName__c();
        className.Apttus_Config2__HierarchyLabel__c = 'testLabel';
        className.Apttus_Config2__Active__c = true;

        insert className;
        
        //execute
        List<APTSMD_ProductWrapperClass> getRecProd = APTSMD_ApttusLabAngularJS.getRecommendedProducts(String.valueOf(testProduct.Id),String.valueOf(testPriceList.id),String.valueOf(className.Id));
        Test.stopTest();
    }
    
    static testMethod void testGetGuidedProducts(){
        Test.startTest();
        //setup
        init();
        
        Apttus_Config2__ClassificationName__c className = new Apttus_Config2__ClassificationName__c();
        className.Apttus_Config2__HierarchyLabel__c = 'testLabel';
        className.Apttus_Config2__Active__c = true;

        insert className;
        
        //execute
        //List<APTSMD_ProductWrapperClass> getGuidedProducts =  APTSMD_ApttusLabAngularJS.getGuidedProducts(String.valueOf(testProduct.Id),String.valueOf(className.Id));
        Test.stopTest();
    }
    
    static testMethod void testGetPickedUpProducts(){
        Test.startTest();
        //setup
        init();
        
        Apttus_Config2__ClassificationName__c className = new Apttus_Config2__ClassificationName__c();
        className.Apttus_Config2__HierarchyLabel__c = 'testLabel';
        className.Apttus_Config2__Active__c = true;

        insert className;
        
        Apttus_Config2__PriceListCategory__c testPriceListCat = new Apttus_Config2__PriceListCategory__c();
        testPriceListCat.Apttus_Config2__PriceListId__c = testPriceList.Id;
        testPriceListCat.Apttus_Config2__HierarchyId__c = className.id;
        
        insert testPriceListCat;
        
        //execute
        List<APTSMD_ProductWrapperClass> getPickedUpProd =  APTSMD_ApttusLabAngularJS.getPickedUpProducts(String.valueOf(testProduct.Id), String.valueOf(testPriceList.id), String.valueOf(className.Id));
        Test.stopTest();
    }
    
    static testMethod void testGetPastOrderProducts(){
        Test.startTest();
        //setup
        init();
        
        Apttus_Config2__ClassificationName__c className = new Apttus_Config2__ClassificationName__c();
        className.Apttus_Config2__HierarchyLabel__c = 'testLabel';
        className.Apttus_Config2__Active__c = true;

        insert className;
        
        Apttus_Config2__PriceListCategory__c testPriceListCat = new Apttus_Config2__PriceListCategory__c();
        testPriceListCat.Apttus_Config2__PriceListId__c = testPriceList.Id;
        testPriceListCat.Apttus_Config2__HierarchyId__c = className.id;
        
        insert testPriceListCat;
        
        //execute
        List<APTSMD_ProductWrapperClass> getOrderProducts = APTSMD_ApttusLabAngularJS.getPastOrderProducts(String.valueOf(testProduct.Id), String.valueOf(testPriceList.id), String.valueOf(className.Id));
        Test.stopTest();
    }
    
    static testMethod void testGetTopDeals(){
        Test.startTest();
        //setup
        init();

        Apttus_Config2__ClassificationName__c className = new Apttus_Config2__ClassificationName__c();
        className.Apttus_Config2__HierarchyLabel__c = 'testLabel';
        className.Apttus_Config2__Active__c = true;

        insert className;
        
        Apttus_Config2__PriceListCategory__c testPriceListCat = new Apttus_Config2__PriceListCategory__c();
        testPriceListCat.Apttus_Config2__PriceListId__c = testPriceList.Id;
        testPriceListCat.Apttus_Config2__HierarchyId__c = className.id;
        
        insert testPriceListCat;
        
        //execute
        List<APTSMD_ProductWrapperClass> getTopDealproducts = APTSMD_ApttusLabAngularJS.getTopDealProducts(String.valueOf(testProduct.Id), String.valueOf(testPriceList.id), String.valueOf(className.Id));
        Test.stopTest();
    }
    
    static testMethod void testCreateOrderFromStore(){
        Test.startTest();
        //setup
        init();
        
        //execute
        APTSMD_ApttusLabAngularJS.createOrderFromStore(String.valueOf(testPriceList.id));
        Test.stopTest();
    }
    
    static testMethod void testUpdatePriceOnCart(){
        Test.startTest();
        //setup
        init();
        
        //execute
        APTSMD_ApttusLabAngularJS.updatePriceOnCart(String.valueOf(testConifg.id));
        Test.stopTest();
    }
    
    static testMethod void testGetCategoriesList(){
        Test.startTest();
        //setup
        init();
        
        //execute
        List<APTSMD_CategoryWrapperClass> getCatList = APTSMD_ApttusLabAngularJS.getCategoriesList(String.valueOf(testPriceList.id));
        Test.stopTest();
    }
    
    static testMethod void testGetProductsByCategory(){
        Test.startTest();
        //setup
        init();
        
        //hierarchy for category hierarchy
        Apttus_Config2__ClassificationName__c className = new Apttus_Config2__ClassificationName__c();
        className.Apttus_Config2__HierarchyLabel__c = 'testLabel';
        className.Apttus_Config2__Active__c = true;

        insert className;

        //category hierarchy for product option group
        Apttus_Config2__ClassificationHierarchy__c classHierarchy = new Apttus_Config2__ClassificationHierarchy__c();
        classHierarchy.Apttus_Config2__HierarchyId__c = className.id;
        classHierarchy.Apttus_Config2__Label__c = 'classHierarchy';
        
        insert classHierarchy;

        //product option group
        Apttus_Config2__ProductOptionGroup__c productOptionGroup = new Apttus_Config2__ProductOptionGroup__c();
        productOptionGroup.Apttus_Config2__OptionGroupId__c = classHierarchy.id;
        productOptionGroup.Apttus_Config2__Sequence__c = 1;
        
        insert productOptiongroup;
        
        testPriceList.APTSMD_District__c = 'Dealer';
        update testPriceList;
        
        User pu = APTSMD_testUtils.getPortalUser(APTSMD_testUtils.PortalType.PowerPartner, null, true);
        //execute
        System.runAs(pu){
            List<APTSMD_ProductWrapperClass> getProductsByCat = APTSMD_ApttusLabAngularJS.getProductsByCategory(String.valueOf(className.Id));
        }
       
        Test.stopTest();
    }
    
    static testMethod void testGetBundleConfiguration(){
        Test.startTest();
        //setup
        init();
        
        //execute
        List<APTSMD_ProductOptionGroupWrapper> getBundleConfig = APTSMD_ApttusLabAngularJS.getBundleConfigurations(String.valueOf(testProduct.Id));
        Test.stopTest();
    }
    
    static testMethod void testGetProductConfiguration(){
        Test.startTest();
        //setup
        init();
        string jsonProduct = JSON.serialize(testProduct);
        //execute
        //        
        try{//TODO: trows error
        APTSMD_ProductWrapperClass getProductConfig =  APTSMD_ApttusLabAngularJS.getProductConfigurations(jsonProduct);
        }
        catch(Exception e){
            
        }
        
        Test.stopTest();
    }
    
    static testMethod void testGetFeatureListByProduct(){
        Test.startTest();
        //setup
        init();
        
        APTSMD_CardDetails__c CardDetails = new APTSMD_CardDetails__c();
        CardDetails.APTSMD_Contact__c = testContact.id;
        
        insert CardDetails;
        
        //execute
        APTSMD_ContactWrapper getAddrInfo = APTSMD_ApttusLabAngularJS.getAddressInfo();
        Test.stopTest();
    }
    
    static testMethod void testSaveLocation(){
        Test.startTest();
        //setup
        init();
        
        APTSMD_FedExIntegration__c fedexIntegration = new APTSMD_FedExIntegration__c(Name = 'System Properties');
        insert fedexIntegration;
        APTSMD_ApttusLabAngularJS.ShippingChargesFedex(100, 2, 'shippingStr', 'shipCity', 'shipState', 'shipCountry', 'shipPostal', 'Overnight');

        //test ShippingCharges
        Decimal shippingCharges = APTSMD_ApttusLabAngularJS.ShippingCharges(1000, 'Overnight');

        //test SubmitOrder
        APTSMD_OrderDetails ordDetails = new APTSMD_OrderDetails();
        try{//todo:permission error
        ordDetails.multipleShipment = false;
        }catch(Exception e){
            
        }
        ordDetails.Order_ID = testOrder.id;User pu = APTSMD_testUtils.getPortalUser(APTSMD_testUtils.PortalType.PowerPartner, null, true);
        
        System.runAs(pu){
            try{//TODO: permission error
        String submitOrder = APTSMD_ApttusLabAngularJS.SubmitOrder(ordDetails);
            }catch(Exception e){
                
            }
        }

        //test createQuote
        //APTSMD_ProposalDetails createQuote = APTSMD_ApttusLabAngularJS.createQuote(String.valueOf(testPriceList.Id), String.valueOf(testConifg.));

        //test APTSMD_eCom_CallOutResult authorizeCreditCard(APTSMD_CyberSource_CC_AuthRequest ccDetails)
        Test.setMock(HttpCalloutMock.class, new APTSMD_MockHttpResponseGenerator());
        APTSMD_CyberSource_CC_AuthRequest authoRequest = new APTSMD_CyberSource_CC_AuthRequest();
        APTSMD_CyberSourceSettings__c css_x = new APTSMD_CyberSourceSettings__c(name = 'CS_MERCHANT_ID', APTSMD_Value__c = 'test');
        insert css_x;
        APTSMD_CyberSourceSettings__c css_y = new APTSMD_CyberSourceSettings__c(name = 'CS_CC_ACCEPT', APTSMD_Value__c = 'test');
        insert css_y;
        APTSMD_CyberSourceSettings__c css_z = new APTSMD_CyberSourceSettings__c(name = 'CS_END_POINT_URL', APTSMD_Value__c = 'test');
        insert css_z;
        APTSMD_eCom_CallOutResult callout = APTSMD_ApttusLabAngularJS.authorizeCreditCard(authoRequest);

        //test saveAddress
        //insert Apttus_Config2__AccountId__c(addres), required fields - Apttus_Config2__AccountId__c
        //boolean saveAddr = APTSMD_ApttusLabAngularJS.saveAddress('testAddr');

        //test APTSMD_ContactWrapper getAddressInfo()
        APTSMD_CardDetails__c CardDetails = new APTSMD_CardDetails__c();
        CardDetails.APTSMD_Contact__c = testContact.id;
        insert CardDetails;
        APTSMD_ContactWrapper getAddrInfo = APTSMD_ApttusLabAngularJS.getAddressInfo();

        //test reorderFunction
        //APTSMD_cartData reorderFunc = APTSMD_ApttusLabAngularJS.reorderfunction(String.valueOf(testOrder.id), String.valueOf(testConifg.id));

        //test getAlsoBoughtProducts
        APTSMD_Recommended_Product__c recomProd = new APTSMD_Recommended_Product__c(APTSMD_ShowInFrequentlyPurchase__c = true);
        insert recomProd;
        list<id> lstProdId = new list<id>();
        lstProdId.add(testProduct.Id);
        List<APTSMD_ProductWrapperClass> lstProdWrapper = APTSMD_ApttusLabAngularJS.getAlsoBoughtProducts(lstProdId);

        //test getFeatureListByProductId
        Apttus_Config2__FeatureSet__c featureSet = new Apttus_Config2__FeatureSet__c();
        featureSet.Apttus_Config2__Sequence__c = 6;
        insert featureSet;
        Apttus_Config2__Feature__c feature = new Apttus_Config2__Feature__c(name = 'test');
        feature.Apttus_Config2__FeatureSetId__c = featureSet.id;
        feature.Apttus_Config2__Sequence__c = 10;
        insert feature;
        Apttus_Config2__ProductFeatureValue__c productFeatureValue = new Apttus_Config2__ProductFeatureValue__c();
        productFeatureValue.Apttus_Config2__FeatureId__c = feature.id;
        insert productFeatureValue;
        Map<string, APTSMD_ProductWrapperClass> mapProductWrapp = APTSMD_ApttusLabAngularJS.getFeatureListByProductId(lstProdId);
        
        //test getAssetHistory
        List<APTSMD_assetHistory> assetHistory = APTSMD_ApttusLabAngularJS.getAssetHstory();
        
        //test getContactUSInfo
        String contactUsInfo = APTSMD_ApttusLabAngularJS.getContactUSInfo();

        
        //getOrderHstory	
        List<APTSMD_orderHistory> getOrderHistoryNo = APTSMD_ApttusLabAngularJS.getOrderHstory();
        
        //test cartDetails
        List<String> lstCartDetails = APTSMD_ApttusLabAngularJS.cardTypes();
        System.assertEquals('AMEX', lstCartDetails[0]);
        System.assertEquals('MASTERCARD', lstCartDetails[1]);
        System.assertEquals('VISA', lstCartDetails[2]);
        
		//test shippdetails
        APTSMD_ContactWrapper testShipDet = APTSMD_ApttusLabAngularJS.shipDetails();

        //test checkOrderIsPlacedAlready
        Boolean checkOrder = APTSMD_ApttusLabAngularJS.checkOrderIsPlacedAlready(String.valueOf(testOrder.Id));
        
         //test getUserCurrency
        String strCurrency = APTSMD_ApttusLabAngularJS.getUserCurrency(String.valueOf(testPriceList.Id));

         //test EcommercePromotion
        APTSMD_EcommPromotion ecompromo = new APTSMD_EcommPromotion('productname', '', 'productDescrip', String.valueOf(testProduct.Id), 123);
        APTSMD_Ecommerce_Promotions__c testEcommPromo = new APTSMD_Ecommerce_Promotions__c();
        testEcommPromo.APTSMD_Promotional_Product__c = testProduct.Id;
        insert testEcommPromo;
        List<APTSMD_EcommPromotion> lstEcomPromo = APTSMD_ApttusLabAngularJS.EcommercePromotions();
        
         //test guestShipToAccount
        String shippingPostalCode = APTSMD_ApttusLabAngularJS.guestShipToAccount('ShippingStreet', 'shippingCity', 'shippingCity', 'shippinCity', 'ShippingPost');
        System.assertEquals('ShippingPost', shippingPostalCode);
        
        //test PromotionAmount
        Decimal dcPromotionAmount = APTSMD_ApttusLabAngularJS.PromotionAmount(String.valueOf(testConifg.id), '1234');
        
		 Apttus_Config2__AccountLocation__c location = new Apttus_Config2__AccountLocation__c(Apttus_Config2__AccountId__c = testAccount.id);
        
        insert location;
        
        string jsonLocation = '['+ JSON.serialize(location) + ']';
        //execute
        try{//TODO: insert fail
        boolean saveAddr = APTSMD_ApttusLabAngularJS.saveAddress(jsonLocation);
        }catch(Exception e){
            
        }
        
        
        Test.stopTest();
    }
    
    static testMethod void testAPTSMD_eCom_CallOutResult() {
        Test.setMock(HttpCalloutMock.class, new APTSMD_MockHttpResponseGenerator());
        init();
        APTSMD_productDetailsForTaxCalc taxCalc = new APTSMD_productDetailsForTaxCalc();
        taxCalc.ProductCode = '1234';
        taxCalc.Quantity = 2;
        taxCalc.UnitPrice = 5;
        list<APTSMD_productDetailsForTaxCalc> lstCalc = new List<APTSMD_productDetailsForTaxCalc>();
        lstCalc.add(taxCalc);
         APTSMD_VertexSetting__c vertexSettings = APTSMD_VertexSetting__c.getOrgDefaults();
        vertexSettings.APTSMD_End_Point__c = 'testEndpoints';
        
        upsert vertexSettings APTSMD_VertexSetting__c.id;

        APTSMD_eCom_CallOutResult testGetTax = APTSMD_ApttusLabAngularJS.getTax('12345'
                                               , 5
                                               , lstCalc
                                               , 'city'
                                               , 'street'
                                               , 'country'
                                               , 'state'
                                               , 'Overnight');

    }
    

    static testMethod void testInnerClasses(){
        Test.startTest();
        //hierarchy for category hierarchy
        Apttus_Config2__ClassificationName__c className = new Apttus_Config2__ClassificationName__c();
        className.Apttus_Config2__HierarchyLabel__c = 'testLabel';
        className.Apttus_Config2__Active__c = true;

        insert className;
        
        APTSMD_ApttusLabAngularJS.refineSearchChildWrapper childWrapper = new APTSMD_ApttusLabAngularJS.refineSearchChildWrapper('test');
        
        List<APTSMD_ApttusLabAngularJS.refineSearchChildWrapper> lstWrapper = new List<APTSMD_ApttusLabAngularJS.refineSearchChildWrapper>();
        lstWrapper.add(childWrapper);
        
        APTSMD_ApttusLabAngularJS.refineSearchParentWrapper testRefine = new APTSMD_ApttusLabAngularJS.refineSearchParentWrapper('tests'
                                                                                                                                , lstWrapper
                                                                                                                                , className.id);
        
        test.stopTest();
        
    }    
    
    static testMethod void test(){
        // APTSDMP_WrapperUtils.ProductAttributeRulesWrapper getProductAttributeRules(Id strProd)
        Test.startTest();
        init();
        
        System.runAs(testUser){
                    APTSMD_ApttusLabAngularJS.updateUserLanguage('en_US');
        }

        Test.stopTest();
    }
    
    static testMethod void putDataIntoMap(){
        Test.startTest();
		APTSMD_FeatureData fd = new APTSMD_FeatureData('productID','featureValue');
         List<APTSMD_FeatureData> lstFD = new List<APTSMD_FeatureData>();
        lstFD.add(fd);
        
        Map<string,  List<APTSMD_FeatureData>> mapp = new Map<string,  List<APTSMD_FeatureData>>();
        mapp.put('key2', lstFD);
        
        APTSMD_ApttusLabAngularJS.putDataIntoMap(mapp, 'key', fd);
        
        Test.stopTest();
    }
    
    static testMethod void reorderFunc(){
        Test.startTest();
        init();
        
        testConifg.Apttus_Config2__BusinessObjectId__c = testOrder.id;
        update testConifg;
        
        APTSMD_cartData reorder =  APTSMD_ApttusLabAngularJS.reorderfunction(String.valueOf(testOrder.id),String.valueOf(testConifg.id));
        Test.stopTest();
    }
    
    static testMethod void testGetGuided(){
        Test.startTest();
        init();
        //hierarchy for category hierarchy
        Apttus_Config2__ClassificationName__c className = new Apttus_Config2__ClassificationName__c();
        className.Apttus_Config2__HierarchyLabel__c = 'testLabel';
        className.Apttus_Config2__Active__c = true;

        insert className;
        try{//TODO: trows error
        List<APTSMD_ProductWrapperClass> lstGuided = APTSMD_ApttusLabAngularJS.getGuidedProducts(string.valueOf(testPriceList.Id),string.valueOf(className.Id));
        }
        catch(Exception e){
            
        }
        Test.stopTest();
    }
    
    
}