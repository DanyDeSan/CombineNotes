import UIKit
import Combine



// We must do our examples inside of function or clases because @Published is not supported on top level code

var sequence = (1...10)
var publisher = sequence.publisher
var subscriber = publisher.sink { value in
    print(value)
}

var anotherSubscriber = publisher.sink { completion in
    switch completion {
    case .finished:
        print("Finished :)")
    case .failure:
        print("Finished with failure :(")
    }
} receiveValue: { value in
    print("From subscriber 2 ",value)
}

anotherSubscriber.cancel()

var onlyPairNumbersSubscriber = publisher.filter { element in
    return element % 2 == 0
}.sink { value in
    print(value)
}

var onlyNonNumbersSubscriber = publisher.filter { element in
    return element % 2 != 0
}.sink { value in
    print(value)
}

var allNumbersMultipliedBy3Subscriber = publisher.map { value in
    return value * 2
}.sink { value in
    print(value)
}

var allStringNumbersSubscriber = publisher.map { value in
    return String(value)
}.sink { value in
    print(value)
    print(type(of: value))
}


let aNotification = Notification.Name("MyNotification")
let center = NotificationCenter.default

let notificationCenterPublisher = center.publisher(for: aNotification)

let notificationSubscription = notificationCenterPublisher.sink { _ in
    print("Notification received from a publisher!")
}

center.post(name: aNotification, object: nil)
notificationSubscription.cancel()

// How to create a publisher value

class NewsEditorial {
    ///  Here we add @Published wrapper
    ///  which makes the variable a publisher and also allow us to handle a variable as it is
    ///     when we assign a new value to the variable it will publish that new value
    @Published var newIssue: String = "Issue 1"
    
    func publishNewIssue(issue: String) {
        newIssue = issue
    }
}

class Reader {
    var favoriteEditorial: NewsEditorial
    var cancellables = Set<AnyCancellable>()
    
    init(favoriteEditorial: NewsEditorial) {
        self.favoriteEditorial = favoriteEditorial
    }
    
    func subscribeToFavoriteEditorial() {
        favoriteEditorial.$newIssue.sink { newIssue in
            print("New issue: \(newIssue)")
        }.store(in: &cancellables)

    }
}


let reforma = NewsEditorial()
let daniel = Reader(favoriteEditorial: reforma)

daniel.subscribeToFavoriteEditorial()

reforma.publishNewIssue(issue: "Issue 4")
reforma.publishNewIssue(issue: "Issue 5")

// How to republish
class EditorialDistributor {
    @Published var distributedIssue: String = "Issue 0"
}


var sanborns = EditorialDistributor()

reforma.$newIssue.assign(to: &sanborns.$distributedIssue)

let sanbornsSubscription = sanborns.$distributedIssue.sink { issue in
    print("received redistributed issue :", issue)
}


reforma.publishNewIssue(issue: "Issue 7")


// How to assign a published value to a variable without sink

class NewsPaperShop {
    var lastIssue: String = ""
    
    func checkLastIssue() {
        print("Last issue on shop", lastIssue)
    }
}


var newsPaperShop = NewsPaperShop()

reforma.$newIssue.assign(to: \.lastIssue, on: newsPaperShop)

newsPaperShop.checkLastIssue()


// JUST


/// It will emit a single value and no error
let justPublisher = Just(10)

let justSubscriber = justPublisher.sink { completion in
    print(completion)
} receiveValue: { value in
    print(value)
}



// FUTURE

// The future will only start its work when there is one subscriber subscribed

let future = Future<Int,Never> { promise in
    // Do some work here
    
    // Through the promise we emit and publish a value
    promise(.success(113))
}

let futureSubscriber = future.sink { completion in
    print(completion)
} receiveValue: { value in
    print(value)
}


// Example of a delaying future with error defined

enum CustomError: Error {
    case anError
}

func exampleOfFuture(delay: TimeInterval, shouldFail: Bool, value: Int) -> Future<Int,CustomError> {
    return Future<Int,CustomError> { promise in
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            if shouldFail {
                promise(.failure(.anError))
            } else {
                promise(.success(value))
            }
        }
    }
}


let futureSubscriber1 = exampleOfFuture(delay: 2, shouldFail: false, value: 1).sink { completion in
    print(completion)
} receiveValue: { value in
    print(value)
}


let futureSubscriber2 = exampleOfFuture(delay: 1, shouldFail: true, value: 3).sink { compleiton in
    print(compleiton)
} receiveValue: { value in
    print(value)
}


let futureSubscriber3 = exampleOfFuture(delay: 20, shouldFail: false, value: 123).sink { compleiton in
    print(compleiton)
} receiveValue: { value in
    print(value)
}

/// SUBJECTS
/// Allow us to send values manually or in an imperative way


// PASSTHROUGH Subject

let subjet = PassthroughSubject<String,CustomError>()

let subjectSubscriber1 = subjet.sink { completion in
    print("Subscriber1", completion)
} receiveValue: { value in
    print("Subscriber1", value)
}


let subjectSubscriber2 = subjet.sink { completion in
    print("Subscriber2", completion)
} receiveValue: { value in
    print("Subscriber2", value)
}

subjet.send("Hello there!")
subjet.send("Hello again!")
subjectSubscriber1.cancel()
subjet.send("Bye!")
subjet.send(completion: .finished)
/**
    It can also be
 subject.send(completion: .failure(CustomError.anError))
 
 */


/// CURRENT VALUE SUBJECTS
///

let currentValueSubject = CurrentValueSubject<Int,Never>(0)

let currentValueSubscriber = currentValueSubject
    .print()
    .sink { value in
    print("From current value subscriber", value)
}

currentValueSubject.send(1)
currentValueSubject.send(4)


// We can directly ask the current value of the subject
print(currentValueSubject.value)

currentValueSubject.value = 3
print(currentValueSubject.value)


/// ERASE TO ANY PUBLISHER
/// This is helpful when you hide the type of subscriber that you are passing.

func makeANetworkCall() -> AnyPublisher<String,CustomError> {
    return Future<String,CustomError> { promise in
        print("Making a network")
        promise(.success("Response"))
    }.eraseToAnyPublisher()
}


let networkCallSubscriber = makeANetworkCall().sink { completion in
    print("network call finished", completion)
} receiveValue: { value in
    print("Network call response", value)
}

