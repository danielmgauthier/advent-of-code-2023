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
        components(separatedBy: separator).map { $0.trimmingCharacters(in: .whitespaces) }
    }
}

extension Character {
    func toInt() -> Int {
        self.wholeNumberValue!
    }
}

struct Point: Hashable {
    var x: Int
    var y: Int
}
