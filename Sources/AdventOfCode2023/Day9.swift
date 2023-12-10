import Foundation
import Algorithms

struct Day9: Runnable {
    var input: String
    
    func partOne() -> String {
        input
            .intArrays()
            .map { sequence in
                var sequenceStack = makeDifferenceStack(sequence: sequence)
                
                sequenceStack[0].append(sequenceStack[0][0])
                for i in (1..<sequenceStack.count) {
                    sequenceStack[i].append(sequenceStack[i].last! + sequenceStack[i - 1].last!)
                }
                
                return sequenceStack.last!.last!
            }
            .sum
            .description
    }
    
    func partTwo() -> String {
        input
            .intArrays()
            .map { sequence in
                var sequenceStack = makeDifferenceStack(sequence: sequence)
                
                sequenceStack[0].insert(sequenceStack[0][0], at: 0)
                for i in (1..<sequenceStack.count) {
                    sequenceStack[i].insert(sequenceStack[i][0] - sequenceStack[i - 1][0], at: 0)
                }
                
                return sequenceStack.last![0]
            }
            .sum
            .description
    }
    
    private func makeDifferenceStack(sequence: [Int]) -> [[Int]] {
        var stack = [sequence]
        var differenceSequence = sequence.differenceSequence()
        while differenceSequence.contains(where: { $0 != 0 }) {
            stack.insert(differenceSequence, at: 0)
            differenceSequence = differenceSequence.differenceSequence()
        }
        return stack
    }
}

fileprivate extension Array where Element == Int {
    func differenceSequence() -> [Int] {
        (1..<count).map {
            self[$0] - self[$0 - 1]
        }
    }
}

fileprivate extension String {
    func intArrays() -> [[Int]] {
        lines.map { $0.splitAndTrim(by: " ").map { $0.toInt() } }
    }
}
