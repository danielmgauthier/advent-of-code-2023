import Foundation
import Algorithms

struct Game {
    var id: Int
    var rounds: [Round]
    
    init(string: String) {
        self.id = string.splitAndTrim(by: ":")[0].splitAndTrim(by: " ")[1].toInt()
        self.rounds = string.splitAndTrim(by: ":")[1].splitAndTrim(by: ";").map(Round.init)
    }
}

struct Round {
    var red: Int = 0
    var green: Int = 0
    var blue: Int = 0
    
    init() {
        self.red = 0
        self.green = 0
        self.blue = 0
    }
    
    init(string: String) {
        string.splitAndTrim(by: ",").forEach {
            let cubeCount = $0.splitAndTrim(by: " ")
            if cubeCount[1] == "red" {
                self.red = cubeCount[0].toInt()
            } else if cubeCount[1] == "green" {
                self.green = cubeCount[0].toInt()
            } else if cubeCount[1] == "blue" {
                self.blue = cubeCount[0].toInt()
            }
        }
    }
}

struct Day2: Runnable {
    var input: String
    
    func partOne() -> String {
        input.lines.map {
            Game(string: $0)
        }.filter { game in
            !game.rounds.contains { round in
                round.blue > 14 || round.green > 13 || round.red > 12
            }
        }
        .map(\.id)
        .sum
        .description
    }
    
    func partTwo() -> String {
        input.lines.map { line in
            let minimums = Game(string: line).rounds.reduce(into: Round()) { partialResult, round in
                if round.red > partialResult.red {
                    partialResult.red = round.red
                }
                
                if round.green > partialResult.green {
                    partialResult.green = round.green
                }
                
                if round.blue > partialResult.blue {
                    partialResult.blue = round.blue
                }
            }
            
            return minimums.red * minimums.green * minimums.blue
        }
        .sum
        .description
    }
}
