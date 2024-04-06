public class PartController {
    @AuraEnabled
    public static String partsSyncMethod() {
        try {
            PartSyncObject.syncPart_Api();
            return 'Success';
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}