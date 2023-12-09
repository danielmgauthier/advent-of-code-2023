import Foundation
import Algorithms

struct Race {
    var time: Int
    var distance: Int
}

struct Day6: Runnable {
    var input: String
    
    func partOne() -> String {
        let lines = input.lines
        let times = Array(lines[0].splitAndTrim(by: " ").dropFirst())
        let distances = Array(lines[1].splitAndTrim(by: " ").dropFirst())
        
        var races: [Race] = []
        for i in 0..<times.count {
            races.append(Race(time: times[i].toInt(), distance: distances[i].toInt()))
        }
        
        return races.map { race in
            var winConditions = 0
            for pushTime in 1..<race.time {
                let distanceTraveled = (race.time - pushTime) * pushTime
                if distanceTraveled > race.distance {
                    winConditions += 1
                }
            }
            return winConditions
        }
        .reduce(1) { partialResult, count in
            partialResult * count
        }
        .description
    }
    
    func partTwo() -> String {
        let lines = input.lines
        let time = Double(lines[0]
            .splitAndTrim(by: ":")[1]
            .splitAndTrim(by: " ")
            .reduce(into: "") { $0 = "\($0)\($1)" }
            .toInt()
        )
        
        let distance = Double(lines[1]
            .splitAndTrim(by: ":")[1]
            .splitAndTrim(by: " ")
            .reduce(into: "") { $0 = "\($0)\($1)" }
            .toInt()
        )
        
        let point1 = (time - sqrt((-time * -time) - 4 * distance)) / 2
        let point2 = (time + sqrt((-time * -time) - 4 * distance)) / 2
        
        return (Int(point2) - Int(ceil(point1)) + 1).description
    }
}
