public class PartSyncObject {

    // Method to initiate the synchronization process
    @InvocableMethod(label='Sync Part Records')
    public static void syncPart_Api() {
        String profileID = UserInfo.getProfileId();
        List<Profile> profileName = [SELECT Name FROM Profile WHERE Id = :profileID];
        
        if (profileName.isEmpty() || !profileName[0].Name.equals('System Administrator')) {
            throw new AuraHandledException('You do not have access.');
        }
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(system.label.End_Point);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('x-api-key', system.label.key);
 
        Http http = new Http();
        HttpResponse res = http.send(req);
 
        System.debug('Response: ' + res);  
       
        if (res.getStatusCode() == 200) {
            String responseBody = res.getBody();
            System.debug('Response Body: ' + responseBody);
            if (String.isNotBlank(responseBody)) {
            try {
                List<Object> parts = (List<Object>) JSON.deserializeUntyped(responseBody);
                System.debug('Deserialized Parts: ' + parts);
                
                List<SQX_Part__c> partRecords = new List<SQX_Part__c>();
                List<Account> highVolumeAccounts = [SELECT Id FROM Account WHERE Name = 'High Volume' LIMIT 1];
            	List<Account> lowVolumeAccounts = [SELECT Id FROM Account WHERE Name = 'Low Volume' LIMIT 1];

                for (Object part : parts) {
    				try {
        				Map<String, Object> partMap = (Map<String, Object>) part;
       	 				System.debug('Part Map: ' + partMap);
        				// Check for null values before accessing map keys
                            if (partMap != null) {
                                SQX_Part__c newPart = new SQX_Part__c();
                                newPart.Part_Number__c = String.valueOf(partMap.get('_Id'));
                                newPart.Name = String.valueOf(partMap.get('Part Name'));
                                newPart.Active__c = true; // Hardcoded as 'true' as per the requirement
                                    if (partMap.get('Total_Quantity_Shipped') != null) {
                                        Integer totalQuantityShipped = Integer.valueOf(String.valueOf(partMap.get('Total_Quantity_Shipped')));
                                        system.debug('totalQuantityShipped' + totalQuantityShipped);
                                         newPart.Related_Account__c = highVolumeAccounts[0].id;
                                    //newPart.Related_Account__c = getRelatedAccount(partMap); // Logic to determine Related Account
                                    }
                                partRecords.add(newPart);
                            } else {
                                System.debug('Part Map is null');
                                // Handle null partMap accordingly
                            }
                        } catch (Exception e) {
                            System.debug('Error processing part: ' + e.getMessage());
                            // Handle exception accordingly
                        }
                   } 
                // Insert the new Part records
                if (!partRecords.isEmpty()) {
                    insert partRecords;
                    System.debug('Part Records Inserted: ' + partRecords);
                }
            } catch (Exception e) {
                System.debug('Error deserializing JSON: ' + e.getMessage());
                throw new AuraHandledException('Error deserializing JSON: ' + e.getMessage());
            }
            } else {
                System.debug('Non-200 status code received: ' + res.getStatusCode());
            }
        }
    }
}