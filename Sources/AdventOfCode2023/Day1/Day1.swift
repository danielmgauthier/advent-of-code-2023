import Foundation
import Algorithms

struct Day1: Runnable {
    let lines = Self.input.lines
    
    func partOne() -> String {
        lines.map { line in
            [
                line.first { character in
                    character.isWholeNumber
                }!,
                line.reversed().first { character in
                    character.isWholeNumber
                }!
            ].toString().toInt()
        }
        .sum
        .description
    }
    
    func partTwo() -> String {
        lines.map { line in
            "\(getFirstDigit(in: line, reverseSearch: false))\(getFirstDigit(in: line, reverseSearch: true))".toInt()
        }
        .sum
        .description
    }
    
    private func getFirstDigit(in line: String, reverseSearch: Bool) -> Int {
        var buffer = ""
        let line = reverseSearch ? String(line.reversed()) : line
        for character in line {
            if character.isWholeNumber {
                return character.toInt()
            } else {
                buffer = reverseSearch ? "\(character)\(buffer)" : "\(buffer)\(character)"
                if let digit = buffer.containedDigit() {
                    return digit
                }
            }
        }
        
        fatalError()
    }
}

extension String {
    static let numberMap = [
        "zero": 0,
        "one": 1,
        "two": 2,
        "three": 3,
        "four": 4,
        "five": 5,
        "six": 6,
        "seven": 7,
        "eight": 8,
        "nine": 9
    ]
    
    func containedDigit() -> Int? {
        for length in 3...5 {
            for window in windows(ofCount: length) {
                if let digit = Self.numberMap[String(window)] {
                    return digit
                }
            }
        }
        
        return nil
    }
}
