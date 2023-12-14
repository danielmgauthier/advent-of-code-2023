import Foundation
import Algorithms

// This is bad, terrible, unreadable code. Took me way too long to find the strategy here, and now that I've found it,
// I'm sure I could vastly simplify this, but...I don't want to. Do not, under any circumstances, attempt to understand what this code does.
//
// (it does work though)

struct Day12: Runnable {
    var input: String

    struct Memo: Hashable {
     var nextCharacter: Character
        var testString: String
        var actualSolution: [Int]
    }
    
    static var solutions: [Memo: Int] = [:]
    
    func partOne() -> String {
        input.lines.map { line in
            let (testString, solutionString) = line.halveAndTrim(by: " ")
            let solution = solutionString.components(separatedBy: ",").map { $0.toInt() }
            
            return getSolutionCount(
                nextCharacter: "#",
                testString: testString,
                actualSolution: solution
            )
            + getSolutionCount(
                nextCharacter: ".",
                testString: testString,
                actualSolution: solution
            )
        }
        .sum
        .description
    }
    
    func partTwo() -> String {
        let unfoldedLines = input.lines.map { line in
            let (test, solution) = line.halveAndTrim(by: " ")
            let newTest = Array(repeating: test, count: 5).joined(separator: "?")
            let newSolution = Array(repeating: solution, count: 5).joined(separator: ",")
            return newTest + " " + newSolution
        }
        
        return unfoldedLines.map { line in
            let (testString, solutionString) = line.halveAndTrim(by: " ")
            let solution = solutionString.components(separatedBy: ",").map { $0.toInt() }
            
            return getSolutionCount(
                nextCharacter: "#",
                testString: testString,
                actualSolution: solution
            )
            + getSolutionCount(
                nextCharacter: ".",
                testString: testString,
                actualSolution: solution
            )
        }
        .sum
        .description
    }
    
    private func getSolutionCount(
        nextCharacter: Character,
        testString: String,
        actualSolution: [Int]
    ) -> Int {
        
        let memo = Memo(nextCharacter: nextCharacter, testString: testString, actualSolution: actualSolution)
        if let value = Self.solutions[memo] { return value }
        
        if let (newTestString, truncatedSolution) = processMatch(nextCharacter: nextCharacter, testString: testString, actualSolution: actualSolution) {
            if !newTestString.contains("?") {
                Self.solutions[memo] = 1
                return 1
            } else {
                let value = getSolutionCount(nextCharacter: ".", testString: newTestString, actualSolution: truncatedSolution) +
                getSolutionCount(nextCharacter: "#", testString: newTestString, actualSolution: truncatedSolution)
                
                Self.solutions[memo] = value
                return value
            }
        } else {
            Self.solutions[memo] = 0
            return 0
        }
    }
    
    private func processMatch(nextCharacter: Character, testString: String, actualSolution: [Int]) -> (String, [Int])? {
        if !isSatisfiable(testString: testString, solution: actualSolution) {
            return nil
        }
        
        var partialSolution: [Int] = []
        var damageBuffer = 0
        var newTestArray: [Character] = []
        var nextCharacter: Character? = nextCharacter
        var truncationIndex = 0
        var solutionTruncationIndex = 0
        
        var shouldSkipDamageBuffer = false
        var index = 0
        for var character in testString {
            if character == "?" {
                // this just makes sure that I only attempt to do 1 character replacement with nextCharacter,
                // and I don't keep attempting to count up a solution after that — partialSolution gets halted there
                if let replacement = nextCharacter {
                    character = replacement
                    nextCharacter = nil
                } else {
                    shouldSkipDamageBuffer = true
                }
            }
            
            if !shouldSkipDamageBuffer {
                if character == "#" {
                    damageBuffer += 1
                } else {
                    if damageBuffer > 0 {
                        partialSolution.append(damageBuffer)
                        truncationIndex = index + 1
                        solutionTruncationIndex = partialSolution.count
                        damageBuffer = 0
                    }
                }
            }
            
            newTestArray.append(character)
            index += 1
        }
        
        if damageBuffer > 0 { partialSolution.append(damageBuffer) }
        
        // If we're checking for a full match, needs to match exactly.
        // Else, we're just checking to see if this particular character set is still tenable
        let newTestString = String(newTestArray)
        if !newTestString.contains("?") {
            if partialSolution == actualSolution {
                return ("", [])
            } else {
                return nil
            }
        } else {
            if partialSolution.isEmpty {
                return (newTestString, actualSolution)
            } else if partialSolution.count > actualSolution.count {
                return nil
            } else {
                for i in 0..<partialSolution.count {
                    // if a solution group is too big, bail
                    if partialSolution[i] > actualSolution[i] ||
                        // if we have moved onto another solution group and this one doesn't match, bail
                        (partialSolution.count > i + 1 && partialSolution[i] != actualSolution[i]) ||
                        // if we have finished this group with a . and it doesn't match ,bail
                        partialSolution.count == solutionTruncationIndex && partialSolution[i] != actualSolution[i] {
                        return nil
                    }
                }
            }
            
            var truncatedSolution = Array(actualSolution.suffix(from: solutionTruncationIndex))
            var truncatedString = String(newTestArray.suffix(from: truncationIndex))
            return (truncatedString, truncatedSolution)
        }
    }
    
    private func isSatisfiable(testString: String, solution: [Int]) -> Bool {
        if testString.filter({ $0 == "?" || $0 == "#" }).count < solution.sum {
            return false
        }
        
        return true
    }
}
