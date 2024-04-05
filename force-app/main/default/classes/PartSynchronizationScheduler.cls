global class PartSynchronizationScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Call the method to synchronize Part records
        syncPartObject.syncPart_Api();
    }
}