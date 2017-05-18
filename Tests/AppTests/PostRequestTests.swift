import HTTP
import Vapor
import XCTest
@testable import App

class PostRequestTests: TestCase {
    let droplet = try! Droplet.testable()
    
    func testCreate() throws {
        let testContent = "test content"
        let requestBody = try Body(JSON(node: ["content": testContent]))
        
        let request = Request(method: .post,
                              uri: "/posts",
                              headers: ["Content-Type": "application/json"],
                              body: requestBody)
        try droplet.testResponse(to: request)
            .assertStatus(is: .ok)
            .assertJSON("id", passes: { json in json.int != nil })
            .assertJSON("content", equals: testContent)
    }
    
    func testList() throws {
        try Post(content: "List test 1").save()
        try Post(content: "List test 2").save()
        
        let response = try droplet.testResponse(to: .get, at: "/posts")
        
        XCTAssertEqual(response.status, .ok)
        
        guard let json = response.json else {
            XCTFail("Error getting JSON from response \(response)")
            return
        }
        guard let recordArray = json.array else {
            XCTFail("expected response json to be an array")
            return
        }
        XCTAssertEqual(recordArray.count, 2)
        XCTAssertEqual(recordArray.first?.object?["content"]?.string, "List test 1")
    }
}
