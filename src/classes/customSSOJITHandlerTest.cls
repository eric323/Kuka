/**********************************************************************
Name:  customSSOJITHandlerTest
======================================================
Purpose:

Unittest Class for customSSOJITHandler
======================================================
History
-------
Date            AUTHOR                      DETAIL
01.07.2016      Andreas Meyer               INITAL CREATION
04.07.2016      Andreas Meyer               additional unittests
05.07.2016      Andreas Meyer               get profile name from custom settings
05.07.2016      Andreas Meyer               remove manager if managerSID ist not present or blank   
07.07.2016      Andreas Meyer               assign default role via custom setting     
07.07.2016      Andreas Meyer               add orgID to username on creation   
01.09.2016      Benjamin Zimmermann         Test for trim the Title to 80 Char, and Use base64-encoded StreetAddress
10.10.2016      Andreas Meyer               add test for Kuka_ExternalUserID to replicate the FederationID
02.11.2016      Andreas Meyer               DC-787 add exception handler for wrong country/state combo
08.11.2016      Andreas Meyer               lookup of statecode via state name
*********************************************************************/
@isTest
private class customSSOJITHandlerTest {


    private static String getFirstValidCountry(Boolean useDummy){
        if (true == useDummy){
            return 'US';    
        }

        Schema.DescribeFieldResult fieldResultCountry = User.Countrycode.getDescribe();
        List<Schema.PicklistEntry> pleCountry = fieldResultCountry.getPicklistValues();
        if (false == pleCountry.isEmpty()){
            return pleCountry[0].getValue();
        }
        return 'US';      
    }

    private static String getFirstValidState(Boolean useDummy){

        if (true == useDummy){
            return 'AZ';    
        }

        Schema.DescribeFieldResult fieldResultState = User.statecode.getDescribe();
        List<Schema.PicklistEntry> pleState = fieldResultState.getPicklistValues();
        if (false == pleState.isEmpty()){
            return pleState[0].getValue();
        }
        return 'AZ';      
    }


    private static User createTestUser(){
        User u = new User();
        Profile p = [SELECT Id FROM profile WHERE name='Standard User'];
        u.username = 'testuser@kuka.com';
        u.email = 'testuser@kuka.com';
        u.lastName = 'testLast';
        u.firstName = 'testFirst';
        String alias = 'ttestla';
        u.alias = alias;

        u.CommunityNickname = u.username;
        //u.MobilePhone = '12345';
        u.Phone = '56789';
        u.Street = 'teststreet';
        u.PostalCode = '1000';
        u.City = 'testcity';
        // andreas.meyer@salesforce.com 02.11.2016 DC-787 set country/state values
        //u.Country = getFirstValidCountry(false);
        //u.State = getFirstValidState(false);
        u.Countrycode = 'US';
        u.StateCode = 'AZ';
        u.Department = 'testdepartment';

        u.CompanyName = 'testcompany';       
        
        u.languagelocalekey = 'en_US';
        u.localesidkey = 'en_US';
        u.emailEncodingKey = 'UTF-8';
        u.timeZoneSidKey = 'America/Los_Angeles';
        u.profileId = p.Id;
        u.FederationIdentifier = 'S-1-5-21-121316445-509936788-1842888061-00001';
        return u;
    }

    private static User createTestManager(){
        User u = new User();
        Profile p = [SELECT Id FROM profile WHERE name='Standard User'];
        u.username = 'testmanager@kuka.com';
        u.email = 'testmanager@kuka.com';
        u.lastName = 'testManagerLast';
        u.firstName = 'testManagerFirst';
        String alias = 'ttestma';
        u.alias = alias;

        u.CommunityNickname = u.username;
        //u.MobilePhone = '12345';
        u.Phone = '56789';
        u.Street = 'teststreet';
        u.PostalCode = '1000';
        u.City = 'testcity';
        // andreas.meyer@salesforce.com 02.11.2016 DC-787 set country/state values
        //u.Country = getFirstValidCountry(false);
        //u.State = getFirstValidState(false);
        u.Countrycode = 'US';
        u.StateCode = 'AZ';
        u.Department = 'testdepartment';

        u.CompanyName = 'testcompany';
        
        u.languagelocalekey = 'en_US';
        u.localesidkey = 'en_US';
        u.emailEncodingKey = 'UTF-8';
        u.timeZoneSidKey = 'America/Los_Angeles';
        u.profileId = p.Id;
        u.FederationIdentifier = 'S-1-5-21-121316445-509936788-1842888061-00002';
        return u;
    }

