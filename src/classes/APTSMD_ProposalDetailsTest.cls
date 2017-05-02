@isTest
public class APTSMD_ProposalDetailsTest {
    static testMethod void testConstr(){
         APTSMD_ProposalDetails.proposalLineItems propLineitems = new APTSMD_ProposalDetails.proposalLineItems();
        propLineitems.itemName = 'test';
        propLineitems.itemDesc = 'test';
        propLineitems.UOM = 'testUom';
        propLineitems.quantity = 2;
        propLineitems.productCode = 'TEST01';
        propLineitems.listPrice = 100;
        propLineitems.netPrice = 100;
        propLineitems.lineType = 'testLine';
        
        System.assertNotEquals(null, propLineitems);
        
        list<APTSMD_ProposalDetails.proposalLineItems> lstPropLI = new list<APTSMD_ProposalDetails.proposalLineItems>();
        lstPropLI.add(propLineitems);
        
        System.assertNotEquals(0, lstPropLI.size());
        
        APTSMD_ProposalDetails propDetails = new APTSMD_ProposalDetails();
        propDetails.proposalID = '012345';
        propDetails.proposalNumber = 'testNumber';
        propDetails .name = 'testName';
        propDetails.totalAmount = 10;
        propDetails.cartId = '01234';
        propDetails.lineItems = lstPropLi;
        
       System.assertNotEquals(null, propDetails);
    }
}