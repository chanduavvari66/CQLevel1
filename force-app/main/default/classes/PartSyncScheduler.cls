global class PartSyncScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Call the method to synchronize Part records
            PartSyncObject.syncPart_Api();
    }
}