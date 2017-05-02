/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
/**********************************************************************
Name:  CommunitiesSelfRegController
======================================================
Purpose: Controller for communitiesSelfRegPage pages
======================================================
History
-------
Date        AUTHOR                          DETAIL
20/10/2016  Andreas Meyer                   add support for contact fields
21/10/2016  Andreas Meyer                   update contact record
03/11/2016  Andreas Meyer                   bugfixing, accept url parameter
08/11/2016  Andreas Meyer                   DC-723 autogenerate nickname
16/11/2016  Andreas Meyer                   Harden code for custom settings
20/11/2016  Andreas Meyer                   DC-846 make phone number optional
28/11/2016  Andreas Meyer                   add fallback strategy for duplicate nickname
05/12/2016  Andreas Meyer                   add validation for phonennumbers
05/12/2016  Benjamin Pfahl                  dynamic partner account detection
13/12/2016  Andreas Meyer                   change RegEx expression to meet more requirements
15/12/2016  Andreas Meyer                   remove TOS
16/12/2016  Andreas Meyer                   add default value for customer number
19/12/2016  Andreas Meyer                   limit Nickname to 40 characters
19/12/2016  Andreas Meyer                   switch to email notification mode for createExternalUser
23/12/2016  Andreas Meyer                   add salutaion to page parameter
23/12/2016  Andreas Meyer                   remove password handling
11/01/2017  Andreas Meyer                   add salutaion as a separate page parameter
17/01/2017  Andreas Meyer                   DC-1248 autoassign User.Users_Organisation
18/01/2017  Arokia Suresh Kumar             KCT-648 redirect user to target page passed as parameter to registration page
02/02/2017	Benjamin Pfahl					DC-1315 add country phone code to phone numer based on the selected country
13/02/2017	Arokia Suresh Kumar    		    DC-1315 added additional condition for country phone code inclusion
*********************************************************************/
public class CommunitiesSelfRegController {

    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String position {get; set;}
    public String company {get; set;}
    public String duns {get; set;}
    public String customernumber {get; set;}
    public String hMailingStreet {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    public String hexternalSfId {get; set;}
    public Contact helperContact {get; set;}
    public Boolean tos_accepted {get; set;}
    public Boolean hasError {get; set;}
    public Boolean helperPermEmail {get; set;}
    public Boolean helperPermLetter {get; set;}
    public Boolean helperPermNewsletter {get; set;}
    public Boolean helperPermTelefon {get; set;}
    public Boolean helperKukaconnect {get; set;}
    public Boolean showPassword {get; set;}
    public String target{get;set;}
    public String httpPrefix{get;set;}
    public User helperUser {get; set;}
    public string selectedValue { get;set; }
    public List<SelectOption> statusOptions { get;set; }
    
    // 14.3.2017 Arokia.Joseph Redirect functionality
    public Boolean helperSource {get;set;}    
    public String registrationSource {get;set;}
    public String sourceURL {get;set;}



    // error messages
    public String error_firstName {get; set;}
    public String error_lastName {get; set;}
    public String error_email {get; set;}
    public String error_position {get; set;}
    public String error_company {get; set;}
    public String error_street {get; set;}
    public String error_city {get; set;}
    public String error_country {get; set;}
    public String error_state {get; set;}
    public String error_zip {get; set;}
    public String error_phone {get; set;}
    public String error_mobile {get; set;}
    public String error_salutation {get; set;}
    public String error_communityNickname {get; set;}
    public String error_password {get; set;}
    public String error_passwordconfirm {get; set;}
    public String error_tos_accepted {get; set;}
    public String mylangu {get; set;}
    
    public static final string USER_ORG_EXTERNAL_COMMUNITY='External Community';

    
    public CommunitiesSelfRegController() {
                        
   
                 
        mylangu = ApexPages.currentPage().getHeaders().get('Accept-Language');
        if(mylangu != null){
        	mylangu = mylangu = mylangu.substring(0,2);
        }
		
        
        // create helper contact
        this.helperContact = new Contact();
     	this.helperUser = new User();                  
        
        clearAllErrorMessages();
        analyseURLParameter();
    
        // email and newsletter is always set to true
        helperPermEmail = true;
        helperPermNewsletter = true;
		tos_accepted = false;

        showPassword = true;
        communitySelfRegSettings__c useEmailVal = communitySelfRegSettings__c.getInstance('useEmailValidation');
        if(null != useEmailVal){
            if(useEmailVal.id == null) {
                showPassword = true; 
            }
            else{
                // read values
                showPassword = (useEmailVal.value__c.toLowerCase() != 'true');          
            }
        }
        else{
            showPassword = true;     
        }  
        
        
      /*  // 14.3.2017 Arokia.Joseph Redirect functionality
        if(true == helperSource){
           RedirectURLConfig__c redirectURLConfig = RedirectURLConfig__c.getInstance(registrationSource);
           if(null != redirectURLConfig){
           	sourceURL = redirectURLConfig.targetURL__c;
           }
           
        }*/
     
        


    }
    
    public void autoFillRelationToKuka()
    {
        Schema.DescribeFieldResult statusFieldDescription = User.Relation_to_KUKA__c.getDescribe();
        statusOptions = new list<SelectOption>();
        
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues())
        {
            statusOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
    }     
    
    private void analyseURLParameter(){
        // check for customernumber
        String hcustomernumber = ApexPages.currentPage().getParameters().get('customernumber');
        if (false == String.isBlank(hcustomernumber)){
            customernumber = hcustomernumber;
        }
        // check for email
         String hemail = ApexPages.currentPage().getParameters().get('email');
        if (false == String.isBlank(hemail)){
            email = hemail;
        }
        // check for kuka connect identifier
        String hconnect = ApexPages.currentPage().getParameters().get('kukaconnect');
        if (false == String.isBlank(hconnect)){
            helperKukaconnect = true;
            registrationSource = 'Connect';
        }   
         // check for source identifier  14.3.2017 Arokia.Joseph Redirect functionality
        String hSource = ApexPages.currentPage().getParameters().get('source');
        if (false == String.isBlank(hSource)){
            helperSource = true;
            registrationSource = hSource;
        }         
        // check for sf if provided by 3rd party system
        String hextsfid = ApexPages.currentPage().getParameters().get('externalSfId');
        if (false == String.isBlank(hextsfid)){
            hexternalSfId = hextsfid;
        }
        // check for redirect url 
        String htarget = ApexPages.currentPage().getParameters().get('target');
        if (false == String.isBlank(htarget)){
        	httpPrefix = 'https://';
            target = htarget;
            
        }               
        
        
    }

    @TestVisible private String checkautoassign_connect(String external_id, boolean autoassign){
        // init the account_id 
        string myaccount_id = '' ;

        // check if external_id is blank
        if (true == String.isBlank(external_id)){
            return myaccount_id; 
        }

        // first check if we have the flag autoassign         
        if (true == autoassign){
            // second check if we have an id, use a LIMIT 1 since you have a second query in a for loop            
            List<Account> listLocalAccounts = new List<Account>([SELECT id, isPartner, OwnerId  FROM Account WHERE Id = :external_id LIMIT 1]); 
            // check if id is correct and account is partner             
            for (Account myaccount : listLocalAccounts) {                
                if (true == myaccount.isPartner){                
                    // check now if owner has a role   
                    List<User> listOwnerRoles = new List<User>([SELECT Id, UserRoleId FROM User WHERE Id = :myaccount.OwnerId]);  
                    if (false == listOwnerRoles.isEmpty()){
                        string userroleid = listOwnerRoles[0].UserRoleId;
                        if (false == String.isBlank(userroleid)){
                            myaccount_id = myaccount.Id;
                            system.debug('CommunitiesSelfRegController: checkautoassign_connect: found matching accountid: ' + myaccount_id);                         
                            return myaccount_id;    
                        }
                    }                  
                }                             
            }
        }        
        return myaccount_id; 
    }    
    

    private void clearAllErrorMessages(){
        hasError = false;
        error_firstName = '';
        error_lastName = '';
        error_email = '';
        error_position = '';
        error_company = '';
        error_street = '';
        error_city = '';
        error_country = '';
        error_state = '';
        error_zip = '';
        error_phone = '';
        error_mobile = '';
        error_salutation = '';       
        error_communityNickname = ''; 
        error_password = '';
        error_passwordconfirm = '';
        error_tos_accepted = '';

    }
    
    private boolean isValidPassword() {
        return (password == confirmPassword);
    }


    private Boolean isValidateEmail(String email) {
        Boolean res = true;
            
        
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);

        if (!MyMatcher.matches()) 
            res = false;
        return res; 
    }

