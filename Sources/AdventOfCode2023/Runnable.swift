import Foundation

protocol Runnable {
    var input: String { get }
    func run()
    func partOne() -> String
    func partTwo() -> String
}

extension Runnable {
    func run() {
        let start1 = CFAbsoluteTimeGetCurrent()
        let part1Result = partOne()
        let time1 = CFAbsoluteTimeGetCurrent() - start1
        
        printResult(name: "Part 1", result: part1Result, time: time1)
        print("")
        
        let start2 = CFAbsoluteTimeGetCurrent()
        let part2Result = partTwo()
        let time2 = CFAbsoluteTimeGetCurrent() - start2
        
        
        printResult(name: "Part 2", result: part2Result, time: time2)
        print("\n")
    }
    
    private func printResult(name: String, result: String, time: CFAbsoluteTime) {
        print("------\(name)------")
        print("|                |")
        let length = result.count
        let space = 10 + name.count - length
        let leftSpace = space / 2
        let rightSpace = space - leftSpace
        
        let timeString = String(format: "(%.1fms)", time * 1000)
        let timeLength = timeString.count
        let timeSpace = 10 + name.count - timeLength
        let leftTimeSpace = timeSpace / 2
        let rightTimeSpace = timeSpace - leftTimeSpace
        
        print("|", terminator: "")
        print(String(repeating: " ", count: leftSpace), terminator: "")
        print(result, terminator: "")
        print(String(repeating: " ", count: rightSpace), terminator: "|\n")
        
        print("|", terminator: "")
        print(String(repeating: " ", count: leftTimeSpace), terminator: "")
        print(timeString, terminator: "")
        print(String(repeating: " ", count: rightTimeSpace), terminator: "|\n")
        
        print("|                |")
        print("|-----\(String(repeating: "-", count: name.count))-----|")
        print("|\(String(repeating: " ", count: name.count + 10))|")
        print("º\(String(repeating: " ", count: name.count + 10))º")
    }
}
