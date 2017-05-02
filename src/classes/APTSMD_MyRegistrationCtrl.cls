global without sharing class APTSMD_MyRegistrationCtrl {

    public APTSMD_MyRegistrationCtrl() {

    }

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public APTSMD_MyRegistrationCtrl(ApexPages.StandardController stdController) {
    }

    
     @remoteAction
public static RegistrationResult registerNewUserfinal (String userName, String firstName, String lastName, String email, String phone, Integer opco, 
        String custNo, String pocNo , String meterSerialNo, String invoiceNo, String opcoName)
    {
        //create a new contact
        Account account = [SELECT ID, Name FROM Account where Name = 'ABC Corporation'];
        system.debug('********Start');  
        Contact con = [Select id FROM Contact WHERE FirstName =: firstName And LastName =: lastName and Email =: email And AccountId =: account.Id];
        RegistrationResult result = new RegistrationResult();
         system.debug('********End'+con);      
        String profId =[SELECT ID, name from Profile where Name ='KUKA Webstore Community User'].Id;
        // USERrole roleId = [SELECT ID, name from USERrole where Name ='CEO'];
        
        User newUser = new User ();
        newUser.IsActive = true;
        newUser.UserName = con.id+email;
        newUser.Alias = 'Tcode';
        newUser.CommunityNickname = firstName+lastName;
        // newUser.UserRoleId = roleId.Id;
        newUser.Email = email;
        newUser.FirstName =  firstName;
        newUser.LastName = lastName;
        newUser.Phone = phone;
        newUser.ProfileId = profId ;
        newUser.ContactId = con.Id; 
        newUser.TimeZoneSidKey = 'GMT';
        newUser.LocaleSidKey = 'en_US';
        newUser.EmailEncodingKey = 'ISO-8859-1';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.UserPermissionsMobileUser = false;
        insert newUser;
       
        // Add some details here ...
         
        // Set the DML options
        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerUserEmail = false;
         
        Database.insert(newUser,dlo);
        system.setPassword(newUser.id,'Aapttus000#');
        system.debug('user: '+newUser);
        
        List<PermissionSetAssignment> perSet = new List<PermissionSetAssignment>();
        List<PermissionSet> pselist = [SELECT Id,Name FROM PermissionSet WHERE Name IN('GrrenTech_eCommerce_Permissions_2','ApttusCPQUser','APTSCU_Partner_Community','Partner_User')];
        for(PermissionSet temp: pselist) {
            PermissionSetAssignment tempass = new PermissionSetAssignment();
            tempass.AssigneeId = newUser.Id;
            tempass.PermissionSetId = temp.Id;
            perSet.add(tempass);
            
        }
        if(perSet.Size()>0) {
            insert perSet;
        }
        
     
                
        /*Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(newContact.id);
        Approval.ProcessResult appResult = Approval.process(req1);*/
        
        
        System.SavePoint sp = Database.setSavepoint(); 
        if(true){
            result.Success = true;
        }else{
            result.Success = false;
            Database.rollback(sp);
        } 
        
        //return registration result
        return result;
    }
    
    
    public class RegistrationResult  {
         public Boolean Success { get; set; }
        public Integer ErrCode { get; set; }
        public String ErrMessage { get; set; }
        public String Message { get; set; }
    }
}