import XCTest
@testable import Bolnicaapp

// MARK: - AuthManager Tests

final class AuthManagerTests: XCTestCase {

    var auth: AuthManager!

    override func setUp() {
        super.setUp()
        KeychainHelper.delete(forKey: KeychainHelper.Keys.isLoggedIn)
        KeychainHelper.delete(forKey: KeychainHelper.Keys.userPhone)
        KeychainHelper.delete(forKey: KeychainHelper.Keys.userName)
        UserDefaults.standard.set(0, forKey: "loginAttemptCount")
        UserDefaults.standard.removeObject(forKey: "lockoutUntil")
        auth = AuthManager()
    }

    override func tearDown() {
        auth.logout()
        auth = nil
        super.tearDown()
    }

    // MARK: Login — input validation

    func testLogin_EmptyPhone_ReturnsInvalidInput() {
        let result = auth.login(phone: "", password: "pass1234")
        XCTAssertEqual(result, .invalidInput)
        XCTAssertFalse(auth.isLoggedIn)
    }

    func testLogin_EmptyPassword_ReturnsInvalidInput() {
        let result = auth.login(phone: "+994501234567", password: "")
        XCTAssertEqual(result, .invalidInput)
        XCTAssertFalse(auth.isLoggedIn)
    }

    func testLogin_InvalidPhone_ReturnsInvalidInput() {
        let result = auth.login(phone: "notaphone", password: "pass1234")
        XCTAssertEqual(result, .invalidInput)
        XCTAssertFalse(auth.isLoggedIn)
    }

    func testLogin_ValidInternationalPhone_ReturnsSuccess() {
        let result = auth.login(phone: "+994501234567", password: "anypassword")
        XCTAssertEqual(result, .success)
        XCTAssertTrue(auth.isLoggedIn)
        XCTAssertEqual(auth.currentUserPhone, "+994501234567")
    }

    func testLogin_ValidLocalPhone_ReturnsSuccess() {
        let result = auth.login(phone: "0501234567", password: "anypassword")
        XCTAssertEqual(result, .success)
        XCTAssertTrue(auth.isLoggedIn)
    }

    func testLogin_PersistsPhoneToKeychain() {
        _ = auth.login(phone: "+994501234567", password: "anypassword")
        XCTAssertEqual(KeychainHelper.read(forKey: KeychainHelper.Keys.userPhone), "+994501234567")
        XCTAssertEqual(KeychainHelper.readBool(forKey: KeychainHelper.Keys.isLoggedIn), true)
    }

    // MARK: Login — rate limiting

    func testLogin_LocksOutAfterMaxFailedAttempts() {
        for _ in 0..<5 {
            _ = auth.login(phone: "badphone", password: "badpass")
        }
        XCTAssertTrue(auth.isLockedOut)
    }

    func testLogin_WhenLockedOut_ReturnsLockedOut() {
        for _ in 0..<5 {
            _ = auth.login(phone: "badphone", password: "badpass")
        }
        let result = auth.login(phone: "+994501234567", password: "anypass")
        if case .lockedOut = result { /* pass */ } else {
            XCTFail("Expected .lockedOut but got \(result)")
        }
    }

    func testLogin_LockoutRemainingSecondsIsPositive() {
        for _ in 0..<5 {
            _ = auth.login(phone: "x", password: "y")
        }
        XCTAssertGreaterThan(auth.lockoutRemainingSeconds, 0)
    }

    func testLogin_SuccessResetsAttemptCount() {
        // 3 failed attempts (below lockout threshold)
        for _ in 0..<3 {
            _ = auth.login(phone: "x", password: "y")
        }
        _ = auth.login(phone: "+994501234567", password: "anypass")
        XCTAssertFalse(auth.isLockedOut)
    }

    // MARK: Register

    func testRegister_EmptyName_Fails() {
        let result = auth.register(name: "", phone: "+994501234567", password: "pass1234")
        XCTAssertFalse(result)
        XCTAssertFalse(auth.isLoggedIn)
    }

    func testRegister_WhitespaceName_Fails() {
        let result = auth.register(name: "   ", phone: "+994501234567", password: "pass1234")
        XCTAssertFalse(result)
    }

    func testRegister_InvalidPhone_Fails() {
        let result = auth.register(name: "Ali", phone: "notphone", password: "pass1234")
        XCTAssertFalse(result)
    }

    func testRegister_WeakPassword_Fails() {
        let result = auth.register(name: "Ali", phone: "+994501234567", password: "short1")
        XCTAssertFalse(result)
    }

    func testRegister_NoDigitPassword_Fails() {
        let result = auth.register(name: "Ali", phone: "+994501234567", password: "abcdefgh")
        XCTAssertFalse(result)
    }

    func testRegister_ValidData_Succeeds() {
        let result = auth.register(name: "Aynur Məmmədova", phone: "+994501234567", password: "pass1234")
        XCTAssertTrue(result)
        XCTAssertTrue(auth.isLoggedIn)
        XCTAssertEqual(auth.currentUserName, "Aynur Məmmədova")
    }

    func testRegister_TrimsNameWhitespace() {
        _ = auth.register(name: "  Ali  ", phone: "+994501234567", password: "pass1234")
        XCTAssertEqual(auth.currentUserName, "Ali")
    }

    // MARK: Logout

    func testLogout_ClearsLoginState() {
        _ = auth.login(phone: "+994501234567", password: "anypass")
        auth.logout()
        XCTAssertFalse(auth.isLoggedIn)
        XCTAssertTrue(auth.currentUserPhone.isEmpty)
        XCTAssertTrue(auth.currentUserName.isEmpty)
    }

