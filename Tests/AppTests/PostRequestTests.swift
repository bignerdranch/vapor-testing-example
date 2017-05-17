import HTTP
import Vapor
import XCTest

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
}