    @TestVisible private  Boolean isValidPhonenumber(String phonenumber, String countrycode) {


        if (true == String.isBlank(phonenumber)){
            return true;
        }


        // THESE ARE ALTERNATIVE VALIDATION REGEX .... PLEASE DO NOT DELETE
        //String emailRegEx = '^((((\\(\\d{3}\\))|(\\d{3}-))\\d{3}-\\d{4})|(\\+?\\d{2}((-| )\\d{1,8}){d{1,5}){0,1}1,5}))(( x| ext)\\$';
        //String emailRegEx = '/^(?:(?:\\(?(?:00|\\+)([1-4]\\d\\d|[1-9]\\d?)\\)?)?[\\-\\.\\ \\\\/]?)?((?:\\(?\\d{1,}\\)?[\\-\\.\\ \\\\/]?){0,})(?:[\\-\\.\\ \\\\/]?(?:#|ext\\.?|extension|x)[\\-\\.\\ \\\\/]?(\\d+))?$/i';
        //String emailRegex = '/^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$/gm';
        
        // andreas.meyer@salesforce.com 13.12.2016: change RegEx expressions
        String helper_phonelRegex = '(([+][1-9][0-9]{0,2})([\\s]?[(]?[1-9][0-9]+[)]?)(([\\s|\\-]?){1}[0-9]+)+)|';
        String helper_phonelRegexItaly = '(([+][1-9][0-9]{0,2})([\\s]?[(]?[0-9][0-9]+[)]?)(([\\s|\\-]?){1}[0-9]+)+)|';
        String phonelRegex;
        phonelRegex = helper_phonelRegex;
        if ( false == String.isBlank(countrycode)){
            if ('it' == countrycode.toLowerCase()){
                phonelRegex = helper_phonelRegexItaly;    
            }          
        }

        Pattern MyPattern = Pattern.compile(phonelRegex);
        Matcher MyMatcher = MyPattern.matcher(phonenumber);
        Boolean result = MyMatcher.matches();
        return result;
    }    

