import UIKit
import Combine

func example(of name: String, example: () -> Void ) {
    example()
}


let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!

struct Post: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}


var cancellables = Set<AnyCancellable>()

example(of: "dataTaskPublisher") {
    URLSession.shared
        .dataTaskPublisher(for: url)    // output -> (data,response)
        .sink { completion in
            print(completion)
        } receiveValue: { data, response in
            print(data)
            // print(response)
        }.store(in: &cancellables)
}


example(of: "codable") {
    URLSession.shared
        .dataTaskPublisher(for: url)    // output -> (data, response)
        .tryMap { data,_ in
            return try JSONDecoder().decode(Post.self, from: data)
        }                               // output -> Post
        .receive(on: DispatchQueue.main) // Change thread to main
        .sink { completion in
            switch completion {
            case .finished:
                print("finished :)")
            case .failure(let error):
                print("failed :( with: \(error)")
            }
        } receiveValue: { post in
            print(post)
        }.store(in: &cancellables)

}


example(of: "using decode") {
    URLSession.shared
        .dataTaskPublisher(for: url) // output -> (data, response)
        .map { data, _ in
            return data
        }                           // output -> data
        .decode(type: Post.self, decoder: JSONDecoder()) // output -> Post
        .receive(on: DispatchQueue.main) // Change thread to main
        .sink { completion in
            switch completion {
            case .finished:
                print("finished :)")
            case .failure(let error):
                print("failed :( with: \(error)")
            }
        } receiveValue: { post in
            print(post)
        }.store(in: &cancellables)
}



example(of: "multicast") {
    let publisher = URLSession.shared
        .dataTaskPublisher(for: url)
        .map { data, _ in
            return data
        }
        .decode(type: Post.self, decoder: JSONDecoder())
        .multicast {
            return PassthroughSubject<Post,any Error>()
        }
    
    let subscription1 = publisher
        .sink { completion in
            print("Subscription 1:",completion)
        } receiveValue: { post in
            print("Subscription 1:",post)
        }
    
    let subscription2 = publisher
        .sink { completion in
            print("Subscription 2:",completion)
        } receiveValue: { post in
            print("Subscription 2:",post)
        }

    let subscription = publisher.connect()
}


// Based on an example from Apple Developer
// https://developer.apple.com/documentation/combine/publisher/flatmap(maxpublishers:_:)-3k7z5


var postPublisher = PassthroughSubject<String, URLError>()


/// Use of flat map:
/// In order to use flatmap the errors from the main publisher 'weatherPublisher' and URLSession.DataTaskPublisher must match
postPublisher
    .flatMap { postID -> URLSession.DataTaskPublisher in
        let url = URL(string:"https://jsonplaceholder.typicode.com/posts/\(postID)")!
        return URLSession.shared.dataTaskPublisher(for: url)
    }
    .map { result in
        return result.data
    }
    .decode(type: Post.self, decoder: JSONDecoder())
    .sink { completion in
        print("From post passthroug:", completion)
    } receiveValue: { post in
        print("From post passthrough:", post)
    }
    .store(in: &cancellables)

    


postPublisher.send("1")
postPublisher.send("2")
