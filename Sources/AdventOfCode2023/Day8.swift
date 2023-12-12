import Foundation
import Algorithms

fileprivate class Node {
    var label: String
    var leftNode: Node?
    var rightNode: Node?
    
    init(label: String, leftNode: Node? = nil, rightNode: Node? = nil) {
        self.label = label
        self.leftNode = leftNode
        self.rightNode = rightNode
    }
}

struct Day8: Runnable {
    var input: String
    
    func partOne() -> String {
        let components = input.splitAndTrim(by: "\n\n")
        let instructions = Array(components[0])
        let nodeMap = generateNodeMap(from: components[1].lines)
        
        var currentNode = nodeMap["AAA"]!
        var stepCount = 0
        var instructionIndex = 0
        while currentNode.label != "ZZZ" {
            let instruction = instructions[instructionIndex]
            if instruction == "L" {
                currentNode = currentNode.leftNode!
            } else {
                currentNode = currentNode.rightNode!
            }
            
            instructionIndex += 1
            if instructionIndex >= instructions.count {
                instructionIndex = 0
            }
            
            stepCount += 1
        }
        
        return stepCount.description
    }
    
    func partTwo() -> String {
        let components = input.splitAndTrim(by: "\n\n")
        let instructions = Array(components[0])
        let nodeMap = generateNodeMap(from: components[1].lines)
        
        var currentNodes: [Node] = nodeMap.values.filter { $0.label.hasSuffix("A")}
        var stepCount = 0
        var instructionIndex = 0
        
        // represents the period that each node traversal repeats
        var repeatingStepCounts: [Int: Int] = [:]
        
        while repeatingStepCounts.count != currentNodes.count {
            let instruction = instructions[instructionIndex]
            if instruction == "L" {
                for i in (0..<currentNodes.count) {
                    currentNodes[i] = currentNodes[i].leftNode!
                }
            } else {
                for i in (0..<currentNodes.count) {
                    currentNodes[i] = currentNodes[i].rightNode!
                }
            }
            
            instructionIndex += 1
            if instructionIndex >= instructions.count {
                instructionIndex = 0
            }
            
            stepCount += 1
            
            for i in (0..<currentNodes.count) {
                if currentNodes[i].label.hasSuffix("Z") && repeatingStepCounts[i] == nil {
                    repeatingStepCounts[i] = stepCount
                }
            }
        }
        
        // find least common multiple of all traversal periods
        var currentLCM = repeatingStepCounts[0]!
        
        for i in 1..<repeatingStepCounts.count {
            let stepCount = repeatingStepCounts[i]!
            let gcd = gcd(currentLCM, stepCount)
            currentLCM = currentLCM / gcd * stepCount
        }
        
        return currentLCM.description
    }
    
    private func generateNodeMap(from strings: [String]) -> [String: Node] {
        var nodeMap = [String: Node]()
        strings.forEach { nodeString in
            let (newNodeString, destinationNodeStrings) = nodeString.halveAndTrim(by: "=")
            let (leftNodeString, rightNodeString) = destinationNodeStrings.trimmingCharacters(in: .punctuationCharacters).halveAndTrim(by: ",")
            
            var newNode: Node
            if let node = nodeMap[newNodeString] {
                newNode = node
            } else {
                newNode = Node(label: newNodeString)
                nodeMap[newNodeString] = newNode
            }
            
            var leftNode: Node
            if let node = nodeMap[leftNodeString] {
                leftNode = node
            } else {
                leftNode = Node(label: leftNodeString)
                nodeMap[leftNodeString] = leftNode
            }
            
            var rightNode: Node
            if let node = nodeMap[rightNodeString] {
                rightNode = node
            } else {
                rightNode = Node(label: rightNodeString)
                nodeMap[rightNodeString] = rightNode
            }
            
            newNode.leftNode = leftNode
            newNode.rightNode = rightNode
        }
        
        return nodeMap
    }
}