    private String isBlank(String data) {
        if (true == String.isBlank(data)){
            hasError = true;
            return(Label.CommunitySelfReg_ValidateGeneral);
        }
        return('');        
    }


    @TestVisible private String findUniqueNickname(String suggestedNickname){
        String retString;

        retString = '';
        if (true == String.isEmpty(suggestedNickname)){
            return retString;
        }

        // andreas.meyer@salesforce.com 19.12.2016 limit nickname to 40 characters
        if (suggestedNickname.length() > 40){
            retString = suggestedNickname.left(40);
        }
        else{
            retString = suggestedNickname;    
        }
    
        // query for existing nicknames and limit query to 1000 results
        String suggestedNicknameFuzzy = suggestedNickname + '%';
        List<User> listUsersWithNicknames = new List<User>([    SELECT Id, CommunityNickname 
                                                                FROM User 
                                                                WHERE CommunityNickname LIKE :suggestedNicknameFuzzy 
                                                                LIMIT 1000]);
        
        Set<String> setUsedUserNicknames = new Set<String>();
        if (false == listUsersWithNicknames.isEmpty()){
            // collect all found nicknames
            for (User usr: listUsersWithNicknames){
                if (false == String.isEmpty(usr.CommunityNickname)){
                    setUsedUserNicknames.add(usr.CommunityNickname);
                }
            }
            if (false == setUsedUserNicknames.isEmpty()){
                // lets try 100 different nickname variations
                for (Integer i = 0; i < 100; i++) {
                    String newNickname;
                    // andreas.meyer@salesforce.com 19.12.2016 limit nickname to 37 characters
                    if (suggestedNickname.length() > 37){
                        newNickname = suggestedNickname.left(37) + String.valueOf(i);
                    }
                    else{
                        newNickname = suggestedNickname + String.valueOf(i);
                    }

                    if (false == setUsedUserNicknames.contains(newNickname)){
                        // we found a match, assign it and break the loop
                        retString = newNickname;
                        break;
                    }
                }
            }
        }
        else{
            // we can use the given nickname
            return retString;
        }

        // return what we have
        return retString;
    }


