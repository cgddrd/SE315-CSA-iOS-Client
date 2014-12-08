#import "test_create_user_ui.js"
#import "test_edit_user_ui.js"
#import "test_login_ui.js"

function RunUITestsAdminUser(){
    
    // Tests:   
    
    testRejectInvalidUserLogin();

    testSuccessfulAdminUserLogin()
    
    testCreateUserDuplicateUser();
    testCreateUserMissingFields();
    testCreateUserPasswordMismatch();
    
    testSuccessfulEditUser();
    testEditUserNoGraduationYear();
    testEditUserAboveMaxGraduationYear();
    testEditUserBelowMinGraduationYear();
    testDeleteUserCancel();
    testDeleteUserConfirm();

};

RunUITestsAdminUser();

