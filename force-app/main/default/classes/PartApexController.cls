public class PartApexController {
    @AuraEnabled
    public static String syncPartsMethod() {
        try {
            SyncPartObject.syncPartRecords();
            return 'Success';
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}