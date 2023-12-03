import Foundation
import Algorithms

class PartNumber {
    let value: Int
    let points: [Point]
    let adjacentPoints: Set<Point>
    
    init(value: Int, points: [Point]) {
        self.value = value
        self.points = points
        
        var adjacentPoints: Set<Point> = []
        for point in points {
            adjacentPoints.insert(.init(x: point.x, y: point.y - 1))
            adjacentPoints.insert(.init(x: point.x, y: point.y + 1))
        }
        
        for i in -1...1 {
            adjacentPoints.insert(.init(x: points[0].x - 1, y: points[0].y + i))
            adjacentPoints.insert(.init(x: points.last!.x + 1, y: points.last!.y + i))
        }
        
        self.adjacentPoints = adjacentPoints
    }
    
    func isAdjacentTo(symbols: Set<Point>) -> Bool {
        for symbol in symbols {
            if adjacentPoints.contains(symbol) {
                return true
            }
        }
        
        return false
    }
}

struct Day3: Runnable {
    var input: String
    
    func partOne() -> String {
        let (partNumbers, symbols) = parseEngine()
        
        return partNumbers.filter {
            $0.isAdjacentTo(symbols: symbols)
        }
        .map(\.value)
        .sum
        .description
    }
    
    func partTwo() -> String {
        let (partNumbers, symbols) = parseEngine(targetSymbol: "*")
        
        return symbols.map { symbol in
            partNumbers.filter { $0.isAdjacentTo(symbols: [symbol]) }.map(\.value)
        }
        .filter { $0.count == 2 }
        .map { $0[0] * $0[1] }
        .sum
        .description
    }
    
    private func parseEngine(targetSymbol: Character? = nil) -> ([PartNumber], Set<Point>) {
        var partNumbers: [PartNumber] = []
        var symbols: Set<Point> = []
        
        for (row, line) in input.lines.map(Array.init).enumerated() {
            var column = 0
            while column < line.count {
                let character = line[column]
                if character.isWholeNumber {
                    let startColumn = column
                    var numberBuffer = "\(character)"
                    column += 1
                    while column < line.count, line[column].isWholeNumber {
                        numberBuffer = "\(numberBuffer)\(line[column])"
                        column += 1
                    }
                    
                    column -= 1
                    var points: [Point] = []
                    for i in (startColumn...column) {
                        points.append(.init(x: i, y: row))
                    }
                    
                    partNumbers.append(PartNumber(value: numberBuffer.toInt(), points: points))
                } else if character == targetSymbol || (targetSymbol == nil && character != ".") {
                    symbols.insert(.init(x: column, y: row))
                }
                
                column += 1
            }
        }
        
        return (partNumbers, symbols)
    }
}
