import Foundation
import Algorithms

struct Day15: Runnable {
    var input: String
    
    func partOne() -> String {
        input
            .splitAndTrim(by: ",").map {
                hash($0)
            }
            .sum
            .description
    }
    
    func partTwo() -> String {
        var boxes: [Int: [Lens]] = [:]
        
        for var step in input.splitAndTrim(by: ",") {
            step = step.trimmingCharacters(in: .whitespacesAndNewlines)
            if step.contains("=") {
                let (label, focalLength) = step.halveAndTrim(by: "=")
                let lens = Lens(label: label, focalLength: focalLength.toInt())
                if let existingIndex = boxes[hash(label), default: []].firstIndex(where: { $0.label == label }) {
                    boxes[hash(label), default: []][existingIndex] = lens
                } else {
                    boxes[hash(label), default: []].append(lens)
                }
                
            } else {
                let label = String(step.dropLast())
                boxes[hash(label), default: []].removeAll { $0.label == label }
            }
        }
        
        return boxes.map { (boxNumber, boxContents) in
            boxContents.enumerated().map { (index, lens) in
                (boxNumber + 1) * (index + 1) * lens.focalLength
            }
            .sum
        }
        .sum
        .description
    }
    
    func hash(_ string: String) -> Int {
        var currentValue = 0
        for character in string {
            if character == "\n" {
                continue
            }
            currentValue += Int(character.asciiValue!)
            currentValue *= 17
            currentValue %= 256
        }
        return currentValue
    }
}

struct Lens: CustomStringConvertible {
    var label: String
    var focalLength: Int
    
    var description: String {
        "\(label) \(focalLength)"
    }
}
