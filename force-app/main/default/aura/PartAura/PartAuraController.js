({
    syncParts : function(component, event, helper) {
        var action = component.get("c.partsSyncMethod");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.status", "Synchronization completed successfully.");
            } else {
                component.set("v.status", "Error occurred during synchronization.");
            }
        });
        $A.enqueueAction(action);
    }
})