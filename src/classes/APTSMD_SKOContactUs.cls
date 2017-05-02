public without sharing class APTSMD_SKOContactUs {
    
    public Lead currentLead {get;set;}
    public Contact currentContact{get;set;}
    public Account currentAccount{get;set;}
    public Case caseInfo{get;set;} // remove this
    public Opportunity currentOpportunity{get;set;} 
    public string preferedCommunication{get;set;}
    public list<SelectOption> countries { get; private set; }
    public List<SelectOption> zproductsOptions {get;set;}
    public List<SelectOption> interests{get;set;}
    public String selectedInterest{get;set;}
    public String selectedCountry{get;set;} 
    public String  opportunityDescription{get;set;}
    
    public boolean isFormSubmitted {get;set;}
    public boolean isLoggedIn{get;set;}
    
    public string contactUsErrMessage {get;set;}
     
    public APTSMD_SKOContactUs(APTSMD_SKOBootStrapTemplateController mainPageController){
        this();
    }
    
    public static List<SelectOption> getTheCountryList() {
        List<SelectOption> options = new List<SelectOption>();
        List<APTSMD_Country__c> countrylist = APTSMD_Utils.getAvailableCountries();
        for(APTSMD_Country__c country : countrylist){
            options.add(new SelectOption(country.name, country.name));
        }
        
        return options;
    }
    
    public APTSMD_SKOContactUs() {
        countries = getTheCountryList();
        /*list<Schema.PicklistEntry> interestValues = Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap().get('Interest__c').getDescribe().getPickListValues();
        System.debug('---interestValues  = '+ interestValues );
        interests = new List<SelectOption>();
        //interests.add(new SelectOption('','-- None --'));
        for(Schema.PicklistEntry val: interestValues){
            interests.add(new SelectOption(val.getLabel(),val.getValue()));
        } */  
        selectedCountry = '';
        selectedInterest ='';
        contactUsErrMessage = '';
        
        isFormSubmitted = false;    
        isLoggedIn = APTSMD_Utils.isLoggedIn();
        
        string CountryCode = APTSMD_Utils.currentCountry;
        string langageName = APTSMD_Utils.currentLanguage;
        
     //   APTSMD_Utils.log('CountryCode @ VFC08_ContactUs:' +CountryCode);
        // No country found - template controller will redirect to country selection.
        if (CountryCode==null){
            return;
        }

     //   APTSMD_Utils.log('ContactsUs@@CountryCode:'+CountryCode);

        APTSMD_Country__c c =[select APTSMD_CountryCode__c, id,Name from APTSMD_Country__c where APTSMD_CountryCode__c=:CountryCode limit 1];
        try{
            String recordTypeName =  '%' + String.ValueOf(c.Name).deleteWhitespace();
            //currentLead = new Lead(RecordTypeId =[SELECT Id FROM RecordType WHERE DeveloperName LIKE :recordTypeName limit 1].Id);
            currentLead = new Lead();
        }catch (Exception e){
            currentLead = new Lead();
            //currentLead = new Lead(RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Standard_Lead'].Id);
        }
        
        if(c != null){
            currentLead.Country = c.name;
            //currentLead.Opco__c=c.Name;
            //currentLead.ProductInterest__c = Label.LeadProductIntrestContactUs;
            currentLead.LeadSource='Portal';
        }
        
        string googleID = APTSMD_Utils.getCookie('googleAdID');
        if (googleID!=null){
            //currentLead.Online_marketing_ad_ID__c = googleID;
            //currentLead.Online_marketing_ad_Source__c='Google Ad';
        }
        
        
        /*List<zqu__ZProduct__c>  zproducts = [Select(Select Id, IsDeleted, Name, Langage__c, Langage__r.Language_Code__c , ZProduct__c,Short_Description__c, title__c
                            From ZProduct_Contents__r where Langage__r.Language_Code__c  =: langageName),
                     z.zqu__ZuoraId__c, z.zqu__SKU__c, z.zqu__EffectiveStartDate__c, z.zqu__EffectiveStartDateTEXT__c, z.zqu__EffectiveEndDate__c, z.zqu__Deleted__c, 
                     z.zqu__EffectiveEndDateTEXT__c, z.zqu__Description__c, z.zqu__Currency__c, z.zqu__Active__c, z.OwnerId, z.OPCO__c, z.Name, z.Id, z.AvailableInSalesforceCom__c,
                     z.Image__c, z.Image_URL__c, z.Susbscribe_Image__c, z.Susbscribe_Image_URL__c, country__r.countrycode__c, Publication_Date__c
                     From zqu__ZProduct__c z
                     where zqu__Deleted__c =: false and country__r.countrycode__c =: CountryCode and Publication_Date__c <= TODAY]; 
                     
        //zproductsOptions = new list<SelectOption>{ new SelectOption('', '--None--') };
        zproductsOptions = new list<SelectOption>();
        
        
        
        for (zqu__ZProduct__c product : zproducts)
            if(product.ZProduct_Contents__r != null && product.ZProduct_Contents__r.size() > 0)
                zproductsOptions.add(new SelectOption(product.ZProduct_Contents__r[0].Name, product.ZProduct_Contents__r[0].Name));
                
        zproductsOptions.add(new SelectOption('Other', 'Other'));
        */
        if (isLoggedIn){
            setDataForLoggedUser();
        } 
    }
    
    private void setDataForLoggedUser(){
        //caseInfo = new Case();
        currentOpportunity = new Opportunity();
        string userId = Userinfo.getUserId();
        User u = [Select ContactId From User Where User.Id =: userId Limit 1];
        if (u == null ){
            return;
        }
        string contactId = u.ContactId;
        currentContact = [Select Id,Email,Phone,Salutation,FirstName,LastName,AccountId, title From Contact Where Contact.Id =: contactId Limit 1];
        //Contact acctId = [Select AccountId From Contact Where Contact.Id =: contactId Limit 1];
        currentAccount = [Select name, BillingPostalCode, BillingState, BillingCountry From Account Where Account.Id =: currentContact.AccountId Limit 1];
    }
    
    private void addMessage(string mes) {
        if (contactUsErrMessage != ''){
            contactUsErrMessage += '\n';
        }
        contactUsErrMessage += mes;
    }
    
    private void setOpportunityInfo(){
    //  APTSMD_Utils.verfiyAccountMandatoryAdressFields();
    //      APTSMD_Utils.log('currentAccount @ setOpportunityInfo:' +currentAccount);
        update currentAccount;

        System.Cookie cookie = Apexpages.currentPage().getCookies().get('googleAdID');
        if(cookie != null){
            //currentOpportunity.Online_marketing_ad_Source__c = 'Google';        
            //currentOpportunity.Online_marketing_ad_ID__c = cookie.getValue();
        }
        currentOpportunity.AccountId = currentAccount.Id;
        currentOpportunity.Description = opportunityDescription;
        //currentOpportunity.Interest__c = selectedInterest;
        currentOpportunity.StageName = '01 - New';
        currentOpportunity.ForecastCategoryName = 'Omitted';
        //currentOpportunity.DistributionChannel__c = 'myNeopost';
        currentOpportunity.OwnerId = currentAccount.OwnerId;
        currentOpportunity.CloseDate = Date.today().addDays(30);
        //String interest = currentOpportunity.Interest__c == null ? '' : currentOpportunity.Interest__c;
        //currentOpportunity.Name = 'myNeopost - ' + interest ; 
        //currentOpportunity.RecordTypeId = [Select Id From RecordType Where SobjectType = 'Opportunity' And DeveloperName = 'NUSA_Default'].Id;
        //currentOpportunity.Related_Contact__c = currentContact.Id;
        
        upsert currentOpportunity;
     //   system.debug('## currentOpportunity ' + currentOpportunity);
        /*string ownerId = APTSMD_Utils.getOwnerId();
        if(ownerId != null)
            caseInfo.ownerId = ownerId;
        caseInfo.ContactId = currentContact.Id;
        caseInfo.Subject = 'Request Info: '+ caseInfo.iNeo_application__c;
        
        caseInfo.Description = 'Salutation: '+currentContact.Salutation +'\n First Name: ' + currentContact.FirstName +'\n LastName: ' + currentContact.LastName +
            '\n Title: ' + currentContact.Title + '\n Email: '+currentContact.Email + '\n Phone: ' + currentContact.Phone + '\n Account Name: ' + currentAccount.Name +
            '\n Country: ' + currentAccount.BillingCountry +  '\n Billing State/Province: '+ currentAccount.BillingState+
            '\n Zip/Postal Code: ' + currentAccount.BillingPostalCode + '\n Number of Employees: ' + currentAccount.Number_of_Employees__c +
            '\n Prefered communication channel: '+preferedCommunication;
        upsert caseInfo;*/
    }

    
    //Old sendInfo posting routine
    public PageReference sendInfo() {
        
        try {
            string ownerId = APTSMD_Utils.getOwnerId();
            
            if(ownerId != null){
                if (isLoggedIn){
                    currentAccount.ownerId = ownerId;
                    currentContact.OwnerId = ownerId;
                }else{
                    currentLead.ownerId = ownerId;
                }
            }
            if (isLoggedIn){                                
                setOpportunityInfo();
            }
            else{               
                APTSMD_Country__c curCountry = [Select APTSMD_Opco__c From APTSMD_Country__c Where APTSMD_CountryCode__c =: APTSMD_Utils.currentCountry limit 1];
                List<RecordType> leadRt = [Select Id From RecordType Where SobjectType = 'Lead' And DeveloperName =: APTSMD_Utils.currentCountry];
                if(!leadRt.isEmpty()){
                    //currentLead.RecordTypeId = leadRt[0].Id;
                }       
                currentLead.Country = selectedCountry;      
                //currentLead.ProductInterest__c = 'Digital offers';
                currentLead.LeadSource = 'myNeopost';
                //currentLead.Opco__c = curCountry.Opco__c;
                //currentLead.DistributionChannel__c = 'myNeopost';
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.useDefaultRule = true;
                currentLead.setOptions(dmo);
                upsert currentLead;
                system.debug('## currentLead' + currentLead);
            }
            
            isFormSubmitted = true;
            contactUsErrMessage = '';
            //addMessage(Label.ContactUsForm_SentOk);
            //addMessage(Label.ContactUsForm_24hourNotify);
        }
        catch (Exception ex) {
            isFormSubmitted = false;
            addMessage('Error sending info: ' + ex.getMessage());
//            APTSMD_Utils.log('save', ex);
            
        }
       
        return null;
        
    }

}