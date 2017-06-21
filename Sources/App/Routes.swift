import SQLite
import Vapor

let firebaseBaseUrl = "https://blog-reader-1000.firebaseio.com/kids.json"

class Kid: NodeRepresentable {
    var firstName: String!
    var lastName: String!
    
    func makeNode(in context: Context?) throws -> Node {
        return try Node(node: [
            "firstName": self.firstName,
            "lastName": self.lastName
            ]
        )
    }
}

extension Droplet {
    
    func setupRoutes() throws {
        
        group("kids") { tasks in
            tasks.get("all") { request in
                return try self.client.get(firebaseBaseUrl)
            }
        }
        
        post("kids", "create") { req in
            guard
                let firstName = req.json?["firstName"]?.string,
                let lastName = req.json?["lastName"]?.string else {
                    throw Abort.badRequest
            }
            
            let body = "{\"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\"}".makeBody()
            let response = try self.client.post(firebaseBaseUrl, query: ["": ""], ["Content-Type": "application/json"], body, through: [])
        
            return response.description
        }
        
        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        try resource("posts", PostController.self)
    }
}
