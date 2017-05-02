public without sharing class APTSMD_eCom_CallOutResult
{
    public double taxAmt; // tax amount
    public boolean success; // to indicate success or failure
    public String message; // to indicate any message from vertex
    public boolean error; // to indicate if any error
    public String authorizationCode; // autorization code for credit card 
}