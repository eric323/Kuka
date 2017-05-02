/**********************************************************************
Name:  KAPContractViewController
======================================================
Purpose: Controller for KAPContractView page
======================================================
History
-------
Date        AUTHOR                          DETAIL
22/07/2016  Wolfram von Reitzenstein        INITIAL
07/11/2016  Andreas Meyer                   DC-721
*********************************************************************/

public class KAPContractViewController {

      public List<Contract> listResultContracts { get; set; }
      public ID accId {get; set;}
      private KeyAccountPlan__c obj;
      public boolean novalues {get;set;} 
      public string noContractsAvailable{get;set;}
      
      
      //Variables for Pagination
      public KAPPaginate paginater {get;set;} 
      public List<Contract> listContractsByPage{get;set;} 
      public List<List<Contract>> listOfListsContrsByPage{get;set;} 
      public Map<String,String> mapReferenceNameFields{get;set;} 

      public KAPContractViewController(ApexPages.StandardController controller){
      
          // Sets flag initially to true --> if later Contracts are found is has to be set to false
          novalues = true;
          
          //Recieves Error label to display if no Contracts are found
          noContractsAvailable = System.Label.No_Contracts_for_Account_Hierarchy;
           
          // add custom Filed Account ID to Controller
          if (false == Test.isRunningTest()){
            controller.addFields(new List<String>{'AccountID__c'});  
          }
           
          // get the current KeyAccountPlan object
          this.obj = (KeyAccountPlan__c) controller.getRecord();
          accId = this.obj.AccountID__c;
           
          //Call function to get all Accounts below the Key Account
          Set<ID> accountIDs = KAPHelperFunctions.getAllAccountIDsForKeyAccount(accId);
         
          //Call method to search Contracts for Account list
          this.fillContractsList(controller, accountIDs);
          
          //initialize Pagination
          this.initilizePagination();
           
      }
      
      private void fillContractsList(ApexPages.StandardController controller, Set<ID> accountIDs ){
          
          mapReferenceNameFields = new Map<String,String>();
          //Prepare columns for Contracts according to Field Set
          
          //ID and Name are always included for link on ID with label Name
          String queryFields = 'Id ,Name ';
          
          //Get remaining fields according to FieldSet KAPFieldDetails on Contract
          for(Schema.FieldSetMember f : SObjectType.Contract.FieldSets.KAPFieldDetails.getFields()) {
              String hStr = f.getFieldPath().toLowerCase();
              if ('id' != hStr && 'name' != hStr){
                  if(queryFields.length() > 0) {
                      queryFields += ', ';
                  }
                  queryFields += f.getFieldPath();
                  // andreas.meyer@salesforce.com 07.11.2016 DC-721 add extra fields for references
                  if (Schema.DisplayType.Reference == f.getType()){
                    Map<String, Schema.SObjectField> fieldMap = Schema.sObjectType.Contract.fields.getMap();                    
                    Schema.DescribeFieldResult field = fieldMap.get(f.getFieldPath()).getDescribe();
                    String hNameField = field.getRelationshipName() + '.Name';
                    queryFields += ', ';
                    queryFields += hNameField; 
                    mapReferenceNameFields.put(f.getFieldPath(), hNameField);
                  }                  
              }
          }
          
          //Construct Query String for query Contract records by AccountID
          String oppQuery = 
              'SELECT ' + queryFields + 
              ' FROM Contract WHERE AccountId IN :accountIDs';
              
          //Temporary Contract List object
          List<Contract> listContract = new List<Contract>();
          listContract = Database.query(oppQuery);
          
          //Return values if Temporary Contract List object is not empty
          if (false == listContract.isEmpty()){
              this.listResultContracts = listContract;
        }  
    }  
    
    public void initilizePagination(){  
        
        //Get the data we need to paginate 
        List<Contract> resultsList = this.listResultContracts; 
        
        //Set the page size 
        Integer pageSize = 6;  
        
        //These lists hold the data 
        this.listOfListsContrsByPage = new List<List<Contract>>(); 
        this.listContractsByPage = new List<Contract>(); 
    
        if(resultsList != null) { 
    
            //Break out the full list into a list of lists 
            if(resultsList.size() > 0){ 
                
                //Create a new instance of Paginate passing in the overall size of 
                //the list of data and the page size you want  
                this.paginater = new KAPPaginate(resultsList.size(), pageSize); 
                
                List<Contract> tempCC = new List<Contract>(); 
                Integer i = 0; 
                for(Contract cc : resultsList){ 
                    tempCC.add(cc); 
                    i++; 
                    if(i == pageSize){ 
                        this.listOfListsContrsByPage.add(tempCC); 
                        tempCC = new List<Contract>(); 
                        i = 0; 
                    } 
                 } 
                 if(!tempCC.isEmpty()){ 
                     this.listOfListsContrsByPage.add(tempCC); 
                 } 
                 
                 // Sets no values flag to false as there are Contracts to display
                 novalues = false;
                 
                 //Gets the correct list of data to show on the page 
                 this.listContractsByPage = this.listOfListsContrsByPage.get(this.paginater.index); 
            } 
        } 
    } 
    
    //Call paginater for previous page
    public PageReference previousPage(){ 
        this.paginater.decrement(); 
        return changeData(); 
    } 
    
    //Call paginater for next page
    public PageReference nextPage(){ 
        this.paginater.increment(); 
        return changeData(); 
    } 
    
    //Call paginater for page update
    public PageReference updatePage(){ 
        this.paginater.updateNumbers(); 
        return changeData(); 
    } 
    
    //Call paginater for data change
    public PageReference changeData(){ 
        this.listContractsByPage = this.listOfListsContrsByPage.get(this.paginater.index); 
        return null; 
    } 
}