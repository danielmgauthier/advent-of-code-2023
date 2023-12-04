import Foundation
import Algorithms

struct Day4: Runnable {
    var input: String
    
    func partOne() -> String {
        input.lines.map { line in
            let winningNumberCount = parseWinningNumberCount(line: line)
            return winningNumberCount == 0 ? 0 : (pow(2, winningNumberCount - 1) as NSDecimalNumber).intValue
        }
        .sum
        .description
    }
    
    func partTwo() -> String {
        let lines = input.lines
        var cardCountMap = (0..<lines.count).reduce(into: [Int: Int]()) { $0[$1] = 1 }
        
        for i in (0..<lines.count) {
            let line = lines[i]
            let winningNumberCount = parseWinningNumberCount(line: line)
            for n in ((i + 1)..<(i + 1 + winningNumberCount)) {
                cardCountMap[n] = cardCountMap[n]! + cardCountMap[i]!
            }
        }
        
        return cardCountMap.values.reduce(0, +).description
    }
    
    private func parseWinningNumberCount(line: String) -> Int {
        let strings = line.splitAndTrim(by: ":")[1].splitAndTrim(by: "|")
        
        return Set(strings[0].splitAndTrim(by: " ").map( { $0.toInt() }))
            .intersection(Set(strings[1].splitAndTrim(by: " ").map { $0.toInt() }))
            .count
    }
}
