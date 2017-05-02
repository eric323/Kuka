@isTest
public class APTSMD_UtilsTest {
    static testMethod void testConstr(){
        APTSMD_Utils testUtil = new APTSMD_Utils();
        
        System.assertNotEquals(null, testUtil);
        
        
        //column
        APTSMD_Utils.Column col = new APTSMD_Utils.Column('testLabel', 'testName', 'testApiname', false, false);
        
        APTSMD_Utils.SortParams patams = new APTSMD_Utils.SortParams();
        patams.sobjectSortByName = 'test';
        patams.fieldSortByName = 'test';
        patams.sortDirection = 'test';
        //countryinfo
        string cinfo = APTSMD_Utils.getCountryCodeFromWebService();
    }
    
    static testMethod void testCurrentLanguage(){
        String strOwnerId = APTSMD_Utils.getOwnerId();
        
        System.assertNotEquals(null, strOwnerId);
        
        //test currentLanguage()
        String currentLanguage = APTSMD_Utils.currentLanguage;
        
        //test currentCountry()
        String currentCountry = APTSMD_Utils.currentCountry;
    }
    
    static testMethod void AvailableCountries_ShouldReturn_Countries(){
        APTSMD_Country__c testCountry = new APTSMD_Country__c(Name = 'USA', APTSMD_CountryCode__c = 'US');
        testCountry.APTSMD_INeo_Available__c = true;
        insert testCountry;
        //set Languages
       	APTSMD_Language__c testLanguage = new APTSMD_Language__c(Name = 'US English', APTSMD_Language_Code__c = 'en_US', APTSMD_Country__c = testCountry.id);
        insert testLanguage;
        
        List<APTSMD_Country__c> lstAvailableCountries =  APTSMD_Utils.getAvailableCountries();
        System.debug('List Available Countries : ' + lstAvailableCountries);
        
        System.assertEquals('USA', lstAvailableCountries[0].Name);
        
        Map<string,APTSMD_Country__c> mapAvailableCountries = APTSMD_Utils.getCountrieMap();
        
        //test getCountrylist
        List<SelectOption> lstCountry = APTSMD_Utils.getCountryList();
        
        List<SelectOption> lstCountry2 = APTSMD_Utils.getCountryList2();
        
        List<SelectOption> lstLanguageCode = APTSMD_Utils.getLanguagesList('en_US');
        
        List<SelectOption> lstLanguageCode2 = APTSMD_Utils.getLanguagesList();
        
    }
    
    static testMethod void testIsLoggedIn(){
        boolean bIsLoggedIn = APTSMD_Utils.isLoggedIn();

        System.assertEquals(true, bIsLoggedIn);
    }
    
    static testMethod void testGetCountryCodeFromWebService(){
        
        ApexPages.currentPage().getHeaders().put('True-Client-IP', 'test');
        
        string trueIP = APTSMD_Utils.getCountryCodeFromWebService();
        
        System.debug('IP == ' + trueIP);
    }
    
    static testMethod void testGetCurrentContactID(){
        Account a = APTSMD_testUtils.getAccount();

        User u = APTSMD_testUtils.getUser();

        a.OwnerId = u.Id;
        update a;
        
        Contact testContact = new Contact();
        testContact.LastName = 'test';
        testContact.OwnerId = u.id;
        testContact.Salutation = 'Mr.';
        insert testContact;
		
        string currentContact = APTSMD_Utils.getCurrentContactID();
        
        string getContactFallBack = APTSMD_Utils.getContactID_SiteFallBack();
        
        string getCurrentAccID = APTSMD_Utils.getCurrentAccountID();
        system.debug('account id ' + getCurrentaccid);
    }
    
    static testMethod void testHelperMethods(){
        boolean empty = APTSMD_Utils.isEmpty('');
        
        boolean cookie = APTSMD_Utils.createCookie('test', 'testValue');
        
        User u = APTSMD_testUtils.getUser();
        list<sObject> lstSObj = new list<sObject>();
        lstSObj.add(u);
        
        //List<SelectOption> selectOption = APTSMD_Utils.getSelectOptionList(lstSObj);
        
        
        set<User> setAcc = new set<User>();
        setAcc.add(u);
        
        boolean bIsEmpty = APTSMD_utils.isEmpty(u);
        
        boolean bIsEmpty2 = APTSMD_utils.isEmpty(setAcc);
        
    }
    
    static testMethod void test(){
        //getFieldValueMap
        Account ac = new Account(name = 'test');
        
        list<account> lstAccount = new list<account>();
        lstAccount.add(ac);
        
        map<String,Sobject> filedMap = APTSMD_Utils.getFieldValueMap(lstAccount, 'Name');
        
        Product2 testProduct = new Product2(Name = 'testProduct');
        insert testProduct;
        
        list<Product2> lstProduct = new List<Product2>();
        lstProduct.add(testProduct);
        
        List<SelectOption> selectOption =  APTSMD_Utils.getSelectOptionList(lstProduct);
        
        
    }    
    
    static testMethod void test2(){
        Account ac = new Account(name = 'test');
        
        set<string> setString = new set<string>();
        setString.add(String.valueOf(ac));
        
        boolean isEmpty =  APTSMD_Utils.isEmpty(setString);
        
        set<SObject> setSObject = new set<SObject>();
        setSObject.add(ac);
        
        boolean isEmptySetObj = APTSMD_Utils.isEmpty(setSObject);
        
        String getCookie = APTSMD_Utils.getCookie('testCookie');
        
    }
    
    
    
    
    
    
    
    
    
}