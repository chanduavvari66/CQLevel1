public class PartSyncObject {
    public static void syncPart_Api() {
        String profileID = UserInfo.getProfileId();
        List<Profile> profileName = [SELECT Name FROM Profile WHERE Id = :profileID];
        
        if (profileName[0].Name.equals('System Administrator')) {
                  
        HttpRequest req = new HttpRequest();
        req.setEndpoint(system.label.End_Point);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('x-api-key', system.label.key);
 
        Http http = new Http();
        HttpResponse res = http.send(req);
       
        if (res.getStatusCode() == 200) {
            String responseBody = res.getBody();
            System.debug('Response Body: ' + responseBody);
            if (String.isNotBlank(responseBody)) {
                
                    // Deserialize the JSON response into a list of objects
                    List<Object> parts = (List<Object>) JSON.deserializeUntyped(responseBody);                    
                    List<SQX_Part__c> partRecords = new List<SQX_Part__c>();
                    List<Account> highVolume = [SELECT Id FROM Account WHERE Name = 'High Volume' LIMIT 1];
                    List<Account> lowVolume = [SELECT Id FROM Account WHERE Name = 'Low Volume' LIMIT 1];

                    for (Object part : parts) {
                            // Convert the part object to a map
                            Map<String, Object> partMap = (Map<String, Object>) part;
                            // Check for null values before accessing map keys
                                if (partMap != null) {
                                    SQX_Part__c insertPart = new SQX_Part__c();
                                    insertPart.Part_Number__c = String.valueOf(partMap.get('_id'));
                                    insertPart.Name = String.valueOf(partMap.get('Part Name'));
                                    // Hardcoded as 'true' as per the requirement
                                    insertPart.Active__c = true; 
                                        if (partMap.get('Total Quantity Shipped') != null) {
                                            Integer totalQuantityShipped = Integer.valueOf(String.valueOf(partMap.get('Total Quantity Shipped')));
                                            insertPart.Related_Account__c = totalQuantityShipped >= 99 ? lowVolume[0].Id : highVolume[0].Id;
                                        }
                                    // Add the new Part record to the list
                                    partRecords.add(insertPart);
                                }
                             
                    } 
                        // Insert the new Part records
                        if (!partRecords.isEmpty()) {
                            insert partRecords;
                        }
            	}
            } 
        }
    }
}
