import Foundation

extension Array where Element == Int {
    var sum: Int { self.reduce(0, +) }
}

extension Array where Element == Character {
    func toString() -> String {
        String(self)
    }
}

extension Array {
    func chunk(by size: Int) -> [Self] {
        self.enumerated().reduce(into: [Self]()) {
            if $1.offset % size == 0 {
                $0.append([$1.element])
            } else {
                $0[$1.offset / size].append($1.element)
            }
        }
    }
}

extension ClosedRange {
    func contains(_ elements: Bound...) -> Bool {
        elements.allSatisfy { contains($0) }
    }
}

extension StringProtocol {
    func toInt() -> Int {
        Int(self)!
    }
    
    var lines: [String] {
        components(separatedBy: "\n").filter { !$0.isEmpty }
    }
    
    func splitAndTrim(by separator: String) -> [String] {
        components(separatedBy: separator)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
    
    func halveAndTrim(by separator: String) -> (String, String) {
        let array = components(separatedBy: separator)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        return (array[0], array[1])
    }
}

extension Character {
    func toInt() -> Int {
        self.wholeNumberValue!
    }
}

struct Point: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int
    
    var adjacentPoints: [Point] {
        [
            .init(x: x - 1, y: y),
            .init(x: x + 1, y: y),
            .init(x: x, y: y - 1),
            .init(x: x, y: y + 1)
        ]
    }
    
    var description: String {
        "(\(x), \(y))"
    }
    
    var up: Point {
        .init(x: x, y: y - 1)
    }
    
    var down: Point {
        .init(x: x, y: y + 1)
    }
    
    var left: Point {
        .init(x: x - 1, y: y)
    }
    
    var right: Point {
        .init(x: x + 1, y: y)
    }
}

func gcd(_ a: Int, _ b: Int) -> Int {
    let remainder = abs(a) % abs(b)
    if remainder != 0 {
        return gcd(abs(b), remainder)
    } else {
        return abs(b)
    }
}
