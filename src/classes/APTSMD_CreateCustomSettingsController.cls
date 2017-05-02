public with sharing class APTSMD_CreateCustomSettingsController{
    public void createAllCustomSettings(){
        mobileCPQSetting();
        complyCustomPropertiesSetting();
        complySystemPropertiesSetting();
        configCustomClassesSetting();
        selectBundleOptionsSetting();
        selectConfigProductsSetting();
        configSystemPropertiesSetting();
        //docGenSystemPropertiesSetting();
        //echoSignSetting();
        //docuSignSystemPropertiesSetting();
        installedProductsSetting();
        preSalesConfigSetting();
        preSalesECommerceConfigSetting();
        proposalSystemPropertiesSetting();
        configFlowSetting();
        updateDisplayColumnSetting();
        updateDisplayActionSetting();
        createAccountContact();
        
        
    }
    
    public static void mobileCPQSetting(){
        try{
            Apttus_Mobile_CPQ_Setting__c customSettingExisting = Apttus_Mobile_CPQ_Setting__c.getValues('Mobile Quote Default');
            
            if(customSettingExisting == null){
                Apttus_Mobile_CPQ_Setting__c customSetting = new Apttus_Mobile_CPQ_Setting__c(Name = 'Mobile Quote Default', Email_Template__c = 'Present Proposal', Proposal_Contact_Name__c = 'Diego Francis', Proposal_Name__c = 'Mobile Quote', Proposal_Template_Name__c = 'Tier1 Systems Proposal');          
                insert customSetting;
            }
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }
    
    public static void complyCustomPropertiesSetting(){
        try{
            Apttus__ComplyCustomProperties__c customSettingExisting = Apttus__ComplyCustomProperties__c.getValues('Apttus_Proposal__Proposal__c');
            
            if(customSettingExisting == null){
                Apttus__ComplyCustomProperties__c customSetting = new Apttus__ComplyCustomProperties__c(Name = 'Apttus_Proposal__Proposal__c', Apttus__DocAssemblyRuleFieldSetName__c = 'Apttus_Proposal__QuoteDocAssemblyFilterFields');          
                insert customSetting;
            }
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }
    
    public static void complySystemPropertiesSetting(){
        try{
            Apttus__ComplySystemProperties__c customSettingExisting = Apttus__ComplySystemProperties__c.getValues('System Properties');
            
            if(customSettingExisting == null){
                Apttus__ComplySystemProperties__c customSetting = new Apttus__ComplySystemProperties__c(Name = 'System Properties', Apttus__InstanceUrl__c = System.URL.getSalesforceBaseUrl().toExternalForm(), Apttus__MergeWebserviceEndpoint__c = 'https://mergews.apttus.net/cgi-bin/MergeServer/Bin/MMCGI.exe', Apttus__MergeCallTimeoutMillis__c = 60000, Apttus__DefaultOpportunityAgreementOwner__c = 'Opportunity Owner', Apttus__EnableVersionControl__c = true/*, Apttus_CMDSign__AutoSelectAttachment__c = true, Apttus_CMDSign__EnableDocumentPreviewInDocuSign__c = true, Apttus_CMDSign__FieldNameAutoSelectRecipient__c = 'Apttus__Primary_Contact__c'*/);          
                insert customSetting;
            }
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }
    
    public static void configCustomClassesSetting(){
        try{
            Apttus_Config2__ConfigCustomClasses__c customSettingExisting = Apttus_Config2__ConfigCustomClasses__c.getValues('Custom Classes');
            
            if(customSettingExisting == null){
                Apttus_Config2__ConfigCustomClasses__c customSetting = new Apttus_Config2__ConfigCustomClasses__c(Name = 'Custom Classes', Apttus_Config2__CartApprovalCallbackClass__c = 'Apttus_CQApprov.CartApprovalCallback', Apttus_Config2__DealOptimizerCallbackClass__c = 'Apttus_CPQOpti.DealMaximizerCallback');          
                insert customSetting;
            }
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }
    
    public static void selectBundleOptionsSetting(){
        try{
            Apttus_Config2__ConfigSelectBundleOptionsSettings__c customSettingExisting = Apttus_Config2__ConfigSelectBundleOptionsSettings__c.getValues('Primary Settings');
            
            if(customSettingExisting == null){
                Apttus_Config2__ConfigSelectBundleOptionsSettings__c customSetting = new Apttus_Config2__ConfigSelectBundleOptionsSettings__c(Name = 'Primary Settings', Apttus_Config2__MainSectionRatio__c = '0:70:30', Apttus_Config2__ShowOptionQuantity__c = true);          
                insert customSetting;
            }
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }
    
    public static void selectConfigProductsSetting(){
        try{
            Apttus_Config2__ConfigSelectConfigProductsSettings__c customSettingExisting = Apttus_Config2__ConfigSelectConfigProductsSettings__c.getValues('Primary Settings');
            
            if(customSettingExisting == null){
                Account testAccount  = [SELECT id,name FROM Account LIMIT 1];
                Attachment attach = new attachment();
                attach.Body = Blob.valueOf('test');
                attach.Name = String.valueOf('test.txt');
                attach.ParentId = testAccount.id;
                insert attach;
                
                Apttus_Config2__ConfigSelectConfigProductsSettings__c customSetting = new Apttus_Config2__ConfigSelectConfigProductsSettings__c(Name = 'Primary Settings', Apttus_Config2__ListedProductsColumn2__c = 'Description', Apttus_Config2__ListedProductsColumn3__c = 'Long_Description__c', Apttus_Config2__MainSectionRatio__c = '20:60:20', Apttus_Config2__CartListItemDescriptionField__c = 'Long_Description__c', Apttus_Config2__ShowCartIcon__c = true, Apttus_Config2__ShowProductIconCartDetailView__c = true, Apttus_Config2__ShowRecommendedProductsCartView__c = true, Apttus_Config2__ShowSelectedProductsInConfigOptions__c = true, Apttus_Config2__HideHelpMeChoose__c = true, Apttus_Config2__CarouselCategoryLevel__c = 99, Apttus_Config2__HideLineItemAttributeDetails__c = true, Apttus_Config2__HideDefaultOptionsInDescription__c = true, Apttus_Config2__EnableCategoryFilter__c = true, Apttus_Config2__HideNarrowYourSearch__c = true, Apttus_Config2__SearchQueryLimit__c = 1000, Apttus_Config2__ShowQuantity__c = true, Apttus_Config2__DisableAddToCartOnClick__c = true,Apttus_Config2__CarouselDefaultIcon__c=attach.id);          
                insert customSetting;
            }
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }
    
    public static void configSystemPropertiesSetting(){
        try{
            Apttus_Config2__ConfigSystemProperties__c customSettingExisting = Apttus_Config2__ConfigSystemProperties__c.getValues('System Properties');
            
            if(customSettingExisting == null){
                Apttus_Config2__ConfigSystemProperties__c customSetting = new Apttus_Config2__ConfigSystemProperties__c(Name = 'System Properties', Apttus_Config2__EnableAggregatePricing__c = true, Apttus_Config2__EnableMatrixPricingForOptions__c = true, Apttus_Config2__GuidePageDefault__c = 'ConfigFlow', Apttus_Config2__HideSubtotalsInCart__c = true, Apttus_Config2__InstanceUrl__c = System.URL.getSalesforceBaseUrl().toExternalForm(), Apttus_Config2__MiscChargeTypes__c = 'Sales Tax\r\nShipping & Handling', Apttus_Config2__OptionsPageDefault__c = 'Apttus_Config2__SelectConfigOptionsDetailView', Apttus_Config2__ProductAttributeDetailPage__c = 'Apttus_Config2__ProductAttributeDetail3', Apttus_Config2__SearchAttributeValuePage__c = 'Cart', Apttus_Config2__SearchCategoryDefault__c = 'AllCategories', Apttus_Config2__TotalingGroupType__c = 'Category', Apttus_Config2__ViewCartCustomFields2__c = 'Apttus_Config2__AttributeValueId__r.HDD_OS_Type__c\r\nApttus_Config2__AttributeValueId__r.OS_or_License_Type__c\r\nApttus_Config2__AttributeValueId__r.Preconfigured_Packages__c', Apttus_Config2__ViewCartPage__c = 'Apttus_Config2__CartDetailView', Apttus_Config2__MaxAdjustmentLines__c = 3, Apttus_Config2__MaxConstraintRulesRoundTrip__c = 3, Apttus_Config2__SkipReview__c = true, Apttus_Config2__ActionsColumnPosition__c = 'Right', Apttus_Config2__DefaultProductsPage__c = 'Apttus_Config2__SelectConfigProductsFilterView', Apttus_Config2__QuantityFieldPrecision__c = 0, Apttus_Config2__TabViewInConfigureBundle__c = true, Apttus_Config2__AdminUser__c = 'Admin User', Apttus_Config2__DirectConfigureAssetActions__c = 'Amend, Cancel', Apttus_Config2__EnableLocation__c = true, Apttus_Config2__AutoFinalizeOnCartApproval__c = true, Apttus_Config2__AutoSyncOnCartApproval__c = true, Apttus_Config2__CSSOverride__c = 'customcss', Apttus_Config2__DisplayCartActionsAsDropdown__c = true, Apttus_Config2__FixedButtonBar__c = true, Apttus_Config2__ResolveConfigurationPageDefault__c = 'Apttus_Config2__ResolveConfig', Apttus_Config2__SaveOnAllActions__c = true, Apttus_Config2__EnableFieldExpression__c = true);          
                insert customSetting;
            }
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }
    
    /*public static void docGenSystemPropertiesSetting(){
        try{
            Apttus_DocGen__DocGenSystemProperties__c customSettingExisting = Apttus_DocGen__DocGenSystemProperties__c.getValues('System Properties');
            
            if(customSettingExisting == null){
                Apttus_DocGen__DocGenSystemProperties__c customSetting = new Apttus_DocGen__DocGenSystemProperties__c(Name = 'System Properties', Apttus_DocGen__MergeWebserviceEndpoint__c = 'https://mwsdev.apttus.net/cgi-bin/V4/MergeServer/Bin/MMCGI.exe', Apttus_DocGen__MergeCallTimeoutMillis__c = 60000);          
                insert customSetting;
            }
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }*/
    
   /*
    public static void echoSignSetting(){
        try{
            echosign_dev1__SIGN_Settings__c customSettingExisting = echosign_dev1__SIGN_Settings__c.getOrgDefaults();
            
            if(customSettingExisting == null){
                echosign_dev1__SIGN_Settings__c customSetting = new echosign_dev1__SIGN_Settings__c(echosign_dev1__Callback_URL_EchoSign_to_Salesforce_Site__c = 'https://apttusdemo.secure.force.com/EchoSignCallback', echosign_dev1__Add_Signed_PDF_to_Attachment_List__c = true, echosign_dev1__Enable_Hosted_Signing_Field__c = true, echosign_dev1__Wipe_Agreement_Password__c = true);          
                insert customSetting;
            }
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }*/
    
    /*public static void docuSignSystemPropertiesSetting(){
        try{
            Apttus_DocuApi__DocuSignSystemProperties__c customSettingExisting = Apttus_DocuApi__DocuSignSystemProperties__c.getValues('System Properties');
            
            if(customSettingExisting == null){
                Apttus_DocuApi__DocuSignSystemProperties__c customSetting = new Apttus_DocuApi__DocuSignSystemProperties__c(Name = 'System Properties', Apttus_DocuApi__CompletedEnvelopeSyncInterval__c = '30', Apttus_DocuApi__DocuSignServer__c = 'DEMO', Apttus_DocuApi__EnvelopeStatusSyncInterval__c = '30', Apttus_DocuApi__MaxNumberOfSignerRole__c = 10, Apttus_DocuApi__RecipientStatusSyncInterval__c = '30', Apttus_DocuApi__SelectFirstDocumentDefault__c = true, Apttus_DocuApi__AddRecipientsEnabled__c = true, Apttus_DocuApi__AddAttachmentsEnabled__c = true, Apttus_DocuApi__SendForSignatureEnabled__c = true, Apttus_DocuApi__ViewInDocuSignEnabled__c = true, Apttus_DocuApi__HttpTimeout__c = 30000);          
                insert customSetting;
            }
            
            customSettingExisting = Apttus_DocuApi__DocuSignSystemProperties__c.getValues('ProposalWorkflow');
            
            if(customSettingExisting == null){
                Apttus_DocuApi__DocuSignSystemProperties__c customSetting = new Apttus_DocuApi__DocuSignSystemProperties__c(Name = 'ProposalWorkflow', Apttus_DocuApi__CompletedEnvelopeSyncInterval__c = '30', Apttus_DocuApi__DocuSignServer__c = 'DEMO', Apttus_DocuApi__EnvelopeStatusSyncInterval__c = '30', Apttus_DocuApi__MaxNumberOfSignerRole__c = 4, Apttus_DocuApi__RecipientStatusSyncInterval__c = '30', Apttus_DocuApi__SelectFirstDocumentDefault__c = true, Apttus_DocuApi__HttpTimeout__c = 30000, Apttus_DocuApi__ProductionEnvironment__c = true, Apttus_DocuApi__DocuSignEnvelopeStatusSubscriber__c = 'DemoSubscriber2');          
                insert customSetting;
            }
            
            customSettingExisting = Apttus_DocuApi__DocuSignSystemProperties__c.getValues('CM Workflow');
            
            if(customSettingExisting == null){
                Apttus_DocuApi__DocuSignSystemProperties__c customSetting = new Apttus_DocuApi__DocuSignSystemProperties__c(Name = 'CM Workflow', Apttus_DocuApi__CompletedEnvelopeSyncInterval__c = '1', Apttus_DocuApi__DocuSignServer__c = 'DEMO', Apttus_DocuApi__EnvelopeStatusSyncInterval__c = '1', Apttus_DocuApi__MaxNumberOfSignerRole__c = 10, Apttus_DocuApi__RecipientStatusSyncInterval__c = '1', Apttus_DocuApi__SelectFirstDocumentDefault__c = true, Apttus_DocuApi__HttpTimeout__c = 30000, Apttus_DocuApi__DocuSignEnvelopeStatusSubscriber__c = 'Apttus_CMDSign.CMDocuSignEnvelopeStatusSubscriber2');          
                insert customSetting;
            }
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }*/
    
    public static void installedProductsSetting(){
        try{
            Apttus_Config2__InstalledProductsSettings__c customSettingExisting = Apttus_Config2__InstalledProductsSettings__c.getValues('Primary Settings');
            
            if(customSettingExisting == null){
                Apttus_Config2__InstalledProductsSettings__c customSetting = new Apttus_Config2__InstalledProductsSettings__c(Name = 'Primary Settings', Apttus_Config2__DefaultRenewalTerm__c = 0, Apttus_Config2__MaxRenewsPerTrip__c = 20, Apttus_Config2__ShowAccountsFilter__c = true);          
                insert customSetting;
            }
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }
    
    public static void preSalesConfigSetting(){
        try{
            Apttus_PreSales_Config_Settings__c customSettingExisting = Apttus_PreSales_Config_Settings__c.getValues('System Properties');
            
            if(customSettingExisting == null){
                Apttus_PreSales_Config_Settings__c customSetting = new Apttus_PreSales_Config_Settings__c(Name = 'System Properties', Auto_Populate_Price_Book_in_Opportunity__c = 'Standard Price Book', Default_Pricelist__c = 'Tier 1 Hardware & Software', Company_Name__c = 'Apttus', Logo_Document_Name__c = 'Partner Portal Image', MDO_Version__c = 'v10.5', APTSMD_CPQ_Flow__c = 'ngCPQ', APTSMD_Default_Invoice_Template__c = 'Tier1 Invoice', APTSMD_Batch_File_Process_Mapping__c = 'Asset Line Item=APTSMD_Asset_Line_Item__c,Usage Quantity=APTSMD_Usage_Quantity__c,Start Date=APTSMD_Start_Date__c,End Date=APTSMD_End_Date__c');
                insert customSetting;
            }
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }
    
    public static void preSalesECommerceConfigSetting(){
        try{
            Apttus_Presales_eCommerce_Settings__c customSettingExisting = Apttus_Presales_eCommerce_Settings__c.getOrgDefaults();
            
            if(customSettingExisting == null){
                Apttus_Presales_eCommerce_Settings__c customSetting = new Apttus_Presales_eCommerce_Settings__c(CSS_Override__c = 'Ecommerce', Company_Logo__c = 'eCommerce Logo', Catalog_View__c = 'TilesView', Currency_Precision__c = 0, Email_Template__c = 'Present Proposal', Product_Options_View__c = 'TabView', Opportunity_Id__c = 'Web', Pricelist__c = 'Tier 1 Hardware & Software', Proposal_RecordType_Id__c = 'Proposal', Proposal_Template__c = 'Tier1 Systems Proposal', Show_Multiple_PLI__c = true, InstanceURL__c = System.URL.getSalesforceBaseUrl().toExternalForm());          
                insert customSetting;
            }
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }
   
    public static void proposalSystemPropertiesSetting(){
        try{
            Apttus_Proposal__ProposalSystemProperties__c customSettingExisting = Apttus_Proposal__ProposalSystemProperties__c.getValues('System Properties');
            
            if(customSettingExisting == null){
                Apttus_Proposal__ProposalSystemProperties__c customSetting = new Apttus_Proposal__ProposalSystemProperties__c(Name = 'System Properties', 
                Apttus_Proposal__DefaultOpportunityQuoteOwner__c = 'Opportunity Owner', Apttus_Proposal__DefaultQuoteAgreementOwner__c = 'Quote Owner', Apttus_Proposal__EmailTemplateForPresentingProposals__c = 'Present_Proposal', Apttus_Proposal__InstanceUrl__c = System.URL.getSalesforceBaseUrl().toExternalForm(), Apttus_Proposal__MergeCallTimeoutMillis__c = 60000, Apttus_Proposal__MergeWebserviceEndpoint__c = 'https://mergews.apttus.net/cgi-bin/MergeServer/Bin/MMCGI.exe', Apttus_QPConfig__AutoSyncWithOpportunity__c = true,  Apttus_QPConfig__AutoCreateOrder__c = true);          
                insert customSetting;
            }
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }
    public static void configFlowSetting(){
        try{
            //As there will be existing flow i.e. Default, we will directly insert new one 
            //Apttus_Config2__ConfigFlow__c customSettingExisting = Apttus_Config2__ConfigFlow__c.getValues('System Properties');
 
            Apttus_Config2__ConfigFlow__c tier1Setting = new Apttus_Config2__ConfigFlow__c (Name = 'tier1angular', 
            Apttus_Config2__AssetsPage__c= 'Apttus_Config2__Cart',
            Apttus_Config2__CartPage__c= 'Apttus_Config2__Cart',
            Apttus_Config2__CatalogPage__c= 'Apttus_Config2__Cart',
            Apttus_Config2__OptionsPage__c= 'Apttus_Config2__Cart',
            Apttus_Config2__ProductAttributeDetailPage__c= 'Apttus_Config2__Cart');          
            insert tier1Setting; 
            Apttus_Config2__ConfigFlow__c ngCPQSetting = new Apttus_Config2__ConfigFlow__c (Name = 'ngcpq', 
            Apttus_Config2__AssetsPage__c= 'Apttus_Config2__Cart',
            Apttus_Config2__CartPage__c= 'Apttus_Config2__Cart',
            Apttus_Config2__CatalogPage__c= 'Apttus_Config2__Cart',
            Apttus_Config2__OptionsPage__c= 'Apttus_Config2__Cart',
            Apttus_Config2__ProductAttributeDetailPage__c= 'Apttus_Config2__Cart');          
            insert ngCPQSetting; 
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }
    public static void updateDisplayColumnSetting(){
        try{
            //This method will just update the column setting
            List<Apttus_Config2__ConfigCustomDisplayColumns__c> lstColumnSetting = [SELECT id,name,Apttus_Config2__DisplayType__c,Apttus_Config2__FieldName__c,Apttus_Config2__Flow__c,Apttus_Config2__HeaderStyle__c,Apttus_Config2__IsEditable__c,Apttus_Config2__IsSortable__c,Apttus_Config2__Sequence__c,Apttus_Config2__Style__c,Apttus_Config2__StyleClass__c FROM Apttus_Config2__ConfigCustomDisplayColumns__c];
            if(!lstColumnSetting.isEmpty()){
                for(Apttus_Config2__ConfigCustomDisplayColumns__c configDisplayAction : lstColumnSetting) {
                    configDisplayAction.Apttus_Config2__IsSortable__c = true;
                }
                update lstColumnSetting;
            }
            
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }
    public static void updateDisplayActionSetting(){
        try{
            //This method will just update the Action setting
            List<Apttus_Config2__ConfigCustomDisplayActions__c> newActionSettingList = new List<Apttus_Config2__ConfigCustomDisplayActions__c>();
            List<Apttus_Config2__ConfigCustomDisplayActions__c> cartActionSettingList = new List<Apttus_Config2__ConfigCustomDisplayActions__c>();
            List<Apttus_Config2__ConfigCustomDisplayActions__c> lstActionSetting = [SELECT id,name,Apttus_Config2__ActionArea__c,Apttus_Config2__ActionLabelName__c,Apttus_Config2__ActionName__c,Apttus_Config2__ActionPage__c,Apttus_Config2__ActionParams__c,Apttus_Config2__ActionStyleClass__c,Apttus_Config2__ActionType__c,Apttus_Config2__AlwaysDisplay__c,Apttus_Config2__Behavior__c,Apttus_Config2__DisplayAs__c,Apttus_Config2__DisplayType__c,Apttus_Config2__Flow__c,Apttus_Config2__IsEnabled__c,Apttus_Config2__Sequence__c FROM Apttus_Config2__ConfigCustomDisplayActions__c];
           
            cartActionSettingList  = [select id from Apttus_Config2__ConfigCustomDisplayActions__c where Apttus_Config2__DisplayType__c Like 'Cart Line Item%'];
            
            Decimal seq;
            Decimal seqAll;

           
            seq = cartActionSettingList.size();
            seqAll = lstActionSetting.size();
            seq++;
            Apttus_Config2__ConfigCustomDisplayActions__c manageGroupsAction =  new Apttus_Config2__ConfigCustomDisplayActions__c();
            manageGroupsAction.Name = 'Manage Groups tier1';
            manageGroupsAction.Apttus_Config2__ActionLabelName__c = 'Manage Groups';
            manageGroupsAction.Apttus_Config2__DisplayAs__c = 'Action';
            manageGroupsAction.Apttus_Config2__ActionArea__c = 'Center';
            manageGroupsAction.Apttus_Config2__ActionPage__c = 'APTSMD_GroupAdjustment';
            manageGroupsAction.Apttus_Config2__Behavior__c ='Self';
            manageGroupsAction.Apttus_Config2__IsEnabled__c = true;
            manageGroupsAction.Apttus_Config2__AlwaysDisplay__c = true;
            manageGroupsAction.Apttus_Config2__Flow__c='tier1angular';
            manageGroupsAction.Apttus_Config2__DisplayType__c = 'Cart Line Item';
            manageGroupsAction.Apttus_Config2__Sequence__c = seq;
            manageGroupsAction.Apttus_Config2__ActionName__c = 'CustomAction'+string.valueOf(seqAll);
            newActionSettingList.add(manageGroupsAction);
            seqAll++;
            Apttus_Config2__ConfigCustomDisplayActions__c manageGroupsAction1 =  new Apttus_Config2__ConfigCustomDisplayActions__c();
            manageGroupsAction1.Name = 'Manage Groups ngcpq';
            manageGroupsAction1.Apttus_Config2__ActionLabelName__c = 'Manage Groups';
            manageGroupsAction1.Apttus_Config2__DisplayAs__c = 'Action';
            manageGroupsAction1.Apttus_Config2__ActionArea__c = 'Center';
            manageGroupsAction1.Apttus_Config2__ActionPage__c = 'APTSMD_GroupAdjustment';
            manageGroupsAction1.Apttus_Config2__Behavior__c ='Self';
            manageGroupsAction1.Apttus_Config2__IsEnabled__c = true;
            manageGroupsAction1.Apttus_Config2__AlwaysDisplay__c = true;
            manageGroupsAction1.Apttus_Config2__Flow__c='ngcpq';
            manageGroupsAction1.Apttus_Config2__DisplayType__c = 'Cart Line Item';
            manageGroupsAction1.Apttus_Config2__Sequence__c = seq;
            manageGroupsAction1.Apttus_Config2__ActionName__c = 'CustomAction'+string.valueOf(seqAll);
            newActionSettingList.add(manageGroupsAction1);
            
            seqAll++;
            // --------------
            seq++;
            
            Apttus_Config2__ConfigCustomDisplayActions__c managePropTermAction =  new Apttus_Config2__ConfigCustomDisplayActions__c();
            managePropTermAction.Name = 'Manage Proposal Term tier1';
            managePropTermAction.Apttus_Config2__ActionLabelName__c = 'Manage Proposal Terms';
            managePropTermAction.Apttus_Config2__DisplayAs__c = 'Action';
            managePropTermAction.Apttus_Config2__ActionArea__c = 'Center';
            managePropTermAction.Apttus_Config2__ActionPage__c = 'APTSMD_ManageProposalTerms';
            managePropTermAction.Apttus_Config2__Behavior__c ='Self';
            managePropTermAction.Apttus_Config2__IsEnabled__c = true;
            managePropTermAction.Apttus_Config2__AlwaysDisplay__c = true;
            managePropTermAction.Apttus_Config2__Flow__c='tier1angular';
            managePropTermAction.Apttus_Config2__DisplayType__c = 'Cart Line Item';
            managePropTermAction.Apttus_Config2__Sequence__c = seq;
            managePropTermAction.Apttus_Config2__ActionName__c = 'CustomAction'+string.valueOf(seqAll);
            newActionSettingList.add(managePropTermAction );
            
            seqAll++;
            
            Apttus_Config2__ConfigCustomDisplayActions__c managePropTermAction1 =  new Apttus_Config2__ConfigCustomDisplayActions__c();
            managePropTermAction1.Name = 'Manage Proposal Term ngcpq';
            managePropTermAction1.Apttus_Config2__ActionLabelName__c = 'Manage Proposal Terms';
            managePropTermAction1.Apttus_Config2__DisplayAs__c = 'Action';
            managePropTermAction1.Apttus_Config2__ActionArea__c = 'Center';
            managePropTermAction1.Apttus_Config2__ActionPage__c = 'APTSMD_ManageProposalTerms';
            managePropTermAction1.Apttus_Config2__Behavior__c ='Self';
            managePropTermAction1.Apttus_Config2__IsEnabled__c = true;
            managePropTermAction1.Apttus_Config2__AlwaysDisplay__c = true;
            managePropTermAction1.Apttus_Config2__Flow__c='ngcpq';
            managePropTermAction1.Apttus_Config2__DisplayType__c = 'Cart Line Item';
            managePropTermAction1.Apttus_Config2__Sequence__c = seq;
            managePropTermAction1.Apttus_Config2__ActionName__c = 'CustomAction'+string.valueOf(seqAll);
            newActionSettingList.add(managePropTermAction1);
            seqAll++;
            //-----------------
             seq++;
            Apttus_Config2__ConfigCustomDisplayActions__c importfavorite =  new Apttus_Config2__ConfigCustomDisplayActions__c();
            importfavorite.Name = 'Import Favorite tier1';
            importfavorite.Apttus_Config2__ActionLabelName__c = 'Import Favorites';
            importfavorite.Apttus_Config2__DisplayAs__c = 'Action';
            importfavorite.Apttus_Config2__ActionArea__c = 'Center';
            importfavorite.Apttus_Config2__ActionPage__c = 'APTSMD_ShowFavouriteVf';
            importfavorite.Apttus_Config2__Behavior__c ='Self';
            importfavorite.Apttus_Config2__IsEnabled__c = true;
            importfavorite.Apttus_Config2__AlwaysDisplay__c = true;
            importfavorite.Apttus_Config2__Flow__c='tier1angular';
            importfavorite.Apttus_Config2__DisplayType__c = 'Cart Line Item';
            importfavorite.Apttus_Config2__Sequence__c = seq;
            importfavorite.Apttus_Config2__ActionName__c = 'CustomAction'+string.valueOf(seqAll);
            newActionSettingList.add(importfavorite);
            
            seqAll++;
            Apttus_Config2__ConfigCustomDisplayActions__c importfavorite1 =  new Apttus_Config2__ConfigCustomDisplayActions__c();
            importfavorite1.Name = 'Import Favorite ngcpq';
            importfavorite1.Apttus_Config2__ActionLabelName__c = 'Import Favorites';
            importfavorite1.Apttus_Config2__DisplayAs__c = 'Action';
            importfavorite1.Apttus_Config2__ActionArea__c = 'Center';
            importfavorite1.Apttus_Config2__ActionPage__c = 'APTSMD_ShowFavouriteVf';
            importfavorite1.Apttus_Config2__Behavior__c ='Self';
            importfavorite1.Apttus_Config2__IsEnabled__c = true;
            importfavorite1.Apttus_Config2__AlwaysDisplay__c = true;
            importfavorite1.Apttus_Config2__Flow__c='ngcpq';
            importfavorite1.Apttus_Config2__DisplayType__c = 'Cart Line Item';
            importfavorite1.Apttus_Config2__Sequence__c = seq;
            importfavorite1.Apttus_Config2__ActionName__c = 'CustomAction'+string.valueOf(seqAll);
            newActionSettingList.add(importfavorite1);
            
            seq++;
            
            //-----
            seqAll++;
            Apttus_Config2__ConfigCustomDisplayActions__c savefavorite =  new Apttus_Config2__ConfigCustomDisplayActions__c();
            savefavorite.Name = 'Save Favorite tier1';
            savefavorite.Apttus_Config2__ActionLabelName__c = 'Save Favorites';
            savefavorite.Apttus_Config2__DisplayAs__c = 'Action';
            savefavorite.Apttus_Config2__ActionArea__c = 'Center';
            savefavorite.Apttus_Config2__ActionPage__c = 'APTSMD_SaveFavouriteLIPage';
            savefavorite.Apttus_Config2__Behavior__c ='Self';
            savefavorite.Apttus_Config2__IsEnabled__c = true;
            savefavorite.Apttus_Config2__AlwaysDisplay__c = true;
            savefavorite.Apttus_Config2__Flow__c='tier1angular';
            savefavorite.Apttus_Config2__DisplayType__c = 'Cart Line Item';
            savefavorite.Apttus_Config2__Sequence__c = seq;
            savefavorite.Apttus_Config2__ActionName__c = 'CustomAction'+string.valueOf(seqAll);
            newActionSettingList.add(savefavorite);
            seqAll++;
            Apttus_Config2__ConfigCustomDisplayActions__c savefavorite1 =  new Apttus_Config2__ConfigCustomDisplayActions__c();
            savefavorite1.Name = 'Save Favorite ngcpq';
            savefavorite1.Apttus_Config2__ActionLabelName__c = 'Save Favorites';
            savefavorite1.Apttus_Config2__DisplayAs__c = 'Action';
            savefavorite1.Apttus_Config2__ActionArea__c = 'Center';
            savefavorite1.Apttus_Config2__ActionPage__c = 'APTSMD_SaveFavouriteLIPage';
            savefavorite1.Apttus_Config2__Behavior__c ='Self';
            savefavorite1.Apttus_Config2__IsEnabled__c = true;
            savefavorite1.Apttus_Config2__AlwaysDisplay__c = true;
            savefavorite1.Apttus_Config2__Flow__c='ngcpq';
            savefavorite1.Apttus_Config2__DisplayType__c = 'Cart Line Item';
            savefavorite1.Apttus_Config2__Sequence__c = seq;
            savefavorite1.Apttus_Config2__ActionName__c = 'CustomAction'+string.valueOf(seqAll);
            newActionSettingList.add(savefavorite1);
            
            seq++;
            seqAll++;
            
                
            Apttus_Config2__ConfigCustomDisplayActions__c importfavoriteCatalog =  new Apttus_Config2__ConfigCustomDisplayActions__c();
            importfavoriteCatalog.Name = 'Import Favorite tier1c';
            importfavoriteCatalog.Apttus_Config2__ActionLabelName__c = 'Import Favorites';
            importfavoriteCatalog.Apttus_Config2__DisplayAs__c = 'Action';
            importfavoriteCatalog.Apttus_Config2__ActionArea__c = 'Center';
            importfavoriteCatalog.Apttus_Config2__ActionPage__c = 'APTSMD_ShowFavouriteVf';
            importfavoriteCatalog.Apttus_Config2__Behavior__c ='Self';
            importfavoriteCatalog.Apttus_Config2__IsEnabled__c = true;
            importfavoriteCatalog.Apttus_Config2__AlwaysDisplay__c = true;
            importfavoriteCatalog.Apttus_Config2__Flow__c='tier1angular';
            importfavoriteCatalog.Apttus_Config2__DisplayType__c = 'Catalog Item';
            importfavoriteCatalog.Apttus_Config2__Sequence__c = seq;
            importfavoriteCatalog.Apttus_Config2__ActionName__c = 'CustomAction'+string.valueOf(seqAll);
            newActionSettingList.add(importfavoriteCatalog);
            
            seqAll++;
            Apttus_Config2__ConfigCustomDisplayActions__c importfavoriteCatalog1 =  new Apttus_Config2__ConfigCustomDisplayActions__c();
            importfavoriteCatalog1.Name = 'Import Favorite ngcpqc';
            importfavoriteCatalog1.Apttus_Config2__ActionLabelName__c = 'Import Favorites';
            importfavoriteCatalog1.Apttus_Config2__DisplayAs__c = 'Action';
            importfavoriteCatalog1.Apttus_Config2__ActionArea__c = 'Center';
            importfavoriteCatalog1.Apttus_Config2__ActionPage__c = 'APTSMD_ShowFavouriteVf';
            importfavoriteCatalog1.Apttus_Config2__Behavior__c ='Self';
            importfavoriteCatalog1.Apttus_Config2__IsEnabled__c = true;
            importfavoriteCatalog1.Apttus_Config2__AlwaysDisplay__c = true;
            importfavoriteCatalog1.Apttus_Config2__Flow__c='ngcpq';
            importfavoriteCatalog1.Apttus_Config2__DisplayType__c = 'Catalog Item';
            importfavoriteCatalog1.Apttus_Config2__Sequence__c = seq;
            importfavoriteCatalog1.Apttus_Config2__ActionName__c = 'CustomAction'+string.valueOf(seqAll);
            newActionSettingList.add(importfavoriteCatalog1);
            
            insert newActionSettingList;
            lstActionSetting = [SELECT id,name,Apttus_Config2__ActionArea__c,Apttus_Config2__ActionLabelName__c,Apttus_Config2__ActionName__c,Apttus_Config2__ActionPage__c,Apttus_Config2__ActionParams__c,Apttus_Config2__ActionStyleClass__c,Apttus_Config2__ActionType__c,Apttus_Config2__AlwaysDisplay__c,Apttus_Config2__Behavior__c,Apttus_Config2__DisplayAs__c,Apttus_Config2__DisplayType__c,Apttus_Config2__Flow__c,Apttus_Config2__IsEnabled__c,Apttus_Config2__Sequence__c FROM Apttus_Config2__ConfigCustomDisplayActions__c];
            system.debug('*****'+lstActionSetting);
            system.debug('####'+lstActionSetting.size());
            if(!lstActionSetting.isEmpty()){
                 system.debug('$$$ - in ---'+lstActionSetting.size());
                for(Apttus_Config2__ConfigCustomDisplayActions__c configdisplay : lstActionSetting ) {
                   configdisplay.Apttus_Config2__AlwaysDisplay__c = true;
                   configdisplay.Apttus_Config2__IsEnabled__c = true;
                }
                update lstActionSetting;
            }
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }
     public static void createAccountContact(){
        try{
            Account acct = new Account (Name = 'Tier1 Account', BillingStreet = '12 Bay Avenue', BillingCity = 'New York',BillingState='NY',BillingCountry = 'United States',BillingPostalCode = '11259');
            insert acct;
            List<Contact> existingCon = [SELECT id,Name FROM Contact WHERE FirstName='Diego' AND LastName='Francis'];
            if(existingCon.isEmpty()){
                Contact conct = new Contact(FirstName = 'Diego',LastName = 'Francis',AccountId = acct.id) ;
                insert conct;
            }  
            
            Apttus_Config2__PriceList__c pli = new Apttus_Config2__PriceList__c();
            pli = [select id from Apttus_Config2__PriceList__c where Name='Tier 1 Hardware & Software'];

            
            Opportunity opt = new Opportunity ();
            opt.Name = 'Tier1 Opportunity';
            opt.AccountId = acct.id;
            opt.CloseDate = Date.today().addDays(365);
            opt.StageName = 'Prospecting';
            
            opt.Price_List__c = pli.id;
            
            insert opt;
              
        }
        catch(Exception ex){
            system.debug('###Exception:' + ex);
        }
    }
   
}