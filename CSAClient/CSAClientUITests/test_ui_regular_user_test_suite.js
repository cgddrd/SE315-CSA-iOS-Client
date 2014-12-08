#import "test_create_user_ui.js"
#import "test_edit_user_ui.js"
#import "test_login_ui.js"

function RunUITestsRegularUser(){
    
    // Tests:   
    
    testRejectInvalidUserLogin();
    
    UIATarget.localTarget().deactivateAppForDuration(2);
    
    testSuccessfulRegularUserLogin();
    
    testCheckRegularUserDetails();
    
    testSuccessfulEditRegularUser();
    
    testEditRegularUserNoGraduationYear();
    testEditRegularUserAboveMaxGraduationYear();
    testEditRegularUserBelowMinGraduationYear();
    
    tearDownResetRegularUserName();
    
}

RunUITestsRegularUser();

function testCheckRegularUserDetails() {
    
    var target = UIATarget.localTarget();
    
    var regularUserNameCellContents = target.frontMostApp().mainWindow().tableViews()[0].cells()[0].name();
    var regularUserName = "Name, Connor Goddard";
    
    if (regularUserNameCellContents == regularUserName){
        UIALogger.logPass("User's displayed name matches expected name: " + regularUserName);
    } else {
        UIALogger.logFail("User's displayed name (" + regularUserNameCellContents + ") does not match expected name: " + regularUserName);
    }
    
    var regularUserEmailCellContents = target.frontMostApp().mainWindow().tableViews()[0].cells()[1].name();
    var regularUserEmail = "Email, clg11@aber.ac.uk";
    
    if (regularUserEmailCellContents == regularUserEmail){
        UIALogger.logPass("User's displayed email matches expected email: " + regularUserEmail);
    } else {
        UIALogger.logFail("User's displayed email (" + regularUserEmailCellContents + ") does not match expected email: " + regularUserEmail);
    }
    
    var regularUserPhoneCellContents = target.frontMostApp().mainWindow().tableViews()[0].cells()[2].name();
    var regularUserPhone = "Phone, 01437891514";
    
    if (regularUserPhoneCellContents == regularUserPhone){
        UIALogger.logPass("User's displayed phone matches expected phone: " + regularUserPhone);
    } else {
        UIALogger.logFail("User's displayed phone (" + regularUserPhoneCellContents + ") does not match expected phone: " + regularUserPhone);
    }
    
    var regularUserGradYearCellContents = target.frontMostApp().mainWindow().tableViews()[0].cells()[3].name();
    var regularUserGradYear = "Graduation Year, 2013";
    
    if (regularUserGradYearCellContents == regularUserGradYear){
        UIALogger.logPass("User's displayed grad year matches expected grad year: " + regularUserGradYear);
    } else {
        UIALogger.logFail("User's displayed grad year (" + regularUserGradYearCellContents + ") does not match expected grad year: " + regularUserGradYear);
    }
    
    var regularUserUsernameCellContents = target.frontMostApp().mainWindow().tableViews()[0].cells()[4].name();
    var regularUserUsername = "Username, clg11";
    
    if (regularUserUsernameCellContents == regularUserUsername){
        UIALogger.logPass("User's displayed username matches expected username: " + regularUserUsername);
    } else {
        UIALogger.logFail("User's displayed username (" + regularUserUsernameCellContents + ") does not match expected username: " + regularUserUsername);
    }
    
    
    
}

function tearDownResetRegularUserName() {
    
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
    
    target.frontMostApp().navigationBar().leftButton().tap();
    
    UIATarget.localTarget().delay(1)
    
    target.frontMostApp().navigationBar().rightButton().tap();
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[0].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[0].textFields()[0].textFields()[0].setValue("Connor");
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[1].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[1].textFields()[0].textFields()[0].setValue("Goddard")
    
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].tap();
    target.frontMostApp().mainWindow().tableViews()[0].cells()[4].textFields()[0].textFields()[0].setValue("2013")
    
    target.frontMostApp().mainWindow().tableViews()[0].tapWithOptions({tapOffset:{x:0.90, y:0.62}});
    
    target.frontMostApp().navigationBar().rightButton().tap();
    
    UIATarget.localTarget().delay(1)
    
}