import Foundation
import Algorithms

fileprivate struct Map {
    var width: Int
    var height: Int
    var rowStrings: [String]
    var columnStrings: [String]
    
    init(string: String) {
        self.rowStrings = string.lines
        self.width = self.rowStrings[0].count
        self.height = self.rowStrings.count
        
        var rowArrays = string.lines.map(Array.init)
        self.columnStrings = []
        
        for columnIndex in (0..<self.width) {
            var columnArray: [Character] = []
            for rowIndex in (0..<self.height) {
                columnArray.append(rowArrays[rowIndex][columnIndex])
            }
            
            self.columnStrings.append(String(columnArray))
        }
    }
    
    var verticalMirrorIndex: Int? {
        mirrorIndex(strings: columnStrings, size: width)
    }
    
    var horizontalMirrorIndex: Int? {
        mirrorIndex(strings: rowStrings, size: height)
    }
    
    var smudgedVerticalMirrorIndex: Int? {
        smudgedMirrorIndex(strings: columnStrings, size: width)
    }
    
    var smudgedHorizontalMirrorIndex: Int? {
        smudgedMirrorIndex(strings: rowStrings, size: height)
    }
    
    private func mirrorIndex(strings: [String], size: Int) -> Int? {
        for i in (0..<size - 1) {
            var distance = 0
            var isMirror = true
            while i - distance >= 0 && i + distance + 1 < size {
                if strings[i - distance] != strings[i + distance + 1] {
                    isMirror = false
                    break
                }
                distance += 1
            }
            
            if isMirror {
                return i
            }
        }
        
        return nil
    }
    
    private func smudgedMirrorIndex(strings: [String], size: Int) -> Int? {
        for i in (0..<size - 1) {
            var distance = 0
            var stringDifference = 0
            while i - distance >= 0 && i + distance + 1 < size {
                stringDifference += levenshteinDistance(strings[i - distance], strings[i + distance + 1])
                distance += 1
            }
            
            if stringDifference == 1 {
                return i
            }
        }
        
        return nil
    }
    
    private func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        let empty = [Int](repeating: 0, count: s2.count)
        var last = [Int](0...s2.count)

        for (i, char1) in s1.enumerated() {
            var cur = [i + 1] + empty
            for (j, char2) in s2.enumerated() {
                cur[j + 1] = char1 == char2 ? last[j] : min(last[j], last[j + 1], cur[j]) + 1
            }
            last = cur
        }
        return last.last!
    }
}

struct Day13: Runnable {
    var input: String
    
    func partOne() -> String {
        input
            .splitAndTrim(by: "\n\n")
            .map { string in
                let map = Map(string: string)
                return ((map.verticalMirrorIndex ?? -1) + 1) + 100 * ((map.horizontalMirrorIndex ?? -1) + 1)
            }
            .sum
            .description
    }
    
    func partTwo() -> String {
        input
            .splitAndTrim(by: "\n\n")
            .map { string in
                let map = Map(string: string)
                return ((map.smudgedVerticalMirrorIndex ?? -1) + 1) + 100 * ((map.smudgedHorizontalMirrorIndex ?? -1) + 1)
            }
            .sum
            .description
    }
}
