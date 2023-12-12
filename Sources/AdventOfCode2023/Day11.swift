import Foundation
import Algorithms

struct Day11: Runnable {
    var input: String
    
    func partOne() -> String {
        solution(ageMultiplier: 2)
    }
    
    func partTwo() -> String {
        solution(ageMultiplier: 1000000)
    }
    
    private func solution(ageMultiplier: Int) -> String {
        var galaxies: [Point] = []
        var lines = input.lines
        let width = lines[0].count
        let height = lines.count
        
        var unpopulatedColumns = Set(0..<width)
        var unpopulatedRows = Set(0..<height)
        
        // initialize galaxies map
        lines.enumerated().forEach { line in
            line.element.enumerated().forEach { character in
                if character.element == "#" {
                    unpopulatedColumns.remove(character.offset)
                    unpopulatedRows.remove(line.offset)
                    galaxies.append(.init(x: character.offset, y: line.offset))
                }
            }
        }
        
        // expand based on age multiplier
        for i in (0..<galaxies.count) {
            galaxies[i].x += unpopulatedColumns.filter { $0 < galaxies[i].x }.count * (ageMultiplier - 1)
            galaxies[i].y += unpopulatedRows.filter { $0 < galaxies[i].y }.count * (ageMultiplier - 1)
        }
        
        // get all shortest paths
        var shortestPaths: [Int] = []
        for i in 0..<galaxies.count {
            for j in (i + 1)..<galaxies.count {
                shortestPaths.append(shortestPath(from: galaxies[i], to: galaxies[j]))
            }
        }
        
        return shortestPaths.sum.description
    }
    
    private func shortestPath(from pointA: Point, to pointB: Point) -> Int {
        abs(pointB.x - pointA.x) + abs(pointB.y - pointA.y)
    }
}