    private static UserRole insertValidUserRoleId(){
       // run in user context to avoid MIXED_DML_OPERATION errors
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        UserRole r = new UserRole(name = 'TEST ROLE', Developername = 'TEST_ROLE');
        System.RunAs(usr){
            Database.insert(r);
        }
        return r;
    }

    static testMethod void Unittest_createValidUser() {    

        // insert custom setting
        customJITHandlerFilter__c ZInstance1 = new customJITHandlerFilter__c( filterterm__c = '@swisslog', filteraddon__c = '.kuka.corp',  Name='swisslog');
        insert ZInstance1;
        customJITHandlerSettings__c ZInstance2 = new customJITHandlerSettings__c( value__c = 'Chatter Free User',  Name='DefaultProfile');
        insert ZInstance2;   
        UserRole r =  insertValidUserRoleId();  
        customJITHandlerSettings__c ZInstance3 = new customJITHandlerSettings__c( value__c = r.DeveloperName,  Name='DefaultRole');
        insert ZInstance3;   

        ID hID = UserInfo.getUserId();
        ID hID2 = null;
        String hCountry = getFirstValidCountry(true);
        String hState = getFirstValidState(true);
        Map<String, String> attributes = new Map<String, String>{   'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress' => 'testuser@kuka.com', 
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname' => 'testFirst',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname' => 'testLast',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince' => hState,
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/homephone' => '56789',
                                                                    'http://sts.kuka.com/kuka/claims/departmentshort' => 'testdepartment',
                                                                    'http://sts.kuka.com/kuka/claims/title' => 'testtitle',
                                                                    'http://sts.kuka.com/kuka/claims/company' => 'testcompany',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country' => hcountry,
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/streetaddress' => 'teststreet',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality' => 'testcity',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/postalcode' => '1000'};

        test.startTest();
        customSSOJITHandler handler = new customSSOJITHandler();
        User u = handler.createUser(hID, hID2, hID2,'S-1-5-21-121316445-509936788-1842888061-00001', attributes, 'assertion_dummy_string');
        test.stopTest();

        // query profileid
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Chatter Free User'];
        Id profileId = p.Id;

        // check user u is created
        System.assert(u != null);
        // check u standard attributes
        System.assertEquals('testuser@kuka.com', u.email);
        System.assertEquals('testLast', u.lastName);
        System.assertEquals('testFirst', u.firstName);
        System.assertEquals('testtitle', u.Title);
        System.assertEquals('testcompany', u.CompanyName);
        System.assertEquals('56789', u.Phone);

        System.assertEquals('testdepartment', u.Department);
        System.assertEquals(hstate, u.StateCode);
        System.assertEquals(hCountry, u.CountryCode);
        System.assertEquals('teststreet', u.Street);
        System.assertEquals('testcity', u.City);
        System.assertEquals('1000', u.PostalCode);
        // check u alias (autogenerate)
        System.assertEquals('ttestla', u.Alias);
        // check u username (autogenerate)
        //System.assertEquals(u.Username, u.email);    
        // check FederationIdentifier
        System.assertEquals('S-1-5-21-121316445-509936788-1842888061-00001', u.FederationIdentifier);
        // 10.10.2016 andreas.meyer@salesforce.com check u.Kuka_ExternalUserID__c
        System.assertEquals(u.Kuka_ExternalUserID__c, u.FederationIdentifier);
        // check ProfileId
        System.assertEquals(profileId, u.ProfileId);  
        // check RoleId
        System.assertEquals(r.Id, u.UserRoleId);   

        // check for username 
        Organization myOrg = [Select    o.LanguageLocaleKey,
                                            o.DefaultLocaleSidKey,
                                            o.IsSandbox,
                                            o.Id   
                                            From Organization o];   
        if (true == myOrg.IsSandbox){
            String compareStr = u.email+myOrg.Id;
            System.assertEquals(u.Username, compareStr); 
        } 
        else{
            System.assertEquals(u.Username, u.email);      
        }          

    }


    static testMethod void Unittest_createValidUser_lookupManager() {   

        User umanager = createTestManager();
        insert umanager;    


        // insert custom setting
        customJITHandlerFilter__c ZInstance1 = new customJITHandlerFilter__c( filterterm__c = '@swisslog', filteraddon__c = '.kuka.corp',  Name='swisslog');
        insert ZInstance1;
        customJITHandlerSettings__c ZInstance2 = new customJITHandlerSettings__c( value__c = 'Chatter Free User',  Name='DefaultProfile');
        insert ZInstance2;  
        UserRole r =  insertValidUserRoleId();  
        customJITHandlerSettings__c ZInstance3 = new customJITHandlerSettings__c( value__c = r.DeveloperName,  Name='DefaultRole');
        insert ZInstance3;            

        ID hID = UserInfo.getUserId();
        ID hID2 = null;
        String hCountry = getFirstValidCountry(true);
        String hState = getFirstValidState(true);        
        Map<String, String> attributes = new Map<String, String>{   'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress' => 'testuser@kuka.com', 
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname' => 'testFirst',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname' => 'testLast',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince' => hstate,
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/homephone' => '56789',
                                                                    'http://sts.kuka.com/kuka/claims/departmentshort' => 'testdepartment',
                                                                    'http://sts.kuka.com/kuka/claims/title' => 'testtitle',
                                                                    'http://sts.kuka.com/kuka/claims/company' => 'testcompany',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country' => hcountry,
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/streetaddress' => 'teststreet',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality' => 'testcity',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/postalcode' => '1000',
                                                                    'http://sts.kuka.com/kuka/claims/ManagerSID' => 'S-1-5-21-121316445-509936788-1842888061-00002'};

        test.startTest();
        customSSOJITHandler handler = new customSSOJITHandler();
        User u = handler.createUser(hID, hID2, hID2,'S-1-5-21-121316445-509936788-1842888061-00001', attributes, 'assertion_dummy_string');
        test.stopTest();

        // check user u is created
        System.assert(u != null);
        // check manager
        System.assertEquals(u.ManagerId, umanager.Id);  

    }
    
    static testMethod void Unittest_createValidUser_lookupInvalidManager() {   

        User umanager = createTestManager();
        insert umanager;    


        // insert custom setting
        customJITHandlerFilter__c ZInstance1 = new customJITHandlerFilter__c( filterterm__c = '@swisslog', filteraddon__c = '.kuka.corp',  Name='swisslog');
        insert ZInstance1;
        customJITHandlerSettings__c ZInstance2 = new customJITHandlerSettings__c( value__c = 'Chatter Free User',  Name='DefaultProfile');
        insert ZInstance2;   
        UserRole r =  insertValidUserRoleId();  
        customJITHandlerSettings__c ZInstance3 = new customJITHandlerSettings__c( value__c = r.DeveloperName,  Name='DefaultRole');
        insert ZInstance3;   

        ID hID = UserInfo.getUserId();
        ID hID2 = null;
        String hCountry = getFirstValidCountry(true);
        String hState = getFirstValidState(true);
        Map<String, String> attributes = new Map<String, String>{   'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress' => 'testuser@kuka.com', 
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname' => 'testFirst',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname' => 'testLast',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince' => hstate,
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/homephone' => '56789',
                                                                    'http://sts.kuka.com/kuka/claims/departmentshort' => 'testdepartment',
                                                                    'http://sts.kuka.com/kuka/claims/title' => 'testtitle',
                                                                    'http://sts.kuka.com/kuka/claims/company' => 'testcompany',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country' => hcountry,
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/streetaddress' => 'teststreet',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality' => 'testcity',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/postalcode' => '1000',
                                                                    'http://sts.kuka.com/kuka/claims/ManagerSID' => 'S-1-5-21-121316445-509936788-1842888061-00002-Invalid'};

        test.startTest();
        customSSOJITHandler handler = new customSSOJITHandler();
        User u = handler.createUser(hID, hID2, hID2,'S-1-5-21-121316445-509936788-1842888061-00001', attributes, 'assertion_dummy_string');
        test.stopTest();

        // check user u is created
        System.assert(u != null);
        // check manager
        System.assertEquals(u.ManagerId, null);  

    }
    


    static testMethod void Unittest_createValidUser_Usernamerewrite() {   

        // insert custom setting
        customJITHandlerFilter__c ZInstance1 = new customJITHandlerFilter__c( filterterm__c = '@swisslog', filteraddon__c = '.kuka.corp',  Name='swisslog');
        insert ZInstance1;
        customJITHandlerSettings__c ZInstance2 = new customJITHandlerSettings__c( value__c = 'Chatter Free User',  Name='DefaultProfile');
        insert ZInstance2;   
        UserRole r =  insertValidUserRoleId();  
        customJITHandlerSettings__c ZInstance3 = new customJITHandlerSettings__c( value__c = r.DeveloperName,  Name='DefaultRole');
        insert ZInstance3;   

        ID hID = UserInfo.getUserId();
        ID hID2 = null;
        String hCountry = getFirstValidCountry(true);
        String hState = getFirstValidState(true);        
        Map<String, String> attributes = new Map<String, String>{   'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress' => 'testuser@swisslog.com', 
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname' => 'testFirst',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname' => 'testLast',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince' => hstate,
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/homephone' => '56789',
                                                                    'http://sts.kuka.com/kuka/claims/departmentshort' => 'testdepartment',
                                                                    'http://sts.kuka.com/kuka/claims/title' => 'testtitle',
                                                                    'http://sts.kuka.com/kuka/claims/company' => 'testcompany',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country' => hcountry,
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/streetaddress' => 'teststreet',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality' => 'testcity',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/postalcode' => '1000',
                                                                    'http://sts.kuka.com/kuka/claims/ProfileId' => 'Chatter Free User'};

        test.startTest();
        customSSOJITHandler handler = new customSSOJITHandler();
        User u = handler.createUser(hID, hID2, hID2,'S-1-5-21-121316445-509936788-1842888061-00001', attributes, 'assertion_dummy_string');
        test.stopTest();

        // check user u is created
        System.assert(u != null);
        // check username
        //System.assertEquals('testuser@swisslog.com.kuka.corp', u.Username);  
        // check for username 
        Organization myOrg = [Select    o.LanguageLocaleKey,
                                            o.DefaultLocaleSidKey,
                                            o.IsSandbox,
                                            o.Id   
                                            From Organization o];   
        if (true == myOrg.IsSandbox){
            String compareStr = 'testuser@swisslog.com.kuka.corp'+myOrg.Id;
            System.assertEquals(u.Username, compareStr); 
        } 
        else{
            System.assertEquals(u.Username, 'testuser@swisslog.com.kuka.corp');      
        }         
        // check u standard attributes
        System.assertEquals('testuser@swisslog.com', u.email);
    }


    static testMethod void Unittest_updateValidUser() {

        User givenuser = createTestUser();
        insert givenuser;  

        // run in user context to avoid MIXED_DML_OPERATION errors
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            // insert custom setting
            customJITHandlerFilter__c ZInstance1 = new customJITHandlerFilter__c( filterterm__c = '@swisslog', filteraddon__c = '.kuka.corp',  Name='swisslog');
            insert ZInstance1;
            customJITHandlerSettings__c ZInstance2 = new customJITHandlerSettings__c( value__c = 'Chatter Free User',  Name='DefaultProfile');
            insert ZInstance2;     
            UserRole r =  insertValidUserRoleId();  
            customJITHandlerSettings__c ZInstance3 = new customJITHandlerSettings__c( value__c = r.DeveloperName,  Name='DefaultRole');
            insert ZInstance3;                         
        }

        ID hID = UserInfo.getUserId();
        ID hID2 = null;
        Map<String, String> attributes = new Map<String, String>{   'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress' => 'Newtestuser@kuka.com', 
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname' => 'NewtestFirst',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname' => 'NewtestLast',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince' => 'CA',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/homephone' => '00156789',
                                                                    'http://sts.kuka.com/kuka/claims/departmentshort' => 'Newtestdepartment',
                                                                    'http://sts.kuka.com/kuka/claims/title' => 'Newtesttitle',
                                                                    'http://sts.kuka.com/kuka/claims/company' => 'Newtestcompany',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country' => 'US',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/streetaddress' => 'Newteststreet',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality' => 'Newtestcity',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/postalcode' => '2000'};

        test.startTest();
        customSSOJITHandler handler = new customSSOJITHandler();
        handler.updateUser(givenuser.Id, hID,hID2, hID2,'S-1-5-21-121316445-509936788-1842888061-00001', attributes, 'assertion_dummy_string');
        test.stopTest();

        // 10.10.2016 andreas.meyer@salesforce.com add u.Kuka_ExternalUserID__c and FederationIdentifier
        User u = [SELECT ID,email,Kuka_ExternalUserID__c,FederationIdentifier,lastName,firstName,Title,CompanyName,Phone,MobilePhone,Department,StateCode,CountryCode,Street,City,PostalCode,Alias,Username,UserRoleId FROM User WHERE Id =:givenuser.Id];

        // check u standard attributes
        System.assertEquals('newtestuser@kuka.com', u.email); // email is always lowercase
        System.assertEquals('NewtestLast', u.lastName);
        System.assertEquals('NewtestFirst', u.firstName);
        System.assertEquals('Newtesttitle', u.Title);
        System.assertEquals('Newtestcompany', u.CompanyName);
        System.assertEquals('00156789', u.Phone);

        System.assertEquals('Newtestdepartment', u.Department);

        System.assertEquals('CA', u.StateCode);        
        System.assertEquals('US', u.CountryCode);

        System.assertEquals('Newteststreet', u.Street);
        System.assertEquals('Newtestcity', u.City);
        System.assertEquals('2000', u.PostalCode);
        // check u alias (autogenerate)
        System.assertEquals('nnewtes', u.Alias);
        // check u username (autogenerate)
        //System.assertEquals(u.Username, u.email);
        Organization myOrg = [Select    o.LanguageLocaleKey,
                                            o.DefaultLocaleSidKey,
                                            o.IsSandbox,
                                            o.Id   
                                            From Organization o];   
        if (true == myOrg.IsSandbox){
            // username in Sandbox must stay untouched on update
            System.assertEquals(u.Username, 'testuser@kuka.com'); 
        } 
        else{
            // username in Prod must be updated
            System.assertEquals(u.Username, u.email);      
        }             

                // check RoleId
        System.assertEquals(null, u.UserRoleId);   

        // 10.10.2016 andreas.meyer@salesforce.com check u.Kuka_ExternalUserID__c
        System.assertEquals(u.Kuka_ExternalUserID__c, u.FederationIdentifier);          


    }


