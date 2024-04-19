public class PartController {
    @AuraEnabled
    public static String partsSyncMethod() {
        PartSyncObject.syncPart_Api();
        return 'Success';
    }
}
