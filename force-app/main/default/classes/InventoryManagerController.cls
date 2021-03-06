//Class to get configuration data for Inventory manager
public with sharing class InventoryManagerController {
    //Get list of records in "Inventory Manager" custom metadata type
    @AuraEnabled(cacheable=true)
    public static Map<String, Boolean> getSettings() {
        Map<String, Boolean> inventoryManagerSettings = new Map<String, Boolean>();
        try{
            //Check read permission on Metadata object and fields
            List<Schema.SobjectField> fields = new List<Schema.SobjectField>{
                Schema.Inventory_Manager__mdt.fields.QualifiedApiName, Schema.Inventory_Manager__mdt.fields.isEnabled__c
                };
            Util.AccessController.assertAuthorizedToView(Schema.Inventory_Manager__mdt.getSobjectType(), fields);
            
            for(Inventory_Manager__mdt record: [SELECT QualifiedApiName, isEnabled__c FROM Inventory_Manager__mdt]) {
                inventoryManagerSettings.put(record.QualifiedApiName, record.isEnabled__c);
            }
        }catch(SFDCAccessControlException e){Util.log('InventoryManagerController:getSettings():SFDCAccessControlException' + e.getMessage());
        }catch(Exception e){Util.log('InventoryManagerController:getSettings():Exception' + e.getMessage()); }
        

        return inventoryManagerSettings;
    }

    //Get list of records in "Inventory Manager" custom metadata type
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getUserSettings() {
        Map<String, String> userSettings = new Map<String, String>();

        try{
            //Check read permission on Location__c object and fields
            List<Schema.SobjectField> fields = new List<Schema.SobjectField>{Schema.Location__c.fields.Assigned_User__c};
            Util.AccessController.assertAuthorizedToView(Schema.Location__c.getSobjectType(), fields);

            Location__c location = [select id from Location__c where Assigned_User__c=:UserInfo.getUserId()];
            userSettings.put('Location', location.Id);
        }catch(SFDCAccessControlException e){userSettings.put('Location', null); Util.log('InventoryManagerController:getUserSettings():SFDCAccessControlException' + e.getMessage());
        }catch(Exception e){ userSettings.put('Location', null); }

        return userSettings;
    }

}