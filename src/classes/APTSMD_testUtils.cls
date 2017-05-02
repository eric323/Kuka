public class APTSMD_testUtils {
   public enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess }

    public static User getPortalUser(PortalType portalType, User userWithRole, Boolean doInsert) {
        /* Make sure the running user has a role otherwise an exception
           will be thrown. */
        if(userWithRole == null) {  
            if(UserInfo.getUserRoleId() == null) {
                //UserRole r = new UserRole(name = 'TEST ROLE');
                UserRole r = [select id from UserRole where name = 'CEO'];
                Database.insert(r);
                userWithRole = new User(alias = 'hasrole', email='userwithrole@roletest1.com', userroleid = r.id,
                                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                    localesidkey='en_US', profileid = UserInfo.getProfileId(),
                                    timezonesidkey='America/Los_Angeles', username='userwithrole@testorg.com');
            } else {
                userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
            }
            System.assert(userWithRole.userRoleId != null,
                          'This test requires the target org to have at least one UserRole created. Please create a user role in this organization and try again.');
        }
        Account a;
        Contact c;
        System.runAs(userWithRole) {
             a = new Account(Name='Test Account',ShippingStreet='1400 Fashion Island Blvd.',ShippingCity='San Mateo',ShippingState='California',
                        ShippingCountry='USA',ShippingPostalCode='94404',BillingStreet='1400 Fashion Island Blvd.',BillingCity='San Mateo',BillingState='California',
                        BillingCountry='USA',BillingPostalCode='94404', APTSMD_Dealer_del__c = 'Dealer');
            Database.insert(a);
		  	c = new Contact(AccountId = a.id, lastname = 'lastname',Salutation = 'Mr.');
            Database.insert(c);
        }
        /* Get any profile for the given type.*/
        Profile p = [select id
                      from profile
                     where usertype = :portalType.name()
                     limit 1];  

        String testemail = 'puser000@amamama.com';
        User pu = new User(profileId = '00e58000000ILS7', username = testemail, email = testemail,
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = c.id, CommunityNickname = 'nickname');
       
        if(doInsert) {
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail = true;
             Database.saveresult sr = Database.insert(pu,dlo);
        }
        return pu;
    }

    
    public static User getUser(){
        User newUser = new User();
        newUser.LastName = 'System Administrator';
        newUser.Alias = 'user';
        newUser.Email = 'user@email.bg';
        newUser.Username = 'test_@email.bg';
        newUser.CommunityNickname = 'test_@email.bg';
        newUser.ProfileId = [SELECT id
                             FROM Profile
                            WHERE name= 'System Administrator'].id;
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.LocaleSidKey = 'en_US';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.IsActive = true;
        Profile p = [select id from profile where name='Standard User'];
        newUser.ProfileId = p.id;
        insert newUser;
        System.assertNotEquals(null, newUser);
        return newUser;
    }
    
    public static Account getAccount(){
        Account testAcc= new Account();
        testAcc.AccountNumber = '111';
        testAcc.Name='ABC Corporation';
        testAcc.APTSMD_Pricing_Agreement_Number__c = 'pricing_agreement_number';
        testAcc.APTSMD_Dealer_del__c = 'Dealer';
        //
        //testAcc.Site = 'TestSite';
        testAcc.AccountSource = 'Advertisement';
        //testAcc.AnnualRevenue = 1000;
        testAcc.Description = 'TestDescription';
        testAcc.NumberOfEmployees = 5;
        //testAcc.Industry = 'Banking';
        //testAcc.Rating = 'Hot';
        testAcc.Type = 'Competitor';
		testAcc.APTSMD_CSN__c = 'TestCSN';        
        testAcc.APTSMD_OracleCSNBillTo__c = 'TestCSNBillto';
        testAcc.Apttus_Config2__DefaultCreditMemoTemplate__c = 'TestCreditMemo';
        testAcc.Apttus_Config2__DefaultInvoiceStatementTemplate__c = 'TestInvoice';
        testAcc.Apttus_Config2__DefaultInvoiceTemplate__c = 'testTemplate';
        testAcc.APTSMD_Pricing_Agreement_Number__c = 'pricingAgreementTest';
        testAcc.APTSMD_Saved_Card__c = 'MASTERCARD ending with 4005 --- Diego Francis --- 04/19';
        testAcc.APTSMD_Sub_String__c = 'testSubString';
        testAcc.ShippingCountry = 'USA';
        testAcc.ShippingState = 'California';
        testAcc.ShippingStreet = '1400 Fashion Island Blvd';
        testAcc.ShippingCity = 'San Mateo';
        testAcc.BillingStreet = '1400 Fashion Island Blvd';
		testAcc.BillingPostalCode = '94404';
		testAcc.BillingCity = 'San Mateo';
		testAcc.BillingCountry = 'USA';
        testAcc.ShippingPostalCode='94404';
        
        insert testAcc;
        System.assertNotEquals(null, testAcc); 
        return testAcc;
    }
    
    public static Apttus_Config2__AccountLocation__c getLocation(Account acc){
        Apttus_Config2__AccountLocation__c location = new Apttus_Config2__AccountLocation__c();
        location.Apttus_Config2__AccountId__c = acc.id;
        location.Apttus_Config2__State__c = 'state';
        location.Apttus_Config2__City__c = 'city';
        location.Apttus_Config2__Street__c = 'street';
        location.Apttus_Config2__PostalCode__c = 'postal code';
        //
        location.Apttus_Config2__BillingContactFilterCriteria__c = 'testBilling';
        location.Apttus_Config2__BillingContactFormat__c = 'Filter Criteria';
        location.Apttus_Config2__BillingDayOfMonth__c = '1st of the Month';
        location.Apttus_Config2__City__c = 'testCity';
        location.Apttus_Config2__Country__c = 'testLocation';
        location.Apttus_Config2__County__c = 'testCountry';
        location.Apttus_Config2__CreditMemoEmailTemplate__c = 'testlocation';
        location.Apttus_Config2__DefaultCreditMemoTemplate__c = 'testCreditMemo';
        location.Apttus_Config2__DefaultInvoiceStatementTemplate__c = 'testInvoiceStatement';
        location.Apttus_Config2__DefaultInvoiceTemplate__c = 'testDefaultInvoice';
        location.Apttus_Config2__InvoiceSeparately__c = 'Yes';
        
        
        insert location;
        System.assertNotEquals(null, location);  
        return location;
    }
    
    public static Apttus_Config2__PriceList__c getPriceList(){
        Apttus_Config2__PriceList__c Prlist = new Apttus_Config2__PriceList__c();
        Prlist.Name = 'Test PriceList';
        Prlist.Apttus_Config2__Type__c = 'Standard';
        Prlist.Apttus_Config2__Active__c = true;
        prList.APTSMD_Currency__c = 'USD';
        Prlist.Apttus_Config2__Description__c = 'This is a test price list';
        Prlist.APTSMD_District__c = 'Master';
        insert Prlist;
        system.assertNotEquals(null, Prlist);
        return Prlist;
    }
    
    public static Product2 getproduct(){
        Product2 prod = new Product2();
        prod.Name = 'Test Product';
        prod.ProductCode = 'Test Product';
        prod.Family = 'KUKA Spare Parts';
        prod.IsActive = true;
        prod.Apttus_Config2__ConfigurationType__c = 'Standalone';
        prod.APTSMD_Long_Description__c = 'Long Test Description';
        prod.APTSMD_Number_of_1_Star__c = 1;
        prod.APTSMD_Number_of_2_Star__c = 2;
        prod.APTSMD_Number_of_3_Star__c = 3;
        prod.APTSMD_Number_of_4_Star__c = 4;
        prod.APTSMD_Number_of_5_Star__c = 5;
        prod.APTSDMP_Objective__c = 'testObjective';
        prod.Rating_1_Star__c = 1;
        prod.Rating_2_Star__c = 1;
        prod.Rating_3_Star__c = 1;
        prod.Rating_4_Star__c = 1;
        prod.Rating_5_Star__c = 1;       
        
        insert prod;
        system.assertNotEquals(null,prod);
        return prod;
    }
    
    public static Apttus_Config2__PriceListItem__c getPriceListItem(Product2 Product, Apttus_Config2__PriceList__c PriceList){
        Apttus_Config2__PriceListItem__c PriceListItem = new Apttus_Config2__PriceListItem__c();
		PriceListItem.Apttus_Config2__ProductId__c = Product.Id;
        PriceListItem.Apttus_Config2__PriceListId__c = PriceList.Id;
        PriceListItem.Apttus_Config2__ChargeType__c = 'Training1';
        PriceListItem.Apttus_Config2__ListPrice__c = 1000.00;
        PriceListItem.Apttus_Config2__PriceType__c = 'One Time';
        PriceListItem.Apttus_Config2__BillingFrequency__c = 'One Time';
        PriceListItem.Apttus_Config2__BillingRule__c = 'Bill In Advance';
        PriceListItem.Apttus_Config2__PriceMethod__c = 'Per Unit';
        PriceListItem.Apttus_Config2__PriceUom__c = 'Each';
        insert PriceListItem;
        system.assertNotEquals(null,PriceListItem);
        return PriceListItem;
    }
    
    public static Apttus_Config2__ClassificationName__c getCategory(){
        Apttus_Config2__ClassificationName__c category = new Apttus_Config2__ClassificationName__c();
        category.Name = 'TestCategory';
        category.Apttus_Config2__HierarchyLabel__c = 'TestCategory';
        category.Apttus_Config2__Active__c = true;
        insert category;
        system.assertNotEquals(null,category);
        return category;
    }
    
    public static Contact getContact(Account acc){
        Contact testContact = new Contact();
        testContact.CurrencyIsoCode = 'USD';
        testContact.FirstName = 'Test';//added
        testContact.LastName = 'Test';
        testContact.Salutation = 'Mr.';
        testContact.AccountId = acc.id;
        testContact.Email = 'test@abv.bg'; //added
        insert testContact;
        System.assertNotEquals(null, testContact);  
        return testContact;
    }
   
    public static Opportunity getOpportunity(Account Acc){
        Opportunity testOpp = new Opportunity();
        testOpp.Name='OppRoundTest';
        testOpp.Amount=1000.00;
        testOpp.AccountId=Acc.Id;
        testOpp.StageName='Closed Won';
        testOpp.CloseDate=Date.today();
        testOpp.Type = 'New';
        insert testOpp;
        system.assertNotEquals(null, testOpp);
        return testOpp;
    }
    
    public static Apttus_Config2__Order__c getOrder(Apttus_Config2__PriceList__c oPricelist
                                                    , Apttus_Proposal__Proposal__c oProposal
                                                    , Account oAccount
                                                    , Opportunity oOpportunity
                                                    , Apttus_Config2__AccountLocation__c oLocation
                                                    , User oUser)
    {
        Apttus_Config2__Order__c oOrder = new Apttus_Config2__Order__c();
        oOrder.Apttus_Config2__PriceListId__c = oPricelist.Id;
        oOrder.Apttus_QPConfig__ProposalId__c = oProposal.Id;
        oOrder.Apttus_Config2__BillToAccountId__c = oAccount.Id;
        oOrder.Apttus_Config2__SoldToAccountId__c = oAccount.Id;
        oOrder.Apttus_Config2__ShipToAccountId__c = oAccount.Id;
        oOrder.Apttus_Config2__RelatedOpportunityId__c = oOpportunity.Id;
        oOrder.Apttus_Config2__Type__c = 'New';
        oOrder.Apttus_Config2__Status__c = 'Activated';
        oOrder.Apttus_Config2__OrderDate__c = Date.today();
        oOrder.Apttus_Config2__OrderStartDate__c = Date.today();
        oOrder.Apttus_Config2__OrderEndDate__c = Date.today().addMonths(12);
        oOrder.Apttus_Config2__ActivatedDate__c = Date.today();
        oOrder.Apttus_Config2__ReadyForBillingDate__c = Date.today();
        oOrder.APTSMD_Account_Location__c = oLocation.id;
        oOrder.APTSMD_GuestStreet__c = 'guestStreet';
        oOrder.APTSMD_GuestCity__c = 'guestCity';
        oOrder.APTSMD_GuestState__c = 'guestState';
        oOrder.APTSMD_GuestCountry__c = 'guestCountry';
        oOrder.APTSMD_GuestCode__c = 'guestCode';
        oOrder.OwnerId = oUser.id;
        oOrder.APTSMD_Order_Amount__c = 1000.0;
        oOrder.APTSMD_Shipping_Charges__c = 100;
        oOrder.APTSMD_Shipping_Method__c = 'Ground';
        oOrder.APTSMD_Tax_On_Order_Amount__c = 10;
        oOrder.APTSMD_Ship_To_Name__c = 'Ship_to_name';
		oOrder.Apttus_Config2__ShipToAccountId__c = oAccount.id;
        oOrder.Apttus_Config2__OrderDate__c = Datetime.newInstance(1960, 2, 17);
        oOrder.Apttus_Config2__Status__c = 'New';
        
        insert oOrder;
        system.assertNotEquals(null,oOrder);
        return oOrder;
    }
    
    public static Apttus_Config2__ProductConfiguration__c getProductConfiguration(String Name
                                                                                  , Apttus_Config2__PriceList__c oPricelist
                                                                                  , Apttus_Proposal__Proposal__c oProposal
                                                                                  , Apttus_Config2__Order__c oOrder){
        Apttus_Config2__ProductConfiguration__c ProductConfiguration = new Apttus_Config2__ProductConfiguration__c();
        ProductConfiguration.Name = Name;
        ProductConfiguration.Apttus_Config2__EffectivePriceListId__c = oPricelist.Id;
        ProductConfiguration.Apttus_Config2__PriceListId__c = oPricelist.Id;
        ProductConfiguration.Apttus_QPConfig__Proposald__c = oPricelist.Id;
        ProductConfiguration.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        ProductConfiguration.Apttus_Config2__Status__c = 'Finalized';
        ProductConfiguration.Apttus_Config2__SummaryGroupType__c = 'Category';
        ProductConfiguration.Apttus_Config2__FinalizedDate__c = Date.today();
        ProductConfiguration.Apttus_Config2__OrderId__c = oOrder.id;
		ProductConfiguration.Apttus_QPConfig__Proposald__c = oProposal.id;                                                                                  
                                                                                    
        insert ProductConfiguration;
		System.assertNotEquals(null, ProductConfiguration);                                                                                     
        return ProductConfiguration;
    }

    public static Apttus_Proposal__Proposal__c getproposal(Account Acc,Opportunity Opp,Apttus_Config2__PriceList__c Plist){
        //contact for Contact Role
        Contact contactForRole = new Contact(LastName = 'test', Salutation = 'Mr.');
        insert contactForRole;
        
        AccountContactRole contactRole = new AccountContactRole();
        contactRole.AccountId = acc.id;
        contactRole.isPrimary = true;
        contactRole.ContactId = contactForRole.id;
        insert contactRole;
            
        Apttus_Proposal__Proposal__c quote = new Apttus_Proposal__Proposal__c();
        quote.Apttus_Proposal__Account__c = Acc.Id;
        quote.Apttus_Proposal__Proposal_Name__c = Opp.Name;
        quote.Apttus_Proposal__Opportunity__c = Opp.Id;
        quote.Apttus_QPConfig__PriceListId__c = Plist.Id;
        quote.Apttus_Proposal__ExpectedStartDate__c = Date.today();
        quote.Apttus_Proposal__ExpectedEndDate__c = Date.today().addMonths(12);
        insert quote;
        system.assertNotEquals(null,quote);
        return quote;  
    }
    
    public static Apttus_Config2__LineItem__c getLineItem(Apttus_Config2__ProductConfiguration__c ProdConfig,Product2 product,Apttus_Config2__PriceList__c Pricelist,Apttus_Config2__PriceListItem__c PriceListItem){
        Apttus_Config2__LineItem__c LineItem = new Apttus_Config2__LineItem__c();

        LineItem.Apttus_Config2__Description__c = 'prodname';
        LineItem.Apttus_Config2__BasePrice__c = 100;
        LineItem.Apttus_Config2__ListPrice__c = 100;
        LineItem.Apttus_Config2__NetPrice__c = 100;
        LineItem.Apttus_Config2__LineNumber__c = 1;
        LineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        LineItem.Apttus_Config2__ItemSequence__c = 1;
        LineItem.Apttus_Config2__IsPrimaryLine__c = true;
        LineItem.Apttus_Config2__ChargeType__c = 'Lease';
        LineItem.Apttus_Config2__ConfigurationId__c = ProdConfig.Id;
        LineItem.Apttus_Config2__ProductId__c = product.Id;
        LineItem.Apttus_Config2__PriceListId__c = Pricelist.Id;
        LineItem.Apttus_Config2__PriceListItemId__c = PriceListItem.Id;
        LineItem.Apttus_Config2__SellingFrequency__c = 'Yearly';
        LineItem.Apttus_Config2__BillingRule__c = 'Bill In Advance';
        LineItem.Apttus_Config2__BillingFrequency__c = 'Monthly';
        LineItem.Apttus_Config2__Quantity__c = 1;
        LineItem.Apttus_Config2__TotalQuantity__c = 1;
        LineItem.Apttus_Config2__StartDate__c = Date.today();
        LineItem.Apttus_Config2__SellingTerm__c = 1.00278;
        LineItem.Apttus_Config2__EndDate__c = Date.today().addMonths(4);
        LineItem.Apttus_Config2__BaseExtendedPrice__c = 100;
        LineItem.Apttus_Config2__ExtendedPrice__c = 10;
        LineItem.Apttus_Config2__NetPrice__c = 100;
        LineItem.Apttus_Config2__DeltaPrice__c = 20;
        LineItem.Apttus_Config2__DeltaQuantity__c = 1;
        LineItem.Apttus_Config2__NetAdjustmentPercent__c = 0;
        LineItem.Apttus_Config2__LineStatus__c = 'Renewed';
        LineItem.Apttus_Config2__BasePrice__c = 1000;
        LineItem.Apttus_Config2__IsPrimaryRampLine__c = true;
        insert LineItem;
        System.assertNotEquals(null, LineItem);
        return LineItem;
    }
    public static Apttus_Config2__LineItem__c getLineItem2(Apttus_Config2__ProductConfiguration__c ProdConfig,Product2 product,Apttus_Config2__PriceList__c Pricelist,Apttus_Config2__PriceListItem__c PriceListItem){
        Apttus_Config2__LineItem__c LineItem = new Apttus_Config2__LineItem__c();

        LineItem.Apttus_Config2__Description__c = 'prodname';
        LineItem.Apttus_Config2__BasePrice__c = 100;
        LineItem.Apttus_Config2__ListPrice__c = 100;
        LineItem.Apttus_Config2__NetPrice__c = 100;
        LineItem.Apttus_Config2__LineNumber__c = 1;
        LineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        LineItem.Apttus_Config2__ItemSequence__c = 1;
        LineItem.Apttus_Config2__IsPrimaryLine__c = true;
        LineItem.Apttus_Config2__ChargeType__c = 'Lease';
        LineItem.Apttus_Config2__ConfigurationId__c = ProdConfig.Id;
        LineItem.Apttus_Config2__ProductId__c = product.Id;
        LineItem.Apttus_Config2__PriceListId__c = Pricelist.Id;
        LineItem.Apttus_Config2__PriceListItemId__c = PriceListItem.Id;
        LineItem.Apttus_Config2__SellingFrequency__c = 'Yearly';
        LineItem.Apttus_Config2__BillingRule__c = 'Bill In Advance';
        LineItem.Apttus_Config2__BillingFrequency__c = 'Monthly';
        LineItem.Apttus_Config2__Quantity__c = 1;
        LineItem.Apttus_Config2__TotalQuantity__c = 1;
        LineItem.Apttus_Config2__StartDate__c = Date.today();
        LineItem.Apttus_Config2__SellingTerm__c = 1.00278;
        LineItem.Apttus_Config2__EndDate__c = Date.today().addMonths(4);
        LineItem.Apttus_Config2__BaseExtendedPrice__c = 100;
        LineItem.Apttus_Config2__ExtendedPrice__c = 10;
        LineItem.Apttus_Config2__NetPrice__c = 100;
        LineItem.Apttus_Config2__DeltaPrice__c = 20;
        LineItem.Apttus_Config2__DeltaQuantity__c = 1;
        LineItem.Apttus_Config2__NetAdjustmentPercent__c = 0;
        LineItem.Apttus_Config2__LineStatus__c = 'Renewed';
        LineItem.Apttus_Config2__BasePrice__c = 1000;
        LineItem.Apttus_Config2__IsPrimaryRampLine__c = true;
        insert LineItem;
        System.assertNotEquals(null, LineItem);
        return LineItem;
    }
    
    public static APTSMD_Store__c getStore(){
        APTSMD_Store__c testStore = new APTSMD_Store__c();
        testStore.Name = 'testName';
        
        insert testStore;
        return testStore;
    }
    
   public static  void addPricebookEntries() {
        // First, set up test price book entries.
        // Insert a test product.
        Product2 prod = new Product2(Name = 'Laptop X200', 
            Family = 'Hardware');
        insert prod;
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        // Create a custom price book
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        // 2. Insert a price book entry with a custom price.
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        // Next, perform some tests with your test price book entries.
    }
    
}