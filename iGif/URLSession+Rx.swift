import Foundation
import RxSwift

public enum RxURLSessionError: Error {
  case unknown
  case invalidResponse(response: URLResponse)
  case requestFailed(response: HTTPURLResponse, data: Data?)
  case deserializationFailed
}

extension Reactive where Base: URLSession {

  func response(request: URLRequest)
  -> Observable<(HTTPURLResponse, Data)> {
    return Observable.create { observer in
      return Disposables.create()
    }
  }
}