    static testMethod void Unittest_updateValidUser_changeFedID() {

        User givenuser = createTestUser();
        givenuser.IsActive = false;
        insert givenuser;  

        // run in user context to avoid MIXED_DML_OPERATION errors
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            // insert custom setting
            customJITHandlerFilter__c ZInstance1 = new customJITHandlerFilter__c( filterterm__c = '@swisslog', filteraddon__c = '.kuka.corp',  Name='swisslog');
            insert ZInstance1;
            customJITHandlerSettings__c ZInstance2 = new customJITHandlerSettings__c( value__c = 'Chatter Free User',  Name='DefaultProfile');
            insert ZInstance2; 
            UserRole r =  insertValidUserRoleId();  
            customJITHandlerSettings__c ZInstance3 = new customJITHandlerSettings__c( value__c = r.DeveloperName,  Name='DefaultRole');
            insert ZInstance3;                             
        }

        ID hID = UserInfo.getUserId();
        ID hID2 = null;
        Map<String, String> attributes = new Map<String, String>{   'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress' => 'Newtestuser@kuka.com', 
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname' => 'NewtestFirst',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname' => 'NewtestLast',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince' => 'AZ',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/homephone' => '00156789',
                                                                    'http://sts.kuka.com/kuka/claims/departmentshort' => 'Newtestdepartment',
                                                                    'http://sts.kuka.com/kuka/claims/title' => 'Newtesttitle',
                                                                    'http://sts.kuka.com/kuka/claims/company' => 'Newtestcompany',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country' => 'US',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/streetaddress' => 'Newteststreet',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality' => 'Newtestcity',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/postalcode' => '2000',
                                                                    'http://sts.kuka.com/kuka/claims/sIDHistory' => 'S-1-5-21-121316445-509936788-1842888061-00001'};

