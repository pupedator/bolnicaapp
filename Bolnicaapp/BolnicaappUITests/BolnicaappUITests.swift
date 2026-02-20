import XCTest

// MARK: - Login Flow UI Tests

final class LoginUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testLoginScreen_AppearAfterSplash() {
        let loginTitle = app.staticTexts["Daxil ol"]
        XCTAssertTrue(loginTitle.waitForExistence(timeout: 5))
    }

    func testAppName_DisplaysETebib() {
        let title = app.staticTexts["eTebib"]
        XCTAssertTrue(title.waitForExistence(timeout: 5))
    }

    func testPhoneField_Exists() {
        let field = app.textFields["+994 XX XXX XX XX"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
    }

    func testPasswordField_Exists() {
        let field = app.secureTextFields["Şifrənizi daxil edin"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
    }

    func testLogin_EmptyFields_ShowsAlert() {
        let loginBtn = app.buttons["Daxil ol"]
        XCTAssertTrue(loginBtn.waitForExistence(timeout: 5))
        loginBtn.tap()
        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: 3))
    }

    func testLogin_InvalidPhone_ShowsAlert() {
        let phoneField = app.textFields["+994 XX XXX XX XX"]
        XCTAssertTrue(phoneField.waitForExistence(timeout: 5))
        phoneField.tap()
        phoneField.typeText("123")

        let passField = app.secureTextFields["Şifrənizi daxil edin"]
        passField.tap()
        passField.typeText("pass1234")

        app.buttons["Daxil ol"].tap()

        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: 3))
    }

    func testForgotPassword_ShowsAlert() {
        let btn = app.buttons["Şifrəni unutdun?"]
        XCTAssertTrue(btn.waitForExistence(timeout: 5))
        btn.tap()
        let alert = app.alerts["Şifrəni sıfırla"]
        XCTAssertTrue(alert.waitForExistence(timeout: 3))
    }

    func testRegisterLink_NavigatesToRegister() {
        let registerBtn = app.buttons["Qeydiyyatdan keç"]
        XCTAssertTrue(registerBtn.waitForExistence(timeout: 5))
        registerBtn.tap()
        XCTAssertTrue(app.navigationBars["Qeydiyyat"].waitForExistence(timeout: 3))
    }
}

// MARK: - Registration Flow UI Tests

final class RegisterUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    private func navigateToRegister() throws {
        let btn = app.buttons["Qeydiyyatdan keç"]
        XCTAssertTrue(btn.waitForExistence(timeout: 5))
        btn.tap()
        XCTAssertTrue(app.navigationBars["Qeydiyyat"].waitForExistence(timeout: 3))
    }

    func testRegister_FullNameField_Exists() throws {
        try navigateToRegister()
        XCTAssertTrue(app.textFields["Adınızı daxil edin"].exists)
    }

    func testRegister_PhoneField_Exists() throws {
        try navigateToRegister()
        XCTAssertTrue(app.textFields["+994 XX XXX XX XX"].exists)
    }

    func testRegister_PasswordField_HasUpdatedPlaceholder() throws {
        try navigateToRegister()
        // Placeholder updated from "Minimum 6 simvol" to "Minimum 8 simvol, 1 rəqəm"
        XCTAssertTrue(app.secureTextFields["Minimum 8 simvol, 1 rəqəm"].exists)
    }

    func testRegister_EmptySubmit_ShowsAlert() throws {
        try navigateToRegister()
        app.buttons["Qeydiyyatdan keç"].tap()
        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: 3))
    }

    func testRegister_InvalidPhone_ShowsAlert() throws {
        try navigateToRegister()

        app.textFields["Adınızı daxil edin"].tap()
        app.textFields["Adınızı daxil edin"].typeText("Test User")

        app.textFields["+994 XX XXX XX XX"].tap()
        app.textFields["+994 XX XXX XX XX"].typeText("123") // Invalid

        app.secureTextFields["Minimum 8 simvol, 1 rəqəm"].tap()
        app.secureTextFields["Minimum 8 simvol, 1 rəqəm"].typeText("pass1234")

        app.secureTextFields["Şifrəni yenidən daxil edin"].tap()
        app.secureTextFields["Şifrəni yenidən daxil edin"].typeText("pass1234")

        app.buttons["Qeydiyyatdan keç"].tap()
        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: 3))
    }

    func testRegister_PasswordMismatch_ShowsError() throws {
        try navigateToRegister()

        app.textFields["Adınızı daxil edin"].tap()
        app.textFields["Adınızı daxil edin"].typeText("Test User")

        app.textFields["+994 XX XXX XX XX"].tap()
        app.textFields["+994 XX XXX XX XX"].typeText("+994501234567")

        app.secureTextFields["Minimum 8 simvol, 1 rəqəm"].tap()
        app.secureTextFields["Minimum 8 simvol, 1 rəqəm"].typeText("pass1234")

        app.secureTextFields["Şifrəni yenidən daxil edin"].tap()
        app.secureTextFields["Şifrəni yenidən daxil edin"].typeText("different5")

        app.buttons["Qeydiyyatdan keç"].tap()

        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 3))
        XCTAssertTrue(alert.staticTexts["Şifrələr uyğun gəlmir"].exists)
    }

    func testRegister_WeakPassword_ShowsError() throws {
        try navigateToRegister()

        app.textFields["Adınızı daxil edin"].tap()
        app.textFields["Adınızı daxil edin"].typeText("Test User")

        app.textFields["+994 XX XXX XX XX"].tap()
        app.textFields["+994 XX XXX XX XX"].typeText("+994501234567")

        app.secureTextFields["Minimum 8 simvol, 1 rəqəm"].tap()
        app.secureTextFields["Minimum 8 simvol, 1 rəqəm"].typeText("abc") // Too short

        app.buttons["Qeydiyyatdan keç"].tap()
        XCTAssertTrue(app.alerts.firstMatch.waitForExistence(timeout: 3))
    }

    func testRegister_BackButton_ReturnsToLogin() throws {
        try navigateToRegister()
        // Tap the custom back button (chevron.left)
        let backBtn = app.buttons.matching(NSPredicate(format: "label CONTAINS 'chevron'")).firstMatch
        if backBtn.exists {
            backBtn.tap()
        } else {
            app.navigationBars.buttons.firstMatch.tap()
        }
        XCTAssertTrue(app.staticTexts["Daxil ol"].waitForExistence(timeout: 3))
    }
}

// MARK: - App Launch Tests

final class AppLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool { true }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
