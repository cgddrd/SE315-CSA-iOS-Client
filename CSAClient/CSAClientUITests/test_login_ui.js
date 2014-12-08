function testRejectInvalidUserLogin() {
    
    UIATarget.onAlert = function onAlert(alert) {
        
        var title = alert.name();
        var message = alert.scrollViews()[0].staticTexts()[1].value();
        
        UIALogger.logPass(message)
        
        if (message == "Incorrect username or password, please try again.") {
            
            UIATarget.localTarget().captureScreenWithName("ErrorMessageInvalidLogin");
            UIALogger.logPass("UI successfully prevented login with invalid credentials.")
            
            alert.buttons()["OK"].tap();
            
            UIATarget.localTarget().delay(2)
            
            return true;
            
        } else {
            
            UIALogger.logFail("UI should have prevented user from logging in with invalid credentials.")
            
        }
        
        return false;
    }
   
    var target = UIATarget.localTarget();
    
    target.frontMostApp().mainWindow().textFields()[0].textFields()[0].setValue("fakeusername")
    
    target.frontMostApp().mainWindow().secureTextFields()[0].secureTextFields()[0].setValue("fakepassword")
    
    target.frontMostApp().mainWindow().buttons()["Log In"].tap();
    
    UIATarget.localTarget().delay(2)
    
}

function testSuccessfulAdminUserLogin() {
    
    var target = UIATarget.localTarget();
    
    target.frontMostApp().mainWindow().textFields()[0].textFields()[0].setValue("admin")
    
    target.frontMostApp().mainWindow().secureTextFields()[0].secureTextFields()[0].setValue("taliesin")
    
    target.frontMostApp().mainWindow().buttons()["Log In"].tap();
    
    UIATarget.localTarget().delay(2)
    
}

function testSuccessfulRegularUserLogin() {
    
    var target = UIATarget.localTarget();
    
    target.frontMostApp().mainWindow().textFields()[0].textFields()[0].setValue("clg11")
    
    target.frontMostApp().mainWindow().secureTextFields()[0].secureTextFields()[0].setValue("test123")
    
    target.frontMostApp().mainWindow().buttons()["Log In"].tap();
    
    UIATarget.localTarget().delay(2)
    
}