        test.startTest();
        customSSOJITHandler handler = new customSSOJITHandler();
        // create user with different FedID
        User u = handler.createUser(hID, hID2, hID2,'S-1-5-21-121316445-509936788-1842888061-00003', attributes, 'assertion_dummy_string');
        test.stopTest();

 
        // check u standard attributes
        System.assertEquals('Newtestuser@kuka.com', u.email); 
        System.assertEquals('NewtestLast', u.lastName);
        System.assertEquals('NewtestFirst', u.firstName);
        System.assertEquals('Newtesttitle', u.Title);
        System.assertEquals('Newtestcompany', u.CompanyName);
        System.assertEquals('00156789', u.Phone);

        System.assertEquals('Newtestdepartment', u.Department);
        //System.assertEquals('Newteststate', u.State);
        //System.assertEquals('Newtestcountry', u.Country);
        // must stay the same (null)
        System.assertEquals('AZ', u.StateCode);
        System.assertEquals('US', u.CountryCode);
        System.assertEquals('Newteststreet', u.Street);
        System.assertEquals('Newtestcity', u.City);
        System.assertEquals('2000', u.PostalCode);
        // check u alias (autogenerate)
        System.assertEquals('nnewtes', u.Alias);
        // check new FedID
        System.assertEquals(u.FederationIdentifier, 'S-1-5-21-121316445-509936788-1842888061-00003');   
         // 10.10.2016 andreas.meyer@salesforce.com check u.Kuka_ExternalUserID__c
        System.assertEquals(u.Kuka_ExternalUserID__c, u.FederationIdentifier);       
        // check if user is activated again
        System.assertEquals(true, u.IsActive);       
    }


    static testMethod void Unittest_createValidUser_shortLastname_longTitle() {    

        // insert custom setting
        customJITHandlerFilter__c ZInstance1 = new customJITHandlerFilter__c( filterterm__c = '@swisslog', filteraddon__c = '.kuka.corp',  Name='swisslog');
        insert ZInstance1;
        customJITHandlerSettings__c ZInstance2 = new customJITHandlerSettings__c( value__c = 'Chatter Free User',  Name='DefaultProfile');
        insert ZInstance2;       
        UserRole r =  insertValidUserRoleId();  
        customJITHandlerSettings__c ZInstance3 = new customJITHandlerSettings__c( value__c = r.DeveloperName,  Name='DefaultRole');
        insert ZInstance3;   

        ID hID = UserInfo.getUserId();
        ID hID2 = null;
        // lastName must be less than 6 characters
        Map<String, String> attributes = new Map<String, String>{   'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress' => 'testuser@kuka.com', 
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname' => 'testFirst',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname' => 'XXX',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince' => 'CA',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/homephone' => '56789',
                                                                    'http://sts.kuka.com/kuka/claims/departmentshort' => 'testdepartment',
                                                                    'http://sts.kuka.com/kuka/claims/title' => 'This-Title-is-more-than-80-character-and-way-to-long-to-use-it-as-title-for-salesforce-------------------------------',
                                                                    'http://sts.kuka.com/kuka/claims/company' => 'testcompany',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country' => 'US',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/streetaddress' => 'teststreet',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality' => 'testcity',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/postalcode' => '1000',
                                                                    'http://sts.kuka.com/kuka/Base64Claim/streetAddress' => 'WmVpbGUx'};
                                                                    //WmVpbGUx is base64 for WmVpbGUx

        test.startTest();
        customSSOJITHandler handler = new customSSOJITHandler();
        User u = handler.createUser(hID, hID2, hID2,'S-1-5-21-121316445-509936788-1842888061-00001', attributes, 'assertion_dummy_string');
        test.stopTest();

        // check user u is created
        System.assert(u != null);
        // check u alias (autogenerate)
        System.assertEquals('txxx', u.Alias);
        System.assertEquals('This-Title-is-more-than-80-character-and-way-to-long-to-use-it-as-title-for-sale', u.Title);
        System.assertEquals('Zeile1',u.Street);


    }

    static testMethod void Unittest_updateValidUser_changeManagerToNull() {  

        User umanager = createTestManager();
        insert umanager;            

        User givenuser = createTestUser();
        givenuser.ManagerId = umanager.Id;

        insert givenuser;  




        // run in user context to avoid MIXED_DML_OPERATION errors
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            // insert custom setting
            customJITHandlerFilter__c ZInstance1 = new customJITHandlerFilter__c( filterterm__c = '@swisslog', filteraddon__c = '.kuka.corp',  Name='swisslog');
            insert ZInstance1;
            customJITHandlerSettings__c ZInstance2 = new customJITHandlerSettings__c( value__c = 'Chatter Free User',  Name='DefaultProfile');
            insert ZInstance2;   
            UserRole r =  insertValidUserRoleId();  
            customJITHandlerSettings__c ZInstance3 = new customJITHandlerSettings__c( value__c = r.DeveloperName,  Name='DefaultRole');
            insert ZInstance3;                           
        }
        ID hID = UserInfo.getUserId();
        ID hID2 = null;
        Map<String, String> attributes = new Map<String, String>{   'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress' => 'Newtestuser@kuka.com', 
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname' => 'NewtestFirst',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname' => 'NewtestLast',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince' => 'CA',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/homephone' => '00156789',
                                                                    'http://sts.kuka.com/kuka/claims/departmentshort' => 'Newtestdepartment',
                                                                    'http://sts.kuka.com/kuka/claims/title' => 'Newtesttitle',
                                                                    'http://sts.kuka.com/kuka/claims/company' => 'Newtestcompany',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country' => 'US',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/streetaddress' => 'Newteststreet',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality' => 'Newtestcity',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/postalcode' => '2000',
                                                                    'http://sts.kuka.com/kuka/claims/ManagerSID' => ''};

        test.startTest();
        customSSOJITHandler handler = new customSSOJITHandler();
        handler.updateUser(givenuser.Id, hID,hID2, hID2,'S-1-5-21-121316445-509936788-1842888061-00001', attributes, 'assertion_dummy_string');
        test.stopTest();

        User u = [SELECT ID,ManagerId FROM User WHERE Id =:givenuser.Id];

        // check Manager ... must be null
        System.assertEquals(null, u.ManagerId);   
    }

    static testMethod void Unittest_updateValidUser_changeManagerToNull_emptyAttribute() {  

        User umanager = createTestManager();
        insert umanager;            

        User givenuser = createTestUser();
        givenuser.ManagerId = umanager.Id;

        insert givenuser;  




        // run in user context to avoid MIXED_DML_OPERATION errors
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            // insert custom setting
            customJITHandlerFilter__c ZInstance1 = new customJITHandlerFilter__c( filterterm__c = '@swisslog', filteraddon__c = '.kuka.corp',  Name='swisslog');
            insert ZInstance1;
            customJITHandlerSettings__c ZInstance2 = new customJITHandlerSettings__c( value__c = 'Chatter Free User',  Name='DefaultProfile');
            insert ZInstance2; 
            UserRole r =  insertValidUserRoleId();  
            customJITHandlerSettings__c ZInstance3 = new customJITHandlerSettings__c( value__c = r.DeveloperName,  Name='DefaultRole');
            insert ZInstance3;                             
        }
        ID hID = UserInfo.getUserId();
        ID hID2 = null;
        Map<String, String> attributes = new Map<String, String>{   'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress' => 'Newtestuser@kuka.com', 
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname' => 'NewtestFirst',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname' => 'NewtestLast',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince' => 'CA',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/homephone' => '00156789',
                                                                    'http://sts.kuka.com/kuka/claims/departmentshort' => 'Newtestdepartment',
                                                                    'http://sts.kuka.com/kuka/claims/title' => 'Newtesttitle',
                                                                    'http://sts.kuka.com/kuka/claims/company' => 'Newtestcompany',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country' => 'US',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/streetaddress' => 'Newteststreet',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality' => 'Newtestcity',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/postalcode' => '2000'};

        test.startTest();
        customSSOJITHandler handler = new customSSOJITHandler();
        handler.updateUser(givenuser.Id, hID,hID2, hID2,'S-1-5-21-121316445-509936788-1842888061-00001', attributes, 'assertion_dummy_string');
        test.stopTest();

        User u = [SELECT ID,ManagerId FROM User WHERE Id =:givenuser.Id];

        // check Manager ... must be null
        System.assertEquals(null, u.ManagerId);   
    }

    static testMethod void Unittest_updateValidUser_changeManagerToNull_ManagerNotFound() {  

        User umanager = createTestManager();
        insert umanager;            

        User givenuser = createTestUser();
        givenuser.ManagerId = umanager.Id;

        insert givenuser;  




        // run in user context to avoid MIXED_DML_OPERATION errors
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            // insert custom setting
            customJITHandlerFilter__c ZInstance1 = new customJITHandlerFilter__c( filterterm__c = '@swisslog', filteraddon__c = '.kuka.corp',  Name='swisslog');
            insert ZInstance1;
            customJITHandlerSettings__c ZInstance2 = new customJITHandlerSettings__c( value__c = 'Chatter Free User',  Name='DefaultProfile');
            insert ZInstance2;    
            UserRole r =  insertValidUserRoleId();  
            customJITHandlerSettings__c ZInstance3 = new customJITHandlerSettings__c( value__c = r.DeveloperName,  Name='DefaultRole');
            insert ZInstance3;                          
        }
        ID hID = UserInfo.getUserId();
        ID hID2 = null;
        Map<String, String> attributes = new Map<String, String>{   'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress' => 'Newtestuser@kuka.com', 
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname' => 'NewtestFirst',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname' => 'NewtestLast',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince' => 'CA',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/homephone' => '00156789',
                                                                    'http://sts.kuka.com/kuka/claims/departmentshort' => 'Newtestdepartment',
                                                                    'http://sts.kuka.com/kuka/claims/title' => 'Newtesttitle',
                                                                    'http://sts.kuka.com/kuka/claims/company' => 'Newtestcompany',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country' => 'US',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/streetaddress' => 'Newteststreet',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality' => 'Newtestcity',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/postalcode' => '2000',
                                                                    'http://sts.kuka.com/kuka/claims/ManagerSID' => 'S-1-5-21-121316445-509936788-1842888061-00002-Invalid'};

        test.startTest();
        customSSOJITHandler handler = new customSSOJITHandler();
        handler.updateUser(givenuser.Id, hID,hID2, hID2,'S-1-5-21-121316445-509936788-1842888061-00001', attributes, 'assertion_dummy_string');
        test.stopTest();

        User u = [SELECT ID,ManagerId FROM User WHERE Id =:givenuser.Id];

        // check Manager .. must be the old one
        System.assertEquals(null, u.ManagerId);   
    }


    // lookup of StateCode
    static testMethod void Unittest_createValidUser_lookupStateCode() {    

        // insert custom setting
        customJITHandlerFilter__c ZInstance1 = new customJITHandlerFilter__c( filterterm__c = '@swisslog', filteraddon__c = '.kuka.corp',  Name='swisslog');
        insert ZInstance1;
        customJITHandlerSettings__c ZInstance2 = new customJITHandlerSettings__c( value__c = 'Chatter Free User',  Name='DefaultProfile');
        insert ZInstance2;   
        UserRole r =  insertValidUserRoleId();  
        customJITHandlerSettings__c ZInstance3 = new customJITHandlerSettings__c( value__c = r.DeveloperName,  Name='DefaultRole');
        insert ZInstance3;   

        ID hID = UserInfo.getUserId();
        ID hID2 = null;
        String hCountry = getFirstValidCountry(true);
        // Arizona in uppercase: ARIZONA
        String hState = 'ARIZONA';
        Map<String, String> attributes = new Map<String, String>{   'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress' => 'testuser@kuka.com', 
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname' => 'testFirst',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname' => 'testLast',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince' => hState,
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/homephone' => '56789',
                                                                    'http://sts.kuka.com/kuka/claims/departmentshort' => 'testdepartment',
                                                                    'http://sts.kuka.com/kuka/claims/title' => 'testtitle',
                                                                    'http://sts.kuka.com/kuka/claims/company' => 'testcompany',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country' => hcountry,
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/streetaddress' => 'teststreet',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality' => 'testcity',
                                                                    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/postalcode' => '1000'};

        test.startTest();
        customSSOJITHandler handler = new customSSOJITHandler();
        User u = handler.createUser(hID, hID2, hID2,'S-1-5-21-121316445-509936788-1842888061-00001', attributes, 'assertion_dummy_string');
        test.stopTest();

        // query profileid
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Chatter Free User'];
        Id profileId = p.Id;

        // check user u is created
        System.assert(u != null);
        // check u standard attributes
        System.assertEquals('testuser@kuka.com', u.email);
        System.assertEquals('testLast', u.lastName);
        System.assertEquals('testFirst', u.firstName);
        System.assertEquals('testtitle', u.Title);
        System.assertEquals('testcompany', u.CompanyName);
        System.assertEquals('56789', u.Phone);

        System.assertEquals('testdepartment', u.Department);
        // ARIZONA should be AZ
        System.assertEquals('AZ', u.StateCode);
        System.assertEquals(hCountry, u.CountryCode);
        System.assertEquals('teststreet', u.Street);
        System.assertEquals('testcity', u.City);
        System.assertEquals('1000', u.PostalCode);
        // check u alias (autogenerate)
        System.assertEquals('ttestla', u.Alias);
        // check u username (autogenerate)
        //System.assertEquals(u.Username, u.email);    
        // check FederationIdentifier
        System.assertEquals('S-1-5-21-121316445-509936788-1842888061-00001', u.FederationIdentifier);
        // 10.10.2016 andreas.meyer@salesforce.com check u.Kuka_ExternalUserID__c
        System.assertEquals(u.Kuka_ExternalUserID__c, u.FederationIdentifier);
        // check ProfileId
        System.assertEquals(profileId, u.ProfileId);  
        // check RoleId
        System.assertEquals(r.Id, u.UserRoleId);   

        // check for username 
        Organization myOrg = [Select    o.LanguageLocaleKey,
                                            o.DefaultLocaleSidKey,
                                            o.IsSandbox,
                                            o.Id   
                                            From Organization o];   
        if (true == myOrg.IsSandbox){
            String compareStr = u.email+myOrg.Id;
            System.assertEquals(u.Username, compareStr); 
        } 
        else{
            System.assertEquals(u.Username, u.email);      
        }          

    }


    
  
}