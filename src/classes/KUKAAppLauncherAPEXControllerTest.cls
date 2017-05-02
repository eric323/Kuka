/**********************************************************************
Name:  KUKAAppLauncherAPEXControllerTest
======================================================
Purpose:

Unittest Class for KUKAAppLauncherAPEXControllerTest
======================================================
History
-------
Date            AUTHOR                      DETAIL
12/01/2017  Andreas Meyer                   INITIAL
*********************************************************************/
@IsTest public with sharing class KUKAAppLauncherAPEXControllerTest {

    public static testMethod void testAppLauncherController() {
        KUKAAppLauncherAPEXController.getAllowedApps();
        //System.assert(KUKAAppLauncherAPEXController.getAllowedApps().size() > 0);
        
    }


}