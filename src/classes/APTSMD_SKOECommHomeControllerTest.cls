@isTest
public class APTSMD_SKOECommHomeControllerTest {
    static testMethod void test(){
        /*
         Profile p = [select id
                      from profile
                     where usertype = 'PowerPartner'
                     limit 1];  
        userRole r = [Select id from UserRole where name = 'CEO'];
         Account portalAccount = new Account(Name='Test Account',ShippingStreet='1400 Fashion Island Blvd.',ShippingCity='San Mateo',ShippingState='California',
                        ShippingCountry='USA',ShippingPostalCode='94404',BillingStreet='1400 Fashion Island Blvd.',BillingCity='San Mateo',BillingState='California',
                        BillingCountry='USA',BillingPostalCode='94404');//create a portal account first
        insert portalAccount;
        Contact portalContact = new contact(LastName = 'portalContact', AccountId = portalAccount.Id, Salutation = 'Mr.'); //create a portal contact
        insert portalContact;
        User u1 = new User( email='genelia.dsouza@gmail.com',
                           profileid = p.id, 
                           UserName='genelia2.dsouza@gmail.com.ecommdev', 
                           Alias = 'GDS',
                           TimeZoneSidKey='America/New_York',
                           EmailEncodingKey='ISO-8859-1',
                           LocaleSidKey='en_US', 
                           LanguageLocaleKey='en_US',
                           ContactId = portalContact.Id,
                           PortalRole = 'Manager',
                           FirstName = 'Genelia',
                           LastName = 'Dsouza',
                          UserRole = r);
        
       	insert u1;
        
        //community user
        User pu = APTSMD_testUtils.getPortalUser(APTSMD_testUtils.PortalType.PowerPartner, null, true);
        pu.UserRoleId = r.id;
        pu.IsActive = true;
        
        
       

        
        //user ur = [select IsPortalEnabled, UserRoleId from User where id= :pu.Id];
       // System.debug(ur.IsPortalEnabled);
        user ur = [select id, name ,IsPortalEnabled from user where id =:u1.id];
        system.debug(ur);
        NetworkMember membership = [SELECT networkID, memberID FROM NetworkMember
                                                    WHERE memberID = :pu.id limit 1];

        
        System.runAs(ur){
			system.debug(UserInfo.getUserType());
             PageReference pageRef = Page.APTSMD_SKOECommHome;
            Test.setCurrentPageReference(pageRef);
            Test.setCurrentPage(pageRef);

			system.debug(ur.IsPortalEnabled);
            

        }
        */
        User pu = APTSMD_testUtils.getPortalUser(APTSMD_testUtils.PortalType.PowerPartner, null, true);
        try{
        System.runAs(pu){
            APTSMD_SKOECommHomeController getController = new APTSMD_SKOECommHomeController();
        }
        }catch(Exception  e){
            
        }
                     
    }
}