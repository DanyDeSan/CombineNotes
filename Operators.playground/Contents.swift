import Combine
import Foundation

func exampleOf(_ name: String, example: () -> Void ) {
    print("------** Example of \(name) **------")
    example()
    
    print("------------------------------------")
}

/// TRANSFORMING

var cancellables = Set<AnyCancellable>()

exampleOf("collect") {
    ["a","b","c","d"].publisher
        .collect(2)
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) })
        .store(in: &cancellables)
}

exampleOf("map") {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    
    [44,12,90].publisher
        .map { formatter.string(for: NSNumber(integerLiteral: $0)) ?? "" }
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
}


exampleOf("mapping key paths ") {
    struct Coordinate {
        let x: Int
        let y: Int
    }
    let publisher = PassthroughSubject<Coordinate,Never>()
    
    publisher
        .map(\.x, \.y)
        .sink { x, y in
            print("x:",x)
            print("y:",y)
        }.store(in: &cancellables)
    
    publisher.send(Coordinate(x: 2, y: 4))
    publisher.send(Coordinate(x: 9, y: 3))
}

exampleOf("try map") {
    Just("Directory name that does not exist")
        .tryMap { try FileManager.default.contentsOfDirectory(atPath: $0) }
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) }
        )
        .store(in: &cancellables)
}

exampleOf("flatMap") {
    func decode(_ codes: [Int]) -> AnyPublisher<String, Never> {
        Just( codes
            .compactMap { code in
                guard (32...255).contains(code) else { return nil }
                return String(UnicodeScalar(code) ?? " ")
            }
            .joined() )
        .eraseToAnyPublisher()
    }
    
    [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
      .publisher
      .collect()
      .flatMap(decode)
      .sink(receiveValue: { print($0) })
      .store(in: &cancellables)
}


exampleOf("replace nil") {
    ["A", nil, "C"]
        .publisher
        .eraseToAnyPublisher()
        .replaceNil(with: "-")
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
}


exampleOf("replaceEmtpy") {
    // Publisher that inmediately emits completion event
    let empty = Empty<Int,Never>()
    
    empty
        .replaceEmpty(with: 3)
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
        .store(in: &cancellables)
    
}

exampleOf("scan") {
    var dailyGainLoss: Int { .random(in: -10...10) }
    let august2019 = (0..<20)
        .map { _ in dailyGainLoss }
        .publisher
    august2019.scan(50) { latest, current in
        max(0, latest + current)
    }
    .sink(receiveValue: { _ in  })
    .store(in: &cancellables)
}




/// FILTERING

exampleOf("filter") {
    let numbers = (1...10).publisher
    
    numbers
        .filter { $0.isMultiple(of: 3) }
        .sink {
            print("\($0) is multiple of three!!")
        }
        .store(in: &cancellables)
}

exampleOf("remove duplicates") {
    let words = "hey hey there! your want to listen to mister mister ?"
        .components(separatedBy: " ")
        .publisher
    words
        .removeDuplicates()
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
    
}

exampleOf("compactMap") {
    let strings = [ "1.6", "1.4", "3.6", "NA", "5.7", "NP"]
        .publisher
    
    strings
        .compactMap { Float($0) }
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
}

exampleOf("ignoring") {
    let numbers = (1...10_000).publisher
    numbers
        .ignoreOutput()
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
        .store(in: &cancellables)
}

exampleOf("first(where:)") {
    let numbers = (1...9).publisher
    
    numbers
        .first { element in
        return element % 2 == 0
    }
    .sink(
        receiveCompletion: { print($0) },
        receiveValue: { print($0) }
    )
    .store(in: &cancellables)
}


// Last(where:) is a greedy operator
exampleOf("last(where:)") {
    let numbers = (1...9).publisher
    
    numbers
        .print("numbers")
        .last { element in
            return element % 3 == 0
        }
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        ).store(in: &cancellables)
}

exampleOf("last(where:) passtruogh") {
    let numbersPasstrhough = PassthroughSubject<Int, Never>()
    
    numbersPasstrhough
        .last(where: { $0 % 3 == 0 })
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
        .store(in: &cancellables)
    numbersPasstrhough.send(1)
    numbersPasstrhough.send(5)
    numbersPasstrhough.send(3)
    numbersPasstrhough.send(9)
    numbersPasstrhough.send(11)
    numbersPasstrhough.send(completion: .finished)
}

exampleOf("drop first") {
    let numbers = (1...13).publisher
    
    numbers
        .dropFirst(8)
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
}

exampleOf("drop(while:)") {
    let numbers = (1...14).publisher
    
    numbers
        .drop(while: {
            print("x")
            return $0 % 5 != 0
        })
    /// Once that the predicate of the while is met, it will start emittiing values and the predicate will never be evaluated again
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
}

