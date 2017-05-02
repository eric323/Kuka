public class APTSMD_ImageUploader {
    public Attachment newAttachment{get;set;}
    public APTSMD_Store__c storeObj{get;set;}
    public String attachmentType{get;set;}
    public String attachmentId{get;set;}
    public String imageURL{get;set;}
    public Map<String,String> previewImageMap{get;set;}
    
    
    public APTSMD_ImageUploader(ApexPages.standardController controller){
        String storeObjId = controller.getId();
        storeObj = [select ID,APTSMD_Promotion1__c,APTSMD_Promotion2__c,APTSMD_Promotion3__c, APTSMD_Store_Logo__c, APTSMD_Banner_Image__c FROM APTSMD_Store__c WHERE ID =:storeObjId];
        attachmentType = '';
        newAttachment = new Attachment();
        previewImageMap = new Map<String,String>();
        List<Document> documentList = [SELECT Id,DeveloperName FROM Document WHERE DeveloperName IN('APTSMD_EcommerceLogoPreview','APTSMD_EcommerceBannerPreview','APTSMD_EccomerceSliderPreview')];
        if(documentList != null && documentList.size()>0){
            for(Document doc : documentList){
                previewImageMap.put(doc.DeveloperName,'/servlet/servlet.FileDownload?file='+doc.Id);
            }
        }
        
        System.debug('>> Document Map : '+previewImageMap);
        
        
        
    }
    
    
    
 public void upload() {
    
    newAttachment.OwnerId = UserInfo.getUserId();
    newAttachment.ParentId = storeObj.ID; // the record the file is attached to
    newAttachment.IsPrivate = false;
    newAttachment.Description = attachmentType;
    //newAttachment.IsPublic = true;
    
    if(attachmentType == null || attachmentType == ''){
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Attachment Type'));
        // return null;
    }

    try {
       if(storeObj.get(attachmentType)!=null){
           attachmentId = (String)storeObj.get(attachmentType);
           newAttachment.id = attachmentId;
           
           update newAttachment;
       }
       else{
           insert newAttachment;
           attachmentId = newAttachment.ID;
       }
      
      storeObj.put(attachmentType, attachmentId);
      update storeObj;
      
      imageURL = URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+attachmentId;
     
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
     //return null;
    } finally {
      newAttachment = new Attachment(); 
    }

    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
     //return null;
  }
  
  public PageReference save() {
      System.debug('newAttachment :' + newAttachment);
       System.debug('attachmentType :' + attachmentType);
      storeObj.put(attachmentType, attachmentId);
      update storeObj;
      
      return new PageReference('/'+storeObj.ID);
  }
  
   public PageReference close() {
      return new PageReference('/'+storeObj.ID);
  }
    
public PageReference refreshAndUpdateImage(){
    System.debug('refreshAndUpdateImage:');
    if(attachmentType!=null){
        if(storeObj.get(attachmentType)!=null){
           attachmentId = (String)storeObj.get(attachmentType);
          // AttachmentExisted = [SELECT ID, Name, Body FROM Attachment WHERE ID = :attachmentId];
           imageURL = URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+attachmentId;
       }
       else imageURL = null;
    }
    return null;
}

    
    
    

}