@isTest
public class APTSMD_SKOContactUsTest {
    public static User testUser;
    public static contact testContact;
    public static Account testAccount;
     
    @isTest static void init(){
        testAccount = APTSMD_testUtils.getAccount();
        testContact = APTSMD_testUtils.getContact(testAccount);
        testUser = APTSMD_testUtils.getUser();
    }
    
    static testMethod void test(){
        init();
        APTSMD_Country__c country = new APTSMD_Country__c(APTSMD_CountryCode__c = APTSMD_Utils.currentCountry);
        insert country;
                    
        //PageReference sendinfo = contactUs.sendInfo();
        
        User pu = APTSMD_testUtils.getPortalUser(APTSMD_testUtils.PortalType.PowerPartner, null, true);

        System.runAs(pu){        
			APTSMD_SKOContactUs contactUs = new APTSMD_SKOContactUs();
                    
            PageReference sendinfo = contactUs.sendInfo();
        }
        

    }
    static testMethod void testcontr(){
       	testUser = APTSMD_testUtils.getUser();
        PageReference pageRef = Page.APTSMD_SKOBootStrapTemplate;
        Test.setCurrentPage(pageRef);

		
        Test.startTest();
        System.runAs(testUser){
            Test.setMock(HttpCalloutMock.class, new APTSMD_MockHttpResponseGenerator());
            Network net = new Network();
            //APTSMD_SKOBootStrapTemplateController bootStrapContr = new APTSMD_SKOBootStrapTemplateController();
        }
        
        
        Test.stopTest();
    }
    @isTest(SeeAllData = true)
    static void testConstrOver(){
       /* User ur = [select id, name, ProfileId, UserRoleId, UserType,PortalRole, isPortalEnabled from User where id = '0053E000000SiJRQA0'];

        system.debug(ur);
        Test.startTest();
        update ur;
       
        System.runAs(ur){
            Test.setMock(HttpCalloutMock.class, new APTSMD_MockHttpResponseGenerator());
 
            system.debug('newtrok ' + UserInfo.getSessionId());
        }
        Test.stopTest();
*/
/*
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
		system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        
        Database.insert(portalAccountOwner1);
        
        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
        
        System.runAs ( portalAccountOwner1 ) {
            //Create account
            Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner1.Id
            );
            Database.insert(portalAccount1);
            
            //Create contact
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);
            
            //Create user
            Profile portalProfile = [SELECT Id FROM Profile Limit 1];
            User user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(user1);
            
              System.debug('contactiD ' + contact1.Id);
            System.debug('userContactID ' + user1.ContactId);    
            
        }
        
      
        APTSMD_Country__c testCountry = new APTSMD_Country__c();
        testCountry.APTSMD_CountryCode__c = 'US';
        insert testCountry;

            APTSMD_SKOContactUs constr = new APTSMD_SKOContactUs();
          */
    }
}