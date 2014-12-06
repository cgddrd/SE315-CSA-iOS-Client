var randUserNumber = getRandomInt(1, 1000);

function testSuccessfulEditUser() {
    
    UIATarget.onAlert = function onAlert(alert) {
        
        var title = alert.name();
        var message = alert.scrollViews()[0].staticTexts()[1].value();
        
        if (message == "User updated successfully.") {
            
            UIATarget.localTarget().captureScreenWithName("UserUpdateSuccessMessage");
            UIALogger.logPass("User was successfully updated as expected.")
            
            alert.buttons()["OK"].tap();
            
            UIATarget.localTarget().delay(2)
            
            return true;
            
        } else {
            
            UIALogger.logFail("UI should have reported that user was successfully updated.")
            
        }
        
        return false;
    }
    
    var target = UIATarget.localTarget();
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[0].tap();
    
    target.frontMostApp().navigationBar().rightButton().tap();
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[0].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[0].textFields()[0].textFields()[0].setValue("UpdatedFirstName" + randUserNumber)
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[1].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[1].textFields()[0].textFields()[0].setValue("UpdatedLastName" + randUserNumber)
    
    target.frontMostApp().mainWindow().tableViews()[0].tapWithOptions({tapOffset:{x:0.92, y:0.61}});
    
    target.frontMostApp().navigationBar().rightButton().tap();
    
    UIATarget.localTarget().delay(2)
    
}

function testEditUserNoGraduationYear() {
    
    UIATarget.onAlert = function onAlert(alert) {
        
        var title = alert.name();
        var message = alert.scrollViews()[0].staticTexts()[1].value();
        
        if (message == "Grad year can't be blank\n\nGrad year is not a number") {
            
            UIATarget.localTarget().captureScreenWithName("UserUpdateGradYearError");
            UIALogger.logPass("UI successfully prevented user from updating the user with no graduation year entered.")
            
            alert.buttons()["OK"].tap();
            
            UIATarget.localTarget().delay(2)
            
            return true;
            
        } else {
            
            UIALogger.logFail("UI should have prevented user from updating the user with no gradutaion year entered.")
            
        }
        
        return false;
    }
    
    var target = UIATarget.localTarget();
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[0].tap();
    
    target.frontMostApp().navigationBar().rightButton().tap();
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].setValue("")
    
    target.frontMostApp().navigationBar().rightButton().tap();
    
    UIATarget.localTarget().delay(2)
    
}

function testEditUserAboveMaxGraduationYear() {
    
    UIATarget.onAlert = function onAlert(alert) {
        
        var title = alert.name();
        var message = alert.scrollViews()[0].staticTexts()[1].value();
        
        if (message == "Grad year must be less than or equal to 2014") {
            
            UIATarget.localTarget().captureScreenWithName("UserUpdateMaxGradYearError");
            UIALogger.logPass("UI successfully prevented user from updating the user with a grad year above the max value of 2014.")
            
            alert.buttons()["OK"].tap();
            
            UIATarget.localTarget().delay(2)
            
            return true;
            
        } else {
            
            UIALogger.logFail("UI should have prevented user from from updating the user with a grad year above the max value of 2014.")
            
        }
        
        return false;
    }
    
    var target = UIATarget.localTarget();
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].setValue("2100")
    
    target.frontMostApp().navigationBar().rightButton().tap();
    
    UIATarget.localTarget().delay(2)
    
}

function testEditUserBelowMinGraduationYear() {
    
    UIATarget.onAlert = function onAlert(alert) {
        
        var title = alert.name();
        var message = alert.scrollViews()[0].staticTexts()[1].value();
        
        if (message == "Grad year must be greater than or equal to 1970") {
            
            UIATarget.localTarget().captureScreenWithName("UserUpdateMinGradYearError");
            UIALogger.logPass("UI successfully prevented user from updating the user with a grad year below the min value of 1970.")
            
            alert.buttons()["OK"].tap();
            
            UIATarget.localTarget().delay(2)
            
            return true;
            
        } else {
            
            UIALogger.logFail("UI should have prevented user from from updating the user with a grad year below the min value of 1970.")
            
        }
        
        return false;
    }
    
    var target = UIATarget.localTarget();
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].setValue("1900")
    
    target.frontMostApp().navigationBar().rightButton().tap();
    
    UIATarget.localTarget().delay(2)
}

function testDeleteUserCancel() {
    
    UIATarget.onAlert = function onAlert(alert) {
        
        var title = alert.name();
        var message = alert.scrollViews()[0].staticTexts()[1].value();
        
        if (message == "Are you sure you wish to delete the user?") {
            
            UIALogger.logPass("UI successfully prompted admin user if they wished to delete the user.")
            
            alert.buttons()["Cancel"].tap();
            
            UIATarget.localTarget().delay(2)
            
            return true;
            
        } else {
            
            UIALogger.logFail("UI should have prompted admin user if they wished to delete the user.")
            
        }
        
        return false;
    }
    
    var target = UIATarget.localTarget();
    
    target.frontMostApp().navigationBar().leftButton().tap();
    
    UIATarget.localTarget().delay(2)
    
    target.frontMostApp().navigationBar().rightButton().tap();
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()["Delete User"].tap();
    
    
    UIATarget.localTarget().delay(2)
    
}

function testDeleteUserConfirm() {
    
    UIATarget.onAlert = function onAlert(alert) {
        
        var title = alert.name();
        var message = alert.scrollViews()[0].staticTexts()[1].value();
        
        if (message == "Are you sure you wish to delete the user?") {
            
            UIALogger.logPass("UI successfully prompted admin user if they wished to delete the user.")
            
            alert.buttons()["OK"].tap();
            
            UIATarget.localTarget().delay(2)
            
            return true;
            
        } else if (message == "User deleted successfully.") {
            
            UIALogger.logPass("UI has successfully reported user has been deleted.")
            
            alert.buttons()["OK"].tap();
            
            UIATarget.localTarget().delay(2)
            
            return true;
        
        } else {
            
            UIALogger.logFail("UI should have prompted admin user if they wished to delete the user or confirmed that the user had been deleted.")
            
        }
        
        return false;
    }
    
    var target = UIATarget.localTarget();
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()["Delete User"].tap();
    
    UIATarget.localTarget().delay(2)
    
    var newTopUserCellName = target.frontMostApp().mainWindow().tableViews()[0].cells()[0].name();
    
    var deletedUserName = "Name, UpdatedFirstName" + randUserNumber + " UpdatedLastName" + randUserNumber;
    
    if (newTopUserCellName != deletedUserName){
        UIALogger.logPass("Deleted user is now no longer available in user list.");
    } else {
        UIALogger.logFail("Deleted user still exists in the user list");
    }
    
    
}

function testSuccessfulEditRegularUser() {
    
    UIATarget.onAlert = function onAlert(alert) {
        
        var title = alert.name();
        var message = alert.scrollViews()[0].staticTexts()[1].value();
        
        if (message == "User updated successfully.") {
            
            UIATarget.localTarget().captureScreenWithName("UserUpdateSuccessMessage");
            UIALogger.logPass("Regular user was successfully updated as expected.")
            
            alert.buttons()["OK"].tap();
            
            UIATarget.localTarget().delay(2)
            
            return true;
            
        } else {
            
            UIALogger.logFail("UI should have reported that regular user was successfully updated.")
            
        }
        
        return false;
    }
    
    var target = UIATarget.localTarget();
    
    target.frontMostApp().navigationBar().rightButton().tap();
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[0].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[0].textFields()[0].textFields()[0].setValue(target.frontMostApp().mainWindow().tableViews()[0].cells()[0].textFields()[0].textFields()[0].value() + "-UIAutoUpdate");
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[1].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[1].textFields()[0].textFields()[0].setValue(target.frontMostApp().mainWindow().tableViews()[0].cells()[1].textFields()[0].textFields()[0].value() + "-UIAutoUpdate")
    
    target.frontMostApp().mainWindow().tableViews()[0].tapWithOptions({tapOffset:{x:0.90, y:0.62}});

    target.frontMostApp().navigationBar().rightButton().tap();
    
    UIATarget.localTarget().delay(2)
    
}

function testEditRegularUserNoGraduationYear() {
    
    UIATarget.onAlert = function onAlert(alert) {
        
        var title = alert.name();
        var message = alert.scrollViews()[0].staticTexts()[1].value();
        
        if (message == "Grad year can't be blank\n\nGrad year is not a number") {
            
            UIATarget.localTarget().captureScreenWithName("UserUpdateGradYearError");
            UIALogger.logPass("UI successfully prevented user from updating the user with no graduation year entered.")
            
            alert.buttons()["OK"].tap();
            
            UIATarget.localTarget().delay(2)
            
            return true;
            
        } else {
            
            UIALogger.logFail("UI should have prevented user from updating the user with no gradutaion year entered.")
            
        }
        
        return false;
    }
    
    var target = UIATarget.localTarget();
    
    target.frontMostApp().navigationBar().rightButton().tap();
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].setValue("")
    
    target.frontMostApp().navigationBar().rightButton().tap();
    
    UIATarget.localTarget().delay(2)
    
}

function testEditRegularUserAboveMaxGraduationYear() {
    
    UIATarget.onAlert = function onAlert(alert) {
        
        var title = alert.name();
        var message = alert.scrollViews()[0].staticTexts()[1].value();
        
        if (message == "Grad year must be less than or equal to 2014") {
            
            UIATarget.localTarget().captureScreenWithName("UserUpdateMaxGradYearError");
            UIALogger.logPass("UI successfully prevented user from updating the user with a grad year above the max value of 2014.")
            
            alert.buttons()["OK"].tap();
            
            UIATarget.localTarget().delay(2)
            
            return true;
            
        } else {
            
            UIALogger.logFail("UI should have prevented user from from updating the user with a grad year above the max value of 2014.")
            
        }
        
        return false;
    }
    
    var target = UIATarget.localTarget();
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].setValue("2100")
    
    target.frontMostApp().navigationBar().rightButton().tap();
    
    UIATarget.localTarget().delay(2)
    
}

function testEditRegularUserBelowMinGraduationYear() {
    
    UIATarget.onAlert = function onAlert(alert) {
        
        var title = alert.name();
        var message = alert.scrollViews()[0].staticTexts()[1].value();
        
        if (message == "Grad year must be greater than or equal to 1970") {
            
            UIATarget.localTarget().captureScreenWithName("UserUpdateMinGradYearError");
            UIALogger.logPass("UI successfully prevented user from updating the user with a grad year below the min value of 1970.")
            
            alert.buttons()["OK"].tap();
            
            UIATarget.localTarget().delay(2)
            
            return true;
            
        } else {
            
            UIALogger.logFail("UI should have prevented user from from updating the user with a grad year below the min value of 1970.")
            
        }
        
        return false;
    }
    
    var target = UIATarget.localTarget();
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].setValue("1900")
    
}


function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min)) + min;
}