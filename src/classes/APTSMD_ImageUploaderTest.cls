@isTest(SeeAllData = true)
public class APTSMD_ImageUploaderTest {
    static testMethod void testConstructor(){
  		APTSMD_Store__c testStore = [select ID,APTSMD_Promotion1__c,APTSMD_Promotion2__c,APTSMD_Promotion3__c, APTSMD_Store_Logo__c, APTSMD_Banner_Image__c from APTSMD_Store__c limit 1];
        System.debug('### testStore ' + testStore);
    
        String pdfContent = 'This is a test string';
        Attachment attachmentPDF = new Attachment();
        attachmentPdf.parentId = testStore.id;
        attachmentPdf.name = account.name + '.pdf';
        attachmentPdf.body = blob.toPDF(pdfContent);
        insert attachmentPDF;

     	System.debug('### newAttachment ' + attachmentPdf);
        //[ParentId, Name, Body]
		//insert newAttachment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testStore);
		System.debug('### controller ' + sc);
        APTSMD_ImageUploader imgUploader = new APTSMD_ImageUploader(sc);
        
        imgUploader.attachmentId = attachmentPDF.id;

        
		imgUploader.attachmentType = 'APTSMD_Promotion1__c';
        imgUploader.upload();
        //System.assertNotEquals(null, imgUploader);
     
        imgUploader.save();
        
        imgUploader.close();
        
        PageReference pageref = imgUploader.refreshAndUpdateImage();
        
        System.assertEquals(null, pageref);

       
    }
}