@isTest
public class APTSMD_MyRegistrationCtrlTest {
    private static Account acc;
    private static Contact cont;
    private static User usr;
    
    @isTest static void init(){
        acc = APTSMD_testUtils.getAccount();
        cont = APTSMD_testUtils.getContact(acc);
        usr = APTSMD_testUtils.getPortalUser(APTSMD_testUtils.PortalType.PowerPartner, null, true);
    }
    
    static testMethod void testregisterNewUserfinal(){
        init();
        
         APTSMD_MyRegistrationCtrl.RegistrationResult regResult = new APTSMD_MyRegistrationCtrl.RegistrationResult();
       	regResult.Success = true;
        regResult.ErrCode = 123;
        regResult.ErrMessage = 'ErrorMSG';
        regResult.Message = 'Msg';
        
        //Account acc = APTSMD_testUtils.getAccount();
        
        //Contact cont = APTSMD_testUtils.getContact(acc);
        
        Profile p = [SELECT Id FROM Profile WHERE Name ='KUKA Webstore Community User'];

        APTSMD_MyRegistrationCtrl testutil = new APTSMD_MyRegistrationCtrl();
        
        System.runAs(usr){
        	//APTSMD_MyRegistrationCtrl.registerNewUserfinal('Test', 'Test', 'Test', 'test@abv.bg', 'Test', 55, 'Test', 'Test', 'Test', 'Test', 'Test');    
        }
        
        
    }
}