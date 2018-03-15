({
    doInit : function(component, event, helper) {
        helper.spinnerShow(component);
        var action = component.get("c.getResults");
        action.setCallback(this, function(response) {
            if (response.getState() === 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.results", result);
                helper.spinnerHide(component);
            } else {
                helper.spinnerHide(component);
                helper.showToast('Error', 'some error during callback', 'error');
            }
        });
        $A.enqueueAction(action);
    }
})