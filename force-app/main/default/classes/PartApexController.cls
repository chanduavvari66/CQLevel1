public class PartApexController {
    @AuraEnabled
    public static String syncPartsMethod() {
        try {
            syncPartObject.syncPart_Api();
            return 'Success';
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}