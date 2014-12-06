
function testCreateUserDuplicateUser() {
    
    UIATarget.onAlert = function onAlert(alert) {
        
        var title = alert.name();
        var message = alert.scrollViews()[0].staticTexts()[1].value();
        
        if (message != "User created successfully.") {
            
            UIATarget.localTarget().captureScreenWithName("ErrorMessageCG");
            UIALogger.logPass("UI successfully prevent user from submitting.")
            
            alert.buttons()["OK"].tap();
            
            UIATarget.localTarget().delay(2)
            
            return true;
            
        } else {
            
            UIALogger.logFail("UI should have prevented user from submitting due to duplicate user.")
            
        }
        
        return false;
    }
    
    var target = UIATarget.localTarget();
    target.frontMostApp().navigationBar().rightButton().tap();
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[0].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[0].textFields()[0].textFields()[0].setValue("Connor")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[1].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[1].textFields()[0].textFields()[0].setValue("Goddard")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[2].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[2].textFields()[0].textFields()[0].setValue("clg11@aber.ac.uk")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[3].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[3].textFields()[0].textFields()[0].setValue("01437891514")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].setValue("2012")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[5].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[5].textFields()[0].textFields()[0].setValue("clg11")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[6].secureTextFields()[0].secureTextFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[6].secureTextFields()[0].secureTextFields()[0].setValue("testblah")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[7].secureTextFields()[0].secureTextFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[7].secureTextFields()[0].secureTextFields()[0].setValue("testblah")
    
    target.frontMostApp().navigationBar().rightButton().tap();
    
    UIATarget.localTarget().delay(2)
    
    target.frontMostApp().navigationBar().leftButton().tap();
    
}


function testCreateUserMissingFields() {
    
    UIATarget.onAlert = function onAlert(alert) {
        
        var title = alert.name();
        var message = alert.scrollViews()[0].staticTexts()[1].value();
        
        if (message == "Ensure all text fields have been entered.") {
            
            UIATarget.localTarget().captureScreenWithName("ErrorMessageEmptyTextFields");
            UIALogger.logPass("UI successfully prevents user from submitting with empty text fields.")
            
            alert.buttons()["OK"].tap();
            
            UIATarget.localTarget().delay(2)
            
            return true;
            
        } else {
            
            UIALogger.logFail("UI should have prevented user from submitting with empty text fields.")
            
        }
        
        return false;
    }
    
    var target = UIATarget.localTarget();
    target.frontMostApp().navigationBar().rightButton().tap();
    
    UIATarget.localTarget().delay(1);
    
    target.frontMostApp().navigationBar().rightButton().tap();
    
    UIATarget.localTarget().delay(2)
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[0].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[0].textFields()[0].textFields()[0].setValue("Connor")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[1].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[1].textFields()[0].textFields()[0].setValue("Goddard")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[2].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[2].textFields()[0].textFields()[0].setValue("clg11@aber.ac.uk")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[3].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[3].textFields()[0].textFields()[0].setValue("01437891514")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].setValue("2012")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[5].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[5].textFields()[0].textFields()[0].setValue("clg11")
    
    target.frontMostApp().navigationBar().rightButton().tap();
    
    target.frontMostApp().navigationBar().leftButton().tap();
}

function testCreateUserPasswordMismatch() {
    
    UIATarget.onAlert = function onAlert(alert) {
        
        var title = alert.name();
        var message = alert.scrollViews()[0].staticTexts()[1].value();
        
        UIALogger.logPass(message)
        
        if (message == "Password confirmation does not match password.") {
            
            UIATarget.localTarget().captureScreenWithName("ErrorMessagePasswordMismatch");
            UIALogger.logPass("UI successfully prevents user from submitting with mismatching passwords.")
            
            alert.buttons()["OK"].tap();
            
            UIATarget.localTarget().delay(2)
            
            return true;
            
        } else {
            
            UIALogger.logFail("UI should have prevented user from submitting with mismatching passwords.")
            
        } 
        
        return false;
    }
    
    var target = UIATarget.localTarget();
    target.frontMostApp().navigationBar().rightButton().tap();
    
    UIATarget.localTarget().delay(1);
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[0].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[0].textFields()[0].textFields()[0].setValue("Connor")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[1].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[1].textFields()[0].textFields()[0].setValue("Goddard")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[2].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[2].textFields()[0].textFields()[0].setValue("clg11@aber.ac.uk")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[3].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[3].textFields()[0].textFields()[0].setValue("01437891514")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].setValue("2012")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[5].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[5].textFields()[0].textFields()[0].setValue("clg11")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[6].secureTextFields()[0].secureTextFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[6].secureTextFields()[0].secureTextFields()[0].setValue("testblah")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[7].secureTextFields()[0].secureTextFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[7].secureTextFields()[0].secureTextFields()[0].setValue("testblahtestblah")
    
    target.frontMostApp().navigationBar().rightButton().tap();
    
    target.frontMostApp().navigationBar().leftButton().tap();
}