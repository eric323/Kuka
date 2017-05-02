public without sharing class APTSMD_SKORegistration {
    
    public class CustomException extends Exception{}
    
    
    public string message {get;set;}
    public string messageConfirm {get;set;}
    public string messageEmail {get;set;}
    public string appId {get;set;}
    public string rpId {get;set;}
    
    public list<SelectOption> countries { get; private set; }
    public list<SelectOption> countriesLabels { get; private set; }
    
    public APTSMD_SKORegistration(APTSMD_SKORatePlansTable ctrl){
        this();
        //ctrl.registrationController= this;
    }
    
    public APTSMD_SKORegistration() {
        countries = APTSMD_Utils.getCountryList2();
        countriesLabels = new list<SelectOption>();
        for (Selectoption c :countries){
            countriesLabels.add(new selectOption(c.getLabel(),c.getLabel()));
        }
        
        appId = Apexpages.currentPage().getParameters().get('id');
        rpId = Apexpages.currentPage().getParameters().get('rpId');
        message = '';
        messageConfirm = '';
        messageEmail = '';
        paidSubscription = false;
        registrationSuccess = false;
    }
    
    public APTSMD_SKORegistration(APTSMD_SKOBootStrapTemplateController templateCon){
        this();
    }
    
    /*public VFC02_INeoRegistration(VFC06_Ineo_Subscription acon) {
        this();
    }*/

    public Contact con {
                            get { 
                                if (con == null){
                                    //con = new Contact(RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'StdContact'].Id);
                                }
                                return con;
                            }set;}

    public Account acc { get{ 
                            if (acc == null){
                                 acc = new Account(
                                    BillingCity  = 'Please fill Details',
                                    BillingPostalCode = 'Please fill Details', 
                                    BillingStreet = 'Please fill Details',
                                    BillingState = 'Please fill Details',
                                    BillingCountry = 'United States'
                                 ); 
                            }
                            return acc; 
                        } 
                        set; }
    public Boolean acceptTerms { get; set; }
    public Boolean paidSubscription { get; set; }    
    public Boolean registrationSuccess { get; private set; }
    
    //public transient String message { get; private set; }
    
    public PageReference submit() {

        APTSMD_Utils.log('**** Ineo-Registration Submit Executing ****');
        //Utils.log('submit: start');
        //Utils.log('isUniqueEmail @ submit: ' +isUniqueEmail(con.email));        
        registrationSuccess = false;                      
        boolean verificationSuccess = true;
        if (acceptTerms==null || !acceptTerms) {
            verificationSuccess = false;
            messageConfirm = 'Please read and accept the terms to register.';
        }else{
            messageConfirm='';
        }
        
        if (!isUniqueEmail(con.email)) {
            verificationSuccess = false;
            messageEmail = 'Please choose a different email - user with this email already exist (' + con.Email + ')';
        }else{
            messageEmail ='';
        }
        
        if (!verificationSuccess){
            return null;
        }
        
        System.SavePoint sp = Database.setSavepoint();            
        try {
            /*Terms_Conditions__kav generalTerms = APTSMD_Utils.getCurrentTermsNAgreement('generalTerms', APTSMD_Utils.currentLanguage);
            
            acc.SameAsBillingAddress__c = true;
            //Modified By Nikhil Sana on 10/28/2014 - to identify the account was created from portal
            acc.iNeo_Portal_Created__c = true;
            string ownerId = APTSMD_Utils.getOwnerId();            
            //APTSMD_Utils.log('acc @ submit @ VFC02_INeoRegistration:' +acc);

            //Modified By Nikhil Sana on 10/14/2014 
            //As per business requirement when the Account was prospect and it converts to Customer, it needs to go to CIM queue, below field controls the queue. 
            if(paidSubscription){
                acc.CIM_Review_Required__c = true;
            }

            //APTSMD_Utils.log('acc before insert:'+acc);
            try{
                insert acc;
            }catch (Exception ex) {
            message = 'Something went wrong with your account: ' + ex.getMessage();
            APTSMD_Utils.log('submit', ex);
            Database.rollback(sp);
            registrationSuccess = false;
            acc = acc.clone(); 
            //con = con.clone();
        }          
            if(ownerId != null){
                acc.OwnerId =  ownerId;
            }
            // TODO: this could cause the issue with filling this field on several forms!
            List<Country__c> countryList = [select Id from Country__c where name=: con.MailingCountry limit 1];
            if(countryList.size() > 0)
                acc.BillingCountry__c = countryList[0].Id;

            //Modified by Nikhil Sana on 9/9/2014
            //Changed the RecordType to NUSA_Default
            list<RecordType> accRecType = [select id from RecordType where SobjectType='Account' And DeveloperName='NUSA_Default'];
            
            if (!APTSMD_Utils.isEmpty(accRecType)){
                acc.RecordTypeId=accRecType[0].id;
            }
            acc.ApprovalStatus__c = 'Not Submitted';
            //   acc.AccountType__c = 'myNeopost';
            //APTSMD_Utils.log('accII @ submit @ VFC02_INeoRegistration:' +acc);
            update acc;            
            //APTSMD_Utils.log('submit: account created: ' + acc);
            if(ownerId != null){
                con.OwnerId =  ownerId;
            }
            // Need to make sure con.account is empty, before inserting the account.
            // otherwise therse a DML exception regarding specifing accountID and account.
            con.account = null;
            con.AccountId = acc.Id;
            con = con.clone();
            Country__c countTemp = [select id, name from Country__c where CountryCode__c =: APTSMD_Utils.currentCountry limit 1];
            con.Country__c = countTemp.Id;
            con.Status__c='Active';
            con.Type__c = 'Bill To & Sold To';
            con.LeadSource='myNeopost';
            con.TCs_Acceptance__c = true;
            con.Version_number__c = generalTerms.Version_number__c;
            //ACC added to make the subscription work
            con.Primary_Contact__c = true;

            //Modified By Nikhil Sana on 10/10/2014
            //Zuora needs MailingState and MailingCountry fields to create a subscription
            con.MailingState ='Connecticut';
            con.MailingCountry = 'United States';
            con.MailingCountry__c = con.MailingCountry;

            //Modified By Nikhil Sana on 10/10/2014
            //Before Creating Subscription we need to make sure that contact was created successfully
            try{
                insert con;
            }catch (Exception ex) {
                message = 'Something went wrong with your contact: ' + ex.getMessage();
                APTSMD_Utils.log('submit', ex);
                Database.rollback(sp);
                registrationSuccess = false;
                acc = acc.clone(); 
                con = con.clone();
            }
                        
            User u = new User(
                UserName  = con.Email,
                Email     = con.Email,
                phone = con.Phone,
                CompanyName = acc.Name,
                CommunityNickname = con.FirstName + Math.rint(Math.random() * 1000),
                FirstName = con.FirstName,
                LastName  = con.LastName,
                Opco__c = con.MailingCountry,
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'iNeo Community Admin' limit 1].Id
            );
            APTSMD_Utils.log('submit: create portal user: '+ con.AccountId);

            Id userId = Site.createPortalUser(u, con.AccountId, null, true);
            APTSMD_Utils.log('userId @ submit: ' + userId);
            
            if (userId == null) {
                messageEmail = 'No Available licenses left. please contact your admin';
                Database.rollback(sp);
                acc = acc.clone(); 
                con = con.clone();
                return null;
            }*/
            
        } catch (Exception ex) {
            message = 'Error: unexpected error occured: ' + ex.getMessage();
            APTSMD_Utils.log('submit', ex);
            Database.rollback(sp);
            registrationSuccess = false;
            acc = acc.clone(); 
            con = con.clone();
        }
        
        
        Pagereference p;
        /*
        if(appId != null && appId != '' && rpId != null &&  rpId != ''){
            zqu__ZProduct__c currentApp = APTSMD_Utils.getAppByID(appId);

            String registeredProductRatePlanName ;= EncodingUtil.urlEncode(
                                                                            [select name from  zqu__ProductRatePlan__c where id =:rpId limit 1][0].name,
                                                                            'UTF-8'
                                                                        );
            String freeTrialURL = '/'+APTSMD_Utils.currentCountry + '/' + APTSMD_Utils.currentLanguage + '/Software&Apps/'+ currentApp.AppCategory__c +'/' +  currentApp.ZProduct_Contents__r[0].Name + '/registerFreeTrial/' + registeredProductRatePlanName + '/C'+ con.ID;         
            p = new Pagereference(freeTrialURL);
        }
        */
        registrationSuccess = true;
        /* Originally this section set the con and acc to null. This was used for something but hads long been depriciated.
        *  I'm not 100% that this is not needed, so be careful. 18.06.14
            con = null; 
            acc = null;
        */
        con.account = acc;
        APTSMD_Utils.log('**** Ineo-Registration Submit Exited ****');
        return p;
    }

    private boolean isUniqueEmail(String inputEmail){
        //Modified by Nikhil Sana on 10/10/2014
        //Changed the email validation from Contact email to Username on User Object
        list<User> sameEmailContact = [select id from User c where UserName=:inputEmail];
        
        return sameEmailContact.size()==0;
    }


}