    func testLogout_ClearsKeychain() {
        _ = auth.login(phone: "+994501234567", password: "anypass")
        auth.logout()
        XCTAssertNil(KeychainHelper.read(forKey: KeychainHelper.Keys.userPhone))
        XCTAssertNil(KeychainHelper.readBool(forKey: KeychainHelper.Keys.isLoggedIn))
    }
}

// MARK: - Phone Validation Tests

final class PhoneValidationTests: XCTestCase {

    func testValid_InternationalFormat_050() {
        XCTAssertTrue(AuthManager.isValidAzerbaijaniPhone("+994501234567"))
    }

    func testValid_InternationalFormat_070() {
        XCTAssertTrue(AuthManager.isValidAzerbaijaniPhone("+994701234567"))
    }

    func testValid_InternationalFormat_012() {
        XCTAssertTrue(AuthManager.isValidAzerbaijaniPhone("+994121234567"))
    }

    func testValid_LocalFormat_050() {
        XCTAssertTrue(AuthManager.isValidAzerbaijaniPhone("0501234567"))
    }

    func testValid_LocalFormat_077() {
        XCTAssertTrue(AuthManager.isValidAzerbaijaniPhone("0771234567"))
    }

    func testInvalid_EmptyString() {
        XCTAssertFalse(AuthManager.isValidAzerbaijaniPhone(""))
    }

    func testInvalid_TooShort() {
        XCTAssertFalse(AuthManager.isValidAzerbaijaniPhone("+994123"))
    }

    func testInvalid_TooLong() {
        XCTAssertFalse(AuthManager.isValidAzerbaijaniPhone("+99450123456789"))
    }

    func testInvalid_WrongCountryCode() {
        XCTAssertFalse(AuthManager.isValidAzerbaijaniPhone("+1234567890"))
    }

    func testInvalid_Letters() {
        XCTAssertFalse(AuthManager.isValidAzerbaijaniPhone("notaphone"))
    }

    func testInvalid_OnlyDigitsNoPrefix() {
        XCTAssertFalse(AuthManager.isValidAzerbaijaniPhone("12345678901"))
    }
}

// MARK: - Password Validation Tests

final class PasswordValidationTests: XCTestCase {

    func testValid_EightCharsWithDigit() {
        XCTAssertTrue(AuthManager.isValidPassword("abcdefg1"))
    }

    func testValid_LongPassword() {
        XCTAssertTrue(AuthManager.isValidPassword("password123"))
    }

    func testValid_StartsWithDigit() {
        XCTAssertTrue(AuthManager.isValidPassword("1abcdefg"))
    }

    func testInvalid_TooShort() {
        XCTAssertFalse(AuthManager.isValidPassword("abc1"))
    }

    func testInvalid_SevenChars() {
        XCTAssertFalse(AuthManager.isValidPassword("abcdef1"))
    }

    func testInvalid_NoDigits() {
        XCTAssertFalse(AuthManager.isValidPassword("abcdefgh"))
    }

    func testInvalid_Empty() {
        XCTAssertFalse(AuthManager.isValidPassword(""))
    }
}

// MARK: - KeychainHelper Tests

final class KeychainHelperTests: XCTestCase {

    private let testKey = "test.keychainhelper.unit"

    override func tearDown() {
        KeychainHelper.delete(forKey: testKey)
        super.tearDown()
    }

    func testSaveAndRead_ReturnsStoredValue() {
        let saved = KeychainHelper.save("helloWorld", forKey: testKey)
        XCTAssertTrue(saved)
        XCTAssertEqual(KeychainHelper.read(forKey: testKey), "helloWorld")
    }

    func testOverwrite_ReturnsNewValue() {
        KeychainHelper.save("first", forKey: testKey)
        KeychainHelper.save("second", forKey: testKey)
        XCTAssertEqual(KeychainHelper.read(forKey: testKey), "second")
    }

    func testRead_MissingKey_ReturnsNil() {
        XCTAssertNil(KeychainHelper.read(forKey: "definitely.not.here.xyz"))
    }

    func testDelete_RemovesValue() {
        KeychainHelper.save("value", forKey: testKey)
        KeychainHelper.delete(forKey: testKey)
        XCTAssertNil(KeychainHelper.read(forKey: testKey))
    }

    func testSaveBoolTrue_RoundTrips() {
        KeychainHelper.saveBool(true, forKey: testKey)
        XCTAssertEqual(KeychainHelper.readBool(forKey: testKey), true)
    }

    func testSaveBoolFalse_RoundTrips() {
        KeychainHelper.saveBool(false, forKey: testKey)
        XCTAssertEqual(KeychainHelper.readBool(forKey: testKey), false)
    }

    func testReadBool_MissingKey_ReturnsNil() {
        XCTAssertNil(KeychainHelper.readBool(forKey: "definitely.not.here.bool"))
    }

    func testSaveEmptyString() {
        let saved = KeychainHelper.save("", forKey: testKey)
        XCTAssertTrue(saved)
        XCTAssertEqual(KeychainHelper.read(forKey: testKey), "")
    }

    func testSaveUnicodeString() {
        let value = "Aynur Məmmədova +994501234567"
        KeychainHelper.save(value, forKey: testKey)
        XCTAssertEqual(KeychainHelper.read(forKey: testKey), value)
    }
}
