import Foundation
import Algorithms

struct Day16: Runnable {
    fileprivate struct Memo: Hashable {
        var point: Point
        var direction: Direction
    }
    
    fileprivate static var visited: Set<Memo> = []
    
    var input: String
    
    func partOne() -> String {
        let map = generateMap(from: input)
        var energized: Set<Point> = []
        move(point: .init(x: -1, y: 0), direction: .right, map: map, energized: &energized)
        return energized.count.description
    }
    
    func partTwo() -> String {
        let map = generateMap(from: input)
        
        var topScore = 0
        for x in 0..<map.width {
            var topEnergized: Set<Point> = []
            move(point: .init(x: x, y: -1), direction: .down, map: map, energized: &topEnergized)
            Self.visited = []
            var bottomEnergized: Set<Point> = []
            move(point: .init(x: x, y: map.height), direction: .up, map: map, energized: &bottomEnergized)
            topScore = max(max(topScore, topEnergized.count), bottomEnergized.count)
        }
        
        for y in 0..<map.height {
            Self.visited = []
            var leftEnergized: Set<Point> = []
            move(point: .init(x: -1, y: y), direction: .right, map: map, energized: &leftEnergized)
            Self.visited = []
            var rightEnergized: Set<Point> = []
            move(point: .init(x: map.width, y: y), direction: .left, map: map, energized: &rightEnergized)
            topScore = max(max(topScore, leftEnergized.count), rightEnergized.count)
        }
        
        return topScore.description
    }
    
    fileprivate func move(point: Point, direction: Direction, map: Map, energized: inout Set<Point>) {
        if Self.visited.contains(.init(point: point, direction: direction)) {
            return
        } else {
            Self.visited.insert(.init(point: point, direction: direction))
        }
        
        let newPoint = point.moved(direction)
        if newPoint.isInBounds(width: map.width, height: map.height) {
            energized.insert(newPoint)
        } else {
            return
        }
        
        if let bouncer = map.bouncers[newPoint] {
            bouncer.outputs(input: direction).forEach {
                move(point: newPoint, direction: $0, map: map, energized: &energized)
            }
        } else {
            move(point: newPoint, direction: direction, map: map, energized: &energized)
        }
    }
    
    private func generateMap(from input: String) -> Map {
        let lines = input.lines
        let width = lines[0].count
        let height = lines.count
        var bouncers: [Point: Bouncer] = [:]
        
        lines.enumerated().forEach { row, line in
            line.enumerated().forEach { column, character in
                if let bouncer = Bouncer(character) {
                    bouncers[.init(x: column, y: row)] = bouncer
                }
            }
        }
        
        return Map(bouncers: bouncers, width: width, height: height)
    }
}

fileprivate struct Map {
    var bouncers: [Point: Bouncer]
    var width: Int
    var height: Int
}

fileprivate enum Bouncer {
    case forwardMirror
    case backwardMirror
    case verticalSplitter
    case horizontalSplitter
    
    init?(_ character: Character) {
        switch character {
        case "/": self = .forwardMirror
        case "\\": self = .backwardMirror
        case "-": self = .horizontalSplitter
        case "|": self = .verticalSplitter
        default: return nil
            
        }
    }
    
    func outputs(input: Direction) -> [Direction] {
        switch input {
        case .left:
            switch self {
            case .forwardMirror:
                [.down]
            case .backwardMirror:
                [.up]
            case .verticalSplitter:
                [.up, .down]
            case .horizontalSplitter:
                [.left]
            }
        case .right:
            switch self {
            case .forwardMirror:
                [.up]
            case .backwardMirror:
                [.down]
            case .verticalSplitter:
                [.up, .down]
            case .horizontalSplitter:
                [.right]
            }
        case .up:
            switch self {
            case .forwardMirror:
                [.right]
            case .backwardMirror:
                [.left]
            case .verticalSplitter:
                [.up]
            case .horizontalSplitter:
                [.left, .right]
            }
        case .down:
            switch self {
            case .forwardMirror:
                [.left]
            case .backwardMirror:
                [.right]
            case .verticalSplitter:
                [.down]
            case .horizontalSplitter:
                [.left, .right]
            }
        }
    }
}

fileprivate enum Direction {
    case left
    case right
    case up
    case down
}

fileprivate extension Point {
    func moved(_ direction: Direction) -> Point {
        switch direction {
        case .left:
            Point(x: x - 1, y: y)
        case .right:
            Point(x: x + 1, y: y)
        case .up:
            Point(x: x, y: y - 1)
        case .down:
            Point(x: x, y: y + 1)
        }
    }
}