exampleOf("drop(untilOutputisReady:)") {
    let isReady = PassthroughSubject<Void,Never>()
    let taps = PassthroughSubject<Int,Never>()
    
    taps
        .drop(untilOutputFrom: isReady)
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
    taps.send(3)
    taps.send(9)
    taps.send(1)
    isReady.send()
    taps.send(9)
    taps.send(11)
}

exampleOf("prefix") {
    let numbers = (1...10).publisher
    
    numbers
        .prefix(4)
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
}

exampleOf("prefix(while:)") {
    let numbers = (1...10).publisher
    
    numbers
        .prefix(while: { $0 < 4 })
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
}

exampleOf("prefix(untilOutputFrom:)") {
    let taps = PassthroughSubject<Int,Never>()
    let isReady = PassthroughSubject<Void,Never>()
    
    taps
        .prefix(untilOutputFrom: isReady)
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
    
    taps.send(3)
    taps.send(9)
    taps.send(10)
    isReady.send()
    taps.send(11)
    taps.send(2)
}


/// COMBINING

exampleOf("prepend(Output...)") {
    let publisher = [3, 4].publisher
    
    publisher
        .prepend(5)
        .prepend(-1,0)
        .prepend(1,2)
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
}


exampleOf("prepend(Sequence)") {
    let publisher = [4,6,7].publisher
    publisher
        .prepend([3, 4])
        .prepend(Set(1...5))
        .prepend(stride(from: 6, to: 11, by: 2))
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
}

exampleOf("prepend(Publisher)") {
    let publisher1 = [3,4].publisher
    let publisher2 = [1,2].publisher
    
    publisher1
        .prepend(publisher2)
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
}

exampleOf("prepend(Publisher) #2") {
    let publisher1 = [3,4].publisher
    let publisher2 = PassthroughSubject<Int,Never>()
    
    publisher1
        .prepend(publisher2)
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
    publisher2.send(4)
    publisher2.send(1)
    publisher2.send(completion: .finished)
}


exampleOf("append(output...)") {
    let publisher = [1].publisher
    
    publisher
        .append(1,2)
        .append(9)
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
}


exampleOf("append(output...) #2") {
    let publisher = PassthroughSubject<Int,Never>()
    
    publisher
        .append(3,4)
        .append(5)
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
    publisher.send(1)
    publisher.send(5)
    publisher.send(completion: .finished)
}

exampleOf("append(Sequence)") {
    let publisher = [1,2,3,].publisher
    
    publisher
        .append([4, 5])
        .append([11])
        .append(stride(from: 8, to: 11, by: 2))
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
}

exampleOf("append(Publisher)") {
    let publisher = [1,2].publisher
    let publisher2 = [4,2].publisher
    
    publisher
        .append(publisher2)
        .sink(receiveValue: { print($0) })
        .store(in: &cancellables)
    
}

exampleOf("merge(with)") {
    let publisher1 = PassthroughSubject<Int,Never>()
    let publisher2 = PassthroughSubject<Int,Never>()
    
    publisher1
        .merge(with: publisher2)
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
        .store(in: &cancellables)
    
    publisher1.send(1)
    publisher2.send(2)
    
    publisher2.send(3)
    publisher1.send(4)
    publisher2.send(5)
    
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)
}


exampleOf("combineLatest") {
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<String, Never>()
    
    publisher1
        .combineLatest(publisher2)
        .sink { completion in
            print(completion)
        } receiveValue: { combined in
            print(combined)
        }
    
    publisher1.send(1)
    publisher1.send(2)
    publisher2.send("a")
    publisher2.send("b")
    publisher1.send(3)
    publisher2.send("c")
    
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)
}

exampleOf("zip") {
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<String, Never>()
    
    publisher1
        .zip(publisher2)
        .sink { completion in
            print(completion)
        } receiveValue: { value in
            print(value)
        }
        .store(in: &cancellables)
    
    publisher1.send(1)
    publisher1.send(2)
    publisher2.send("a")
    publisher2.send("b")
    publisher1.send(3)
    publisher2.send("c")
    
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)

}



/// Ejercicios
///
/// 1.
/// Crear un publisher que emita valores del 1 al 100 y que cumpla con los siguientes requisitos
///
///  - Se salte los primeros 30 valores
///  - Tome los siguientes 40 valores despues de los primeros 30
///  - Que solamente tome valores nones
///
/// 2.
///  Crear un publisher que emita una ** cadena** de 10 numeros (numero telefónico) sin espacios ni guiones y que
///  imprima el número telefonico de la siguiente manera:  55-4343-4364. Si el publisher emite una cadena que no corresponda a un número
///  telefónico se debe de imprimir 0
///
///  pj.
///  Input -> 5590921214
///  output -> 55-9092-1214
///
///  input -> 55909212141
///  output -> 0 (número de más)
///
///  input -> 55909a1d14
///  output -> 0 (cadena con carácteres no numéricos
///

