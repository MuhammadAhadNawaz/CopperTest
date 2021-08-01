//
//  RemoteOrderLoaderTests.swift
//  CopperTestTests
//
//  Created by Muhammad Ahad on 31/07/2021.
//

import XCTest
@testable import CopperTest

class RemoteOrderLoaderTests: XCTestCase {
     
    func test_init_DoesNotLoadRequest() {
        
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestURL.isEmpty)
    }
    
    func test_init_RequestFromURL() {
        let (sut, client) = makeSUT()
        
        sut.load(){ _ in}
        
        XCTAssertFalse(client.requestURL.isEmpty)
    }
    
    func test_LoadRequestFromGivenURL() {
        let url = URL(string: "https://some-given-url")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load(){ _ in}
        
        XCTAssertEqual(client.requestURL, [url])
    }
    
    func test_LoadRequestFromGivenURLTwoTimes() {
        let url = URL(string: "https://some-given-url")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load(){ _ in}
        sut.load(){ _ in}
        
        XCTAssertEqual(client.requestURL, [url, url])
    }
    
    func test_Load_CompleteWithConnectivityErrorOnClientError() {
        let url = URL(string: "https://some-given-url")!
        let (sut, client) = makeSUT(url: url)
        
        expect(sut, completWith: failure(.connectivity)) {
            let error = NSError(domain: "domain", code: 400)
            client.complete(With: error)
        }
    }
    
    func test_Load_CompleteWithInvalidDataOnNON200HTTPResponse() {
        let url = URL(string: "https://some-given-url")!
        let (sut, client) = makeSUT(url: url)
        
        let sample = [199, 201, 299, 300, 400, 500]
        sample.enumerated().forEach { (index, statusCode) in
            expect(sut, completWith: failure(.invalidData)) {
                let emptyJson = makeItemsJson(items: [])
                client.complete(With: statusCode, data: emptyJson, at: index)
            }
        }
    }
    
    func test_Load_CompleteWithErrorOn200HTTPResponseAndInvalidJSON() {
        let url = URL(string: "https://some-given-url")!
        let (sut, client) = makeSUT(url: url)
        
        expect(sut, completWith: failure(.invalidData)) {
            let data = Data("invalid data".utf8)
            client.complete(With: 200, data: data)
        }
    }
    
    func test_Load_CompleteWithEmptyListOn200HTTPResponseAndEmptyJSON() {
        let url = URL(string: "https://some-given-url")!
        let (sut, client) = makeSUT(url: url)
        
        expect(sut, completWith: .success([])) {
            let emptyJson = makeItemsJson(items: [])
            client.complete(With: 200, data: emptyJson)
        }
    }
    
    func test_Load_CompleteWithFeedListOn200HTTPResponseAndJSON() {
        let url = URL(string: "https://some-given-url")!
        let (sut, client) = makeSUT(url: url)
        
        let item1 = makeItem(orderId: UUID().uuidString,
                             currency: "BTC",
                             amount: "123.456",
                             orderType: "deposit",
                            orderStatus: "approved",
                            createdAt: "1523456789875")
        
        let item2 = makeItem(orderId: UUID().uuidString,
                             currency: "BTC",
                             amount: "123.456",
                             orderType: "withdraw",
                            orderStatus: "approved",
                            createdAt: "1523456789875")
        
        expect(sut, completWith: .success([item1.model, item2.model])) {
            let jsonList = makeItemsJson(items: [item1.json, item2.json])
            client.complete(With: 200, data: jsonList)
        }
    }
    
    func test_Load_DoesNotCompleteWhenSUTIsDeAllocated() {
        let url = URL(string: "https://some-given-url")!
        let client = HTTPClientSpy()
        
        var sut: RemoteOrderLoader? = RemoteOrderLoader(url: url, client: client)
        
        var capturedResult: [RemoteOrderLoader.Result] = []
        sut?.load{ error in
            capturedResult.append(error)
        }
        
        sut = nil
        let jsonList = makeItemsJson(items: [])
        client.complete(With: 200, data: jsonList)
        
        XCTAssertTrue(capturedResult.isEmpty)
    }
    
    //MARK: - Helper
    
    private func expect(_ sut: RemoteOrderLoader, completWith expectedResult: RemoteOrderLoader.Result, when action: () -> Void,  file: StaticString = #filePath, line: UInt = #line) {
        
        let exp = expectation(description: "wait for load completion")
        sut.load{ receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteOrderLoader.Error), .failure(expectedError as RemoteOrderLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("expect \(expectedResult), got \(receivedResult)")
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeSUT(url: URL = URL(string: "https://Some-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteOrderLoader, client: HTTPClientSpy ){
        let client = HTTPClientSpy()
        let sut = RemoteOrderLoader(url: url, client: client)
        trackMemoryLeaks(sut, file: file, line: line)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteOrderLoader.Error) -> RemoteOrderLoader.Result {
        return .failure(error)
    }
    
    private func makeItem(orderId: String,
                          currency: String,
                          amount: String,
                          orderType: String,
                          orderStatus: String,
                          createdAt: String) -> (model: OrderModel, json: [String: String]) {
        
        let item = OrderModel(orderId: orderId,
                              currency: currency,
                              amount: amount,
                              orderType: orderType,
                              orderStatus: orderStatus,
                              createdAt: createdAt)

        
        let Json = [
            "orderId": item.orderId,
            "currency": item.currency,
            "amount": item.amount,
            "orderType": item.orderType,
            "orderStatus": item.orderStatus,
            "createdAt": item.createdAt
            
        ].compactMapValues {$0}
        
        return (item, Json)
    }
    
    private func makeItemsJson(items: [[String: Any]]) -> Data {
        let json = ["orders" : items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        var requestURL: [URL] {
            messages.map({ $0.url })
        }
        
        typealias message = (url: URL, completion: ((HTTPClientResult) -> Void)?)
        var messages = [message]()
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(With error: Error, at index: Int = 0) {
            messages[index].completion?(.failure(error))
        }
        
        func complete(With statusCode: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestURL[index], statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            messages[index].completion?(.success(data, response))
        }
    }
    
}
