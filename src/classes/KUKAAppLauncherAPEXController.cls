/**********************************************************************
Name:  KUKAAppLauncherAPEXController
======================================================
Purpose: Controller for KUKAAppLauncher lightning component
======================================================
History
-------
Date        AUTHOR                          DETAIL
12/01/2017  Andreas Meyer                   INITIAL
*********************************************************************/
public class KUKAAppLauncherAPEXController {
    @AuraEnabled
    public static List<AppMenuItem> getAllowedApps() {

		String userAppOrder;
		userAppOrder = [SELECT Id, Name, AppOrder__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1].AppOrder__c; 

        List <AppMenuItem> Apps;
        List<SetupEntityAccess> seas = 
            [SELECT SetupEntityId
             FROM SetupEntityAccess
             WHERE ParentId IN (SELECT PermissionSetId
                                FROM PermissionSetAssignment 
                                WHERE AssigneeId = :UserInfo.getUserId())];
        Set<id> ids = new Set<id>();
        for (SetupEntityAccess sea:seas){ 
            Ids.add(sea.SetupEntityId);
        }
        List <AppMenuItem> defaultOrderedApps = [
            SELECT Id, ApplicationId, Name, Label, Type, LogoURL, IconURL, StartURL, InfoURL, Description 
            FROM AppMenuItem 
            WHERE Type = 'ConnectedApplication' 
            AND StartURL != null 
            AND ApplicationId in :Ids
            ORDER BY SortOrder
        ];
        if (userAppOrder == null) {
            apps = new List <AppMenuItem> (defaultOrderedApps);
        } else {
            apps =new List <AppMenuItem> ();
            Map <Id, AppMenuItem> mapDefaultOrderedApps = new Map <Id, AppMenuItem> ();
            for (AppMenuItem defaultOrderedApp: defaultOrderedApps) {
                mapDefaultOrderedApps.put(defaultOrderedApp.ApplicationId,defaultOrderedApp);
            }
            List <String> userOrderedApps = userAppOrder.split(' ', -1);
            for (String userOrderedApp:userOrderedApps) {
                id myId = Id.ValueOf(userOrderedApp);
                if (mapDefaultOrderedApps.containsKey(myId)){
                    apps.add(mapDefaultOrderedApps.get(myId));
                    mapDefaultOrderedApps.remove(myId);
                }    
            }
            if (!mapDefaultOrderedApps.isEmpty()) {
                for(Id myId:mapDefaultOrderedApps.keySet()){
                    apps.add(mapDefaultOrderedApps.get(myId));
                }
            }
        }
        return apps;
    }

}