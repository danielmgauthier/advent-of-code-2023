import Foundation
import Algorithms

struct Day14: Runnable {
    var input: String
    
    func partOne() -> String {
        var roundRocks: [Set<Point>] = []
        var cubeRocks: Set<Point> = []
        var lines = input.lines
        
        lines.enumerated().forEach { line in
            roundRocks.append([])
            line.element.enumerated().forEach { character in
                if character.element == "O" {
                    roundRocks[line.offset].insert(.init(x: character.offset, y: line.offset))
                } else if character.element == "#" {
                    cubeRocks.insert(.init(x: character.offset, y: line.offset))
                }
            }
        }
        
        var shiftedRoundRocks: Set<Point> = []
        
        for rockLine in roundRocks {
            for rock in rockLine {
                var nextPoint = rock.up
                while nextPoint.y >= 0 && !cubeRocks.contains(nextPoint) && !shiftedRoundRocks.contains(nextPoint) {
                    nextPoint = nextPoint.up
                }
                
                shiftedRoundRocks.insert(nextPoint.down)
            }
        }
        
        var height = lines.count
        return shiftedRoundRocks.map { rock in
            height - rock.y
        }
        .sum
        .description
        
    }
    
    func partTwo() -> String {
        var roundRocks: Set<Point> = []
        var cubeRocks: Set<Point> = []
        var lines = input.lines
        var width = lines[0].count
        var height = lines.count
        
        lines.enumerated().forEach { line in
            line.element.enumerated().forEach { character in
                if character.element == "O" {
                    roundRocks.insert(.init(x: character.offset, y: line.offset))
                } else if character.element == "#" {
                    cubeRocks.insert(.init(x: character.offset, y: line.offset))
                }
            }
        }
        
        var shiftedRoundRocks: Set<Point> = []
        var cycleValues: [Int] = []
        
        while cycleValues.count < 500 {
            // north
            for i in 0..<height {
                for j in 0..<width {
                    let point = Point(x: j, y: i)
                    guard roundRocks.contains(point) else { continue }
                    var nextPoint = point.up
                    while nextPoint.y >= 0 && !cubeRocks.contains(nextPoint) && !shiftedRoundRocks.contains(nextPoint) {
                        nextPoint = nextPoint.up
                    }
                    
                    shiftedRoundRocks.insert(nextPoint.down)
                }
            }
            
            roundRocks = shiftedRoundRocks
            shiftedRoundRocks = []
            
            // west
            for i in 0..<width {
                for j in 0..<height {
                    let point = Point(x: i, y: j)
                    guard roundRocks.contains(point) else { continue }
                    var nextPoint = point.left
                    while nextPoint.x >= 0 && !cubeRocks.contains(nextPoint) && !shiftedRoundRocks.contains(nextPoint) {
                        nextPoint = nextPoint.left
                    }
                    
                    shiftedRoundRocks.insert(nextPoint.right)
                }
            }
            
            roundRocks = shiftedRoundRocks
            shiftedRoundRocks = []
            
            // south
            for i in stride(from: height - 1, through: 0, by: -1) {
                for j in 0..<width {
                    let point = Point(x: j, y: i)
                    guard roundRocks.contains(point) else { continue }
                    var nextPoint = point.down
                    while nextPoint.y < height && !cubeRocks.contains(nextPoint) && !shiftedRoundRocks.contains(nextPoint) {
                        nextPoint = nextPoint.down
                    }
                    
                    shiftedRoundRocks.insert(nextPoint.up)
                }
            }
            
            roundRocks = shiftedRoundRocks
            shiftedRoundRocks = []
            
            // east
            for i in stride(from: width - 1, through: 0, by: -1) {
                for j in 0..<height {
                    let point = Point(x: i, y: j)
                    guard roundRocks.contains(point) else { continue }
                    var nextPoint = point.right
                    while nextPoint.x < width && !cubeRocks.contains(nextPoint) && !shiftedRoundRocks.contains(nextPoint) {
                        nextPoint = nextPoint.right
                    }
                    
                    shiftedRoundRocks.insert(nextPoint.left)
                }
            }
            
            roundRocks = shiftedRoundRocks
            shiftedRoundRocks = []
            
            let valueAfterThisCycle = roundRocks.map { height - $0.y }.sum
            cycleValues.append(valueAfterThisCycle)
        }
        
        // This is sort of a cheat-y way to find a recurring pattern that probably wouldn't work on every possible input.
        // But I suspect it's good enough to do the job most of the time.
        
        let last5 = Array(cycleValues.suffix(5))
        var matchIndices: [Int] = []
        for i in 0..<cycleValues.count {
            if i > cycleValues.count + 4 { break }
            if cycleValues[i] == last5[0] &&
                cycleValues[i + 1] == last5[1] &&
                cycleValues[i + 2] == last5[2] &&
                cycleValues[i + 3] == last5[3] &&
                cycleValues[i + 4] == last5[4] {
                matchIndices.append(i)
            }
        }
        
        let period = matchIndices[matchIndices.count - 1] - matchIndices[matchIndices.count - 2]
        let startOfPeriod = matchIndices[0]
        let fullPattern = Array(cycleValues[startOfPeriod..<startOfPeriod + period])
        let targetCount = 1_000_000_000 - startOfPeriod - 1
        let targetIndex = (targetCount % period)
        return fullPattern[targetIndex].description
    }
}
