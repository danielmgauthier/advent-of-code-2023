import Foundation
import Algorithms

fileprivate enum Edge: String, Hashable {
    case left
    case top
    case right
    case bottom
    
    var opposite: Edge {
        switch self {
        case .left: .right
        case .top: .bottom
        case .right: .left
        case .bottom: .top
        }
    }
}

fileprivate struct Node: CustomStringConvertible {
    var edges: Set<Edge>
    
    init(edges: Set<Edge>) {
        self.edges = edges
    }
    
    init?(character: Character) {
        switch character {
        case "|": self.edges = [.bottom, .top]
        case "-": self.edges = [.left, .right]
        case "L": self.edges = [.top, .right]
        case "J": self.edges = [.top, .left]
        case "7": self.edges = [.left, .bottom]
        case "F": self.edges = [.right, .bottom]
        case "S": self.edges = [] // in S case, we don't know what node looks like yet; we'll figure it out after
        default: return nil
        }
    }
    
    var description: String {
        switch edges {
        case [.bottom, .top]:
            return "|"
        case [.left, .right]:
            return "-"
        case [.top, .right]:
            return "L"
        case [.top, .left]:
            return "J"
        case [.left, .bottom]:
            return "7"
        case [.right, .bottom]:
            return "F"
        default:
            return "."
        }
    }
    
    func corneredEdge(currentEdge: Edge) -> Edge {
        switch description {
        case "|":
            return currentEdge
        case "-":
            return currentEdge
        case "L", "7":
            switch currentEdge {
            case .left:
                return .bottom
            case .top:
                return .right
            case .right:
                return .top
            case .bottom:
                return .left
            }
        case "J", "F":
            switch currentEdge {
            case .left:
                return .top
            case .top:
                return .left
            case .right:
                return .bottom
            case .bottom:
                return .right
            }
        default: return currentEdge
        }
    }
}

fileprivate extension Point {
    func nextPoint(following edge: Edge) -> Point {
        switch edge {
        case .left:
            return .init(x: x - 1, y: y)
        case .top:
            return .init(x: x, y: y - 1)
        case .right:
            return .init(x: x + 1, y: y)
        case .bottom:
            return .init(x: x, y: y + 1)
        }
    }
}

fileprivate struct PointEdge: Hashable {
    var point: Point
    var edge: Edge
}

struct Day10: Runnable {
    var input: String
    
    func partOne() -> String {
        
        var map: [Point: Node] = [:]
        var startPoint: Point = .init(x: 0, y: 0)
        
        // set up map
        input.lines.enumerated().forEach { line in
            line.element.enumerated().forEach { character in
                if let node = Node(character: character.element) {
                    let point = Point(x: character.offset, y: line.offset)
                    map[point] = node
                    if character.element == "S" {
                        startPoint = point
                    }
                }
            }
        }
        
        // figure out shape of start node
        computeStartNodeEdges(map: &map, startPoint: startPoint)
        
        // traverse in both directions until we meet
        var distanceMap: [Point: Int] = [:]
        let startNode = map[startPoint]!
        let startEdges = Array(startNode.edges)
        
        var edgeA = startEdges[0]
        var edgeB = startEdges[1]
        var pointA = startPoint.nextPoint(following: edgeA)
        var pointB = startPoint.nextPoint(following: edgeB)
        var distance = 1
        
        while distanceMap[pointA] == nil {
            distanceMap[pointA] = distance
            distanceMap[pointB] = distance
            
            distance += 1
            let newEdgeA = map[pointA]!.edges.subtracting([edgeA.opposite]).first!
            pointA = pointA.nextPoint(following: newEdgeA)
            edgeA = newEdgeA
            
            let newEdgeB = map[pointB]!.edges.subtracting([edgeB.opposite]).first!
            pointB = pointB.nextPoint(following: newEdgeB)
            edgeB = newEdgeB
        }
        
        return (distance - 1).description
    }
    
