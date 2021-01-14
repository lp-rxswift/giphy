import XCTest
import RxSwift
import RxBlocking
import Nimble
import RxNimble
import OHHTTPStubs

@testable import iGif

class iGifTests: XCTestCase {
  let obj = ["array": ["foo", "bar"], "foo": "bar"] as [String: AnyHashable]
  let request = URLRequest(url: URL(string: "http://raywenderlich.com")!)
  let errorRequest = URLRequest(url: URL(string: "http://rw.com")!)
  
  override func setUp() {
    super.setUp()
    stub(condition: isHost("raywenderlich.com")) { _ in
      return HTTPStubsResponse(jsonObject: self.obj, statusCode: 200, headers: nil)
    }
    stub(condition: isHost("rw.com")) { _ in
      return HTTPStubsResponse(error: RxURLSessionError.unknown)
    }
  }
  
  override func tearDown() {
    super.tearDown()
    HTTPStubs.removeAllStubs()
  }

  func testData() {
    let observable = URLSession.shared.rx.data(request: self.request)
    expect(observable.toBlocking().firstOrNil()).toNot(beNil())
  }

  func testString() {
    let observable = URLSession.shared.rx
      .string(request: self.request)
    let result = observable.toBlocking().firstOrNil() ?? ""
    let option1 = "{\"array\":[\"foo\",\"bar\"],\"foo\":\"bar\"}"
    let option2 = "{\"foo\":\"bar\",\"array\":[\"foo\",\"bar\"]}"
    expect(result == option1 || result == option2).to(beTrue())
  }
}

extension BlockingObservable {
  func firstOrNil() -> Element? {
    do {
      return try first()
    } catch {
      return nil
    }
  }
}
