//import XCTest
//
//import SimpleHttpClient
//import DiskStorage
//
//@testable import EtvnetApi
//
//class AuthAPIAsyncTests: XCTestCase {
//  static func getProjectDirectory() -> String {
//    String(URL(fileURLWithPath: #file).pathComponents
//      .prefix(while: { $0 != "Tests" }).joined(separator: "/").dropFirst());
//  }
//
//  static let path = URL(fileURLWithPath: getProjectDirectory())
//
//  static var config = ConfigFile<String>(path: path, fileName: "etvnet.config")
//
//  var subject = EtvnetApiService(configFile: config)
//
//  func testGetActivationCodes() async throws {
//    if let result = try await subject.apiClient.authClient.getActivationCodes() {
//      XCTAssertNotNil(result)
//
//      print("Activation url: \(subject.apiClient.authClient.getActivationUrl())")
//
//      if let userCode = result.userCode {
//        print("Activation code: \(userCode)")
//      }
//
//      if let deviceCode = result.deviceCode {
//        print("Device code: \(deviceCode)")
//      }
//    }
//    else {
//      XCTFail("Error during request")
//    }
//  }
//
//  func testCreateToken() async throws {
//    if let result = try await subject.apiClient.authorization() {
//      print("Register activation code on web site \(subject.apiClient.authClient.getActivationUrl()): \(result.userCode)")
//
//      if let response = await subject.apiClient.createToken(deviceCode: result.deviceCode) {
//        XCTAssertNotNil(response.accessToken)
//        XCTAssertNotNil(response.refreshToken)
//
//        print("Result: \(result)")
//      }
//      else {
//        XCTFail()
//      }
//    }
//    else {
//      XCTFail()
//    }
//  }
//
//  func testUpdateToken() async throws {
//    let refreshToken = subject.apiClient.configFile.items["refresh_token"]!
//
//    if let result = try await self.subject.apiClient.authClient.updateToken(refreshToken: refreshToken) {
//      XCTAssertNotNil(result.accessToken)
//
//      print("Result: \(result)")
//
//      subject.apiClient.configFile.items = result.asMap()
//
//      Task {
//        if (await self.subject.apiClient.configFile.write() != nil) {
//          print("Config saved.")
//        }
//        else {
//          XCTFail()
//        }
//      }
//    }
//    else {
//      XCTFail("Error during request")
//    }
//  }
//}