    func partTwo() -> String {
        var map: [Point: Node] = [:]
        var startPoint: Point = .init(x: 0, y: 0)
        
        // set up map
        let lines = input.lines
        lines.enumerated().forEach { line in
            line.element.enumerated().forEach { character in
                if let node = Node(character: character.element) {
                    let point = Point(x: character.offset, y: line.offset)
                    map[point] = node
                    if character.element == "S" {
                        startPoint = point
                    }
                }
            }
        }
        
        // figure out shape of start node
        computeStartNodeEdges(map: &map, startPoint: startPoint)
        
        // get map of just main loop
        var mainLoop: [Point] = []
        var mainLoopSet: Set<Point> = []
        do {
            var currentEdge = map[startPoint]!.edges.first!
            var currentPoint = startPoint.nextPoint(following: currentEdge)
            mainLoop.append(currentPoint)
            mainLoopSet.insert(currentPoint)
            
            while currentPoint != startPoint {
                currentEdge = map[currentPoint]!.edges.subtracting([currentEdge.opposite]).first!
                currentPoint = currentPoint.nextPoint(following: currentEdge)
                mainLoop.append(currentPoint)
                mainLoopSet.insert(currentPoint)
            }
        }
        
        
        // find a starting pointEdge that we know can escape
        var point = Point(x: 5, y: -1)
        while !mainLoopSet.contains(point) {
            point = .init(x: point.x, y: point.y + 1)
        }
        
        var escapingPointEdges: Set<PointEdge> = [.init(point: point, edge: .top)]
        let startIndex = mainLoop.firstIndex(of: point)!
        var nextIndex = (startIndex + 1) % mainLoop.count
        var currentEdge = Edge.top
        var currentNode = map[point]!
        let nextNode = map[mainLoop[nextIndex]]!
        var escapeTestEdges = [currentEdge]
        
        if currentNode.description == "7" && mainLoop[nextIndex].y > point.y {
            escapeTestEdges.append(.right)
            escapingPointEdges.insert(.init(point: point, edge: .right))
        } else if currentNode.description == "F" && mainLoop[nextIndex].y > point.y {
            escapeTestEdges.append(.left)
            escapingPointEdges.insert(.init(point: point, edge: .left))
        }
        
        while nextIndex != startIndex {
            let currentPoint = mainLoop[nextIndex]
            currentNode = map[currentPoint]!
            currentEdge = escapeTestEdges.last!
            escapeTestEdges = [currentEdge, currentNode.corneredEdge(currentEdge: currentEdge)]
            for edge in escapeTestEdges {
                escapingPointEdges.insert(.init(point: currentPoint, edge: edge))
            }
            
            nextIndex = (nextIndex + 1) % mainLoop.count
        }
        
        
        // escapingPointEdges should now contain the entire outside of the loop. If a point can touch
        // any of these pointEdges, it should be able to escape
        var enclosedCount = 0
        for y in (0..<lines.count) {
            for x in (0..<lines[0].count) {
                let point = Point(x: x, y: y)
                guard !mainLoopSet.contains(point) else { continue }
                
                var currentPoint = point
                var isOutOfBounds = false
                while !mainLoopSet.contains(currentPoint) {
                    currentPoint = .init(x: currentPoint.x, y: currentPoint.y - 1)
                    if currentPoint.y < 0 {
                        isOutOfBounds = true
                        break
                    }
                }
                
                if isOutOfBounds { continue }
                
                // now I'm on the main loop, bottom edge. Does this exist in my set?
                if !escapingPointEdges.contains(.init(point: currentPoint, edge: .bottom)) {
                    enclosedCount += 1
                }
            }
        }
        return enclosedCount.description
    }
    
    private func computeStartNodeEdges(map: inout [Point: Node], startPoint: Point) {
        var startNodeEdges: Set<Edge> = []
        
        let topPoint = Point(x: startPoint.x, y: startPoint.y - 1)
        if let node = map[topPoint], node.edges.contains(.bottom) {
            startNodeEdges.insert(.top)
        }
        
        let bottomPoint = Point(x: startPoint.x, y: startPoint.y + 1)
        if let node = map[bottomPoint], node.edges.contains(.top) {
            startNodeEdges.insert(.bottom)
        }
        
        let leftPoint = Point(x: startPoint.x - 1, y: startPoint.y)
        if let node = map[leftPoint], node.edges.contains(.right) {
            startNodeEdges.insert(.left)
        }
        
        let rightPoint = Point(x: startPoint.x + 1, y: startPoint.y)
        if let node = map[rightPoint], node.edges.contains(.left) {
            startNodeEdges.insert(.right)
        }
        
        map[startPoint]?.edges = startNodeEdges
    }
}