    public PageReference registerUser() {
    
        System.debug('CommunitiesSelfRegController: registerUser started');
        clearAllErrorMessages();
        

		//Benjamin Pfahl, KUKA AG, 02.02.2017 add country phone code based on country
        if(null != helperContact.Phone){
            countryphonecodes__c mycountry_phonecode = countryphonecodes__c.getValues(helperContact.MailingCountryCode);
            if(null != mycountry_phonecode && null != mycountry_phonecode.PhoneCode__c && !helperContact.Phone.contains('+') ){
                helperContact.Phone = '+' + mycountry_phonecode.PhoneCode__c + helperContact.Phone;    
            }                
        }
        if(null != helperContact.MobilePhone){
            countryphonecodes__c mycountry_phonecode = countryphonecodes__c.getValues(helperContact.MailingCountryCode);
            if(null != mycountry_phonecode && null != mycountry_phonecode.PhoneCode__c && !helperContact.MobilePhone.contains('+')){
                helperContact.MobilePhone = '+' + mycountry_phonecode.PhoneCode__c + helperContact.MobilePhone;    
            }                
        }        
        
        
        // get custom setting
        // get custom setting
        String usernameExtensionStr = '';
        communitySelfRegSettings__c usernameExtension = communitySelfRegSettings__c.getInstance('usernameExtension');
        if(null != usernameExtension){
            if(usernameExtension.id == null) {
                usernameExtensionStr = '.kuka'; 
            }
            else{
                // read values
                usernameExtensionStr = usernameExtension.value__c;          
            }
        }
        else{
            usernameExtensionStr = '.kuka';     
        }
        // get self registration mode via custom settings
        Boolean useEmailValidation = false;
        communitySelfRegSettings__c useEmailVal = communitySelfRegSettings__c.getInstance('useEmailValidation');
        if(null != useEmailVal){
            if(useEmailVal.id == null) {
                useEmailValidation = false; 
            }
            else{
                // read values
                useEmailValidation = (useEmailVal.value__c.toLowerCase() == 'true');          
            }
        }
        else{
            useEmailValidation = false;     
        }        
      

        // custom validation
        error_firstName = isBlank(firstName);
        error_lastName = isBlank(lastName);
        //Åerror_communityNickname = isBlank(communityNickname);
        error_email = isBlank(email);
        if (true == String.isBlank(error_email)){
            if (false == isValidateEmail(email)){
                error_email = Label.CommunitySelfReg_ValidateEmailError;
                hasError = true;    
            }
        }
        error_position = isBlank(position);
        error_company = isBlank(company);
        error_street = isBlank(hMailingStreet);
        error_city = isBlank(helperContact.MailingCity);
        error_country = isBlank(helperContact.MailingCountryCode);
        //error_state = isBlank(helperContact.MailingStateCode);
        error_zip = isBlank(helperContact.MailingPostalCode);
        // andreas.meyer@salesforce.com 20.11.2016 phone is optional
        // andreas.meyer@salesforce.com 05.12.2016 phone is mandantory again
        error_phone = isBlank(helperContact.Phone);
        // see if we have a valid phonenumber
        /* if (true == String.isBlank(error_phone)){
            if (!isValidPhonenumber(helperContact.Phone,helperContact.MailingCountryCode)) {
                error_phone = Label.CommunitySelfReg_ValidatePhoneError;
                hasError = true;
            }               
        }
		*/
        // if we have a mobile number, it must match the international format
        /* 
        if (false == String.isBlank(helperContact.MobilePhone)){
            if (!isValidPhonenumber(helperContact.MobilePhone,'')) {
                error_mobile = Label.CommunitySelfReg_ValidatePhoneError;
                hasError = true;
            }  
        }
		*/


        error_salutation = isBlank(helperContact.Salutation);  
        if (true == showPassword){
            error_password = isBlank(password);
            error_passwordconfirm = isBlank(confirmPassword);            
            if (true == String.isBlank(error_password) && true == String.isBlank(error_passwordconfirm)){
                if (!isValidPassword()) {
                    error_passwordconfirm = Label.CommunitySelfReg_ValidatePassword;
                    hasError = true;
                }              
            }
        }

		/*Validation for Terms */
        /*
        if (true != tos_accepted){
                error_tos_accepted = Label.CommunitySelfReg_ValidateTandD;
                hasError = true;            
        }
         */           
        
 

        if (true == hasError){
            System.debug('CommunitiesSelfRegController: has errors, return null');
            System.debug('error_firstName = '+ error_firstName);
            System.debug('error_lastName = '+ error_lastName);
            System.debug('error_email = '+ error_email);
            System.debug('error_position = '+ error_position);
            System.debug('error_company = '+ error_company);
            System.debug('error_street = '+ error_street);
            System.debug('error_city = '+ error_city);
            System.debug('error_country = '+ error_country);
            System.debug('error_state = '+ error_state);
            System.debug('error_zip = '+ error_zip);
            System.debug('error_phone = '+ error_phone);
            System.debug('error_phone = '+ error_mobile);
            System.debug('error_salutation = '+ error_salutation);       
            System.debug('error_communityNickname = '+ error_communityNickname); 
            System.debug('error_password = '+ error_password);
            System.debug('error_passwordconfirm = '+ error_passwordconfirm);
            System.debug('error_tos_accepted = '+ error_tos_accepted);
            return null;
        } 



        String profileId = null; // To be filled in by customer.
        String roleEnum = null; // To be filled in by customer.
        String accountId = ''; // To be filled in by customer.
        
        String userName = email;
        // add usernameExtension to userName:
        userName = userName + usernameExtensionStr;

        User u = new User();
        u.Username = userName;
        u.Relation_to_KUKA__c = selectedValue;
        u.Email = email;
        u.FirstName = firstName;
        u.LastName = lastName;
        // andreas.meyer@salesforce.com 8.11.2016 DC-723 
         // Der Nickname sollte automatisch generiert werden (keine Anzeige im Formular (registration + edit) -> "Firstname" + space + "Lastname" + space + "(" + Company Name + "()" => ex. Hans Huber (BMW AG)
        //u.CommunityNickname = communityNickname; 

        // andreas.meyer@salesforce.com 28.11.2016 fallback strategy for used nickname 
        String suggestedNickname = firstName + ' ' + lastName;
        //u.CommunityNickname = firstName + ' ' + lastName;
        if (false == String.isEmpty(company)){
            String hAdd = ' (' + company + ')';
            //u.CommunityNickname +=  hAdd;   
            suggestedNickname+=  hAdd;     
        }
        u.CommunityNickname = findUniqueNickname(suggestedNickname);

        u.Phone = helperContact.Phone;
        u.MobilePhone = helperContact.MobilePhone;
        u.Title = position;
        u.CompanyName = company;
        u.Street = hMailingStreet;
        u.City = helperContact.MailingCity;
        u.PostalCode = helperContact.MailingPostalCode;
        u.CountryCode = helperContact.MailingCountryCode;
        u.StateCode = helperContact.MailingStateCode;
        u.E_Mail__c = helperPermEmail==true?'Allow':'Do not Allow';
        u.Letter__c = helperPermLetter==true?'Allow':'Do not Allow';
        u.Newsletter__c = helperPermNewsletter==true?'Allow':'Do not Allow';
        u.Telephone__c = helperPermTelefon==true?'Allow':'Do not Allow';         
        /*
        u.contactPerm_Email__c = helperContact.contactPerm_Email__c;
        u.contactPerm_Letter__c = helperContact.contactPerm_Letter__c;
        u.contactPerm_Newsletter__c = helperContact.contactPerm_Newsletter__c;
        u.contactPerm_Telephone__c = helperContact.contactPerm_Telephone__c;
        */
        u.Salutation__c = helperContact.Salutation;
        u.CustomerNumber__c = customernumber;
        u.DUNS__c = duns;
        u.Community_TermsAccepted__c = tos_accepted;

        if ( true == String.isBlank(u.CustomerNumber__c )){
            u.CustomerNumber__c = '-1';
        }

        // 17.01.2017 andreas.meyer@salesforce.com DC-1248 add External Community
        u.Users_Organisation__c = CommunitiesSelfRegController.USER_ORG_EXTERNAL_COMMUNITY;
        
        // 14.3.2017 Arokia.Joseph Redirect functionality
        if(true == helperSource){
           u.UserRegistrationSource__c = registrationSource;
        }
     

        //u.ProfileId = profileId;
        // andreas.meyer@salesforce.com 17.10.2016: add Role "Community_User"
        // u.UserRoleId = '00E4E000000NwAL';
        //u.ProfileId = '00e58000000ILS7';
        
        String userId;

        // bejanmin.pfahl@kuka.com 05.12.2016: overwrite empty accountid if there is a match
        string accountoverwrite = checkautoassign_connect(hexternalSfId, helperKukaconnect);        
        if (accountoverwrite != ''){ 
            accountId = accountoverwrite;
        }
        
        
        try {

            if (true == useEmailValidation){
                //userId = Site.createExternalUser(u, accountId, password, true);        
                userId = Site.createExternalUser(u, accountId, null, true);        
            }
            else{
                userId = Site.createExternalUser(u, accountId, password);    
            }
            
        }

        catch(Site.ExternalUserCreateException ex) {

            String eceMessage = ex.getMessage();
            if(eceMessage.containsIgnoreCase('nickname already exists')){
               ApexPages.Message errorDup = new ApexPages.Message(ApexPages.severity.INFO,Label.CommunitySelfReg_CustomErr_Nickname);
               ApexPages.addMessage(errorDup);
            }
            else if(eceMessage.containsIgnoreCase('already logged in')){
               ApexPages.Message errorDup = new ApexPages.Message(ApexPages.severity.INFO,Label.CommunitySelfReg_CustomErr_UserExists);
               ApexPages.addMessage(errorDup);            
            }else{
                List<String> errors = ex.getDisplayMessages();
                for (String error : errors)  {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
                }
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));                     
            }            
      
