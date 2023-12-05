import Foundation
import Algorithms

struct Pipe {
    var source: Int
    var destination: Int
    var length: Int
    
    var sourceRange: Range { .init(start: source, end: source + length - 1) }
    var transformValue: Int { destination - source }
    
    init(string: String) {
        let strings = string.components(separatedBy: " ")
        self.source = strings[1].toInt()
        self.destination = strings[0].toInt()
        self.length = strings[2].toInt()
    }
}

struct Range {
    var start: Int
    var end: Int
}

struct Map {
    var pipes: [Pipe]
    
    init(string: String) {
        self.pipes = string.lines.dropFirst().map {
            Pipe(string: $0)
        }
    }
    
    func map(value: Int) -> Int {
        for pipe in pipes {
            if (pipe.source..<(pipe.source + pipe.length)).contains(value) {
                return value + pipe.transformValue
            }
        }
        
        return value
    }
    
    func map(range: Range) -> [Range] {
        let sortedPipes = pipes.sorted(by: { $0.source < $1.source })
        var newRanges: [Range] = []
        
        var currentRangeStart = range.start
        while currentRangeStart <= range.end {
            var newRange: Range
            
            if let currentPipe = sortedPipes.first(where: {
                currentRangeStart >= $0.sourceRange.start && currentRangeStart <= $0.sourceRange.end
            }) {
                // we're in a pipe. map up to the end of the pipe.
                newRange = Range(start: currentRangeStart, end: min(currentPipe.sourceRange.end, range.end))
                let transformedRange = Range(
                    start: newRange.start + currentPipe.transformValue,
                    end: newRange.end + currentPipe.transformValue
                )
                newRanges.append(transformedRange)
            } else {
                // we're not in a pipe. map up to the start of the next pipe, or end of range
                // if there are no more pipes.
                if let nextPipe = sortedPipes.first(where: { $0.source > currentRangeStart }) {
                    newRange = Range(start: currentRangeStart, end: nextPipe.source - 1)
                } else {
                    newRange = Range(start: currentRangeStart, end: range.end)
                }
                
                newRanges.append(newRange)
            }
            
            currentRangeStart = newRange.end + 1
        }
        
        return newRanges
    }
}

struct Day5: Runnable {
    var input: String
    
    func partOne() -> String {
        let seeds = input.lines.first!.splitAndTrim(by: " ").compactMap { Int($0) }
        let maps = input.components(separatedBy: "\n\n").dropFirst().map { Map(string: $0) }
        
        return seeds.map {
            var value = $0
            for map in maps {
                value = map.map(value: value)
            }
            return value
        }
        .min()!
        .description
    }
    
    func partTwo() -> String {
        let seedValues = input.lines.first!.splitAndTrim(by: " ").compactMap { Int($0) }
        var seedRanges: [Range] = []
        
        var i = 0
        while i < seedValues.count {
            let start = seedValues[i]
            seedRanges.append(.init(start: start, end: start + seedValues[i + 1] - 1))
            i += 2
        }
        
        let maps = input.components(separatedBy: "\n\n").dropFirst().map { Map(string: $0) }
        
        for map in maps {
            var newRanges: [Range] = []
            for seedRange in seedRanges {
                newRanges.append(contentsOf: map.map(range: seedRange))
            }
            seedRanges = newRanges
        }
        
        return seedRanges
            .sorted { $0.start < $1.start }
            .first!
            .start
            .description
    }
}