            hasError = true;
            // This message is used for debugging. Do not display this in the UI to the end user.
            // It has the information around why the user creation failed.
            System.debug(ex.getMessage());
        } 
        catch(Exception e){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'general Exception')); 
           String eceMessage = e.getMessage();
            if(eceMessage.containsIgnoreCase('nickname already exists')){
               ApexPages.Message errorDup = new ApexPages.Message(ApexPages.severity.INFO,Label.CommunitySelfReg_CustomErr_Nickname);
               ApexPages.addMessage(errorDup);
            }
            else if(eceMessage.containsIgnoreCase('already logged in')){
               ApexPages.Message errorDup = new ApexPages.Message(ApexPages.severity.INFO,Label.CommunitySelfReg_CustomErr_UserExists);
               ApexPages.addMessage(errorDup);           
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));                     
            }              
            hasError = true; 
        }
                      
        if (userId != null) { 
        	
        	if (target != null ){
        		PageReference page =  new PageReference(httpPrefix+target);
        		System.debug('CommunitiesSelfRegController: registerUser ended with setRedirect to target url passed as parameter');
                page.setRedirect(true);
                return page;
        	} 
        	/*else if (true == helperSource && sourceURL != null ){
        		PageReference page =  new PageReference(sourceURL);
        		System.debug('CommunitiesSelfRegController: registerUser ended with setRedirect to source page url passed as parameter');
                page.setRedirect(true);
                return page;
        	}*/
            else if (true == useEmailValidation){
                // redirect to finish page
                PageReference page = System.Page.KUKA_communitiesCompletePage;
                //page.getParameters().put('customername',u.Salutation__c + ' ' + u.LastName);
                page.getParameters().put('customername',u.LastName);
                page.getParameters().put('customersalutation',u.Salutation__c);
                page.getParameters().put('source',registrationSource);
                System.debug('CommunitiesSelfRegController: registerUser ended with setRedirect to KUKA_communitiesCompletePage');
                page.setRedirect(true);
                return page;               
            }
            else{
                if (password != null && password.length() > 1) {
                    System.debug('CommunitiesSelfRegController: registerUser ended with Site.login');
                    return Site.login(userName, password, ApexPages.currentPage().getParameters().get('startURL'));
                }
                else {
                    PageReference page = System.Page.CommunitiesSelfRegConfirm;
                    System.debug('CommunitiesSelfRegController: registerUser ended with setRedirect');
                    page.setRedirect(true);
                    return page;
                }                
            }
        }

        hasError = true;
        System.debug('CommunitiesSelfRegController: registerUser ended without redirect');
        return null;
    }
}