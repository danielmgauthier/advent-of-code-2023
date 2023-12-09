import Foundation
import Algorithms

struct Hand: Comparable {
    static func < (lhs: Hand, rhs: Hand) -> Bool {
        if lhs.handScore == rhs.handScore {
            return String(lhs.cards) < String(rhs.cards)
        } else {
            return lhs.handScore < rhs.handScore
        }
    }
    
    let cards: [Character]
    let bid: Int
    let includeJokers: Bool
    
    enum HandType: Int {
        case fiveOfAKind = 6
        case fourOfAKind = 5
        case fullHouse = 4
        case threeOfAKind = 3
        case twoPair = 2
        case onePair = 1
        case highCard = 0
        
        func addingJokers(count: Int) -> HandType {
            var handType = self
            for _ in 1...count {
                handType = handType.addingJoker()
            }
            return handType
        }
        
        private func addingJoker() -> HandType {
            switch self {
            case .fiveOfAKind: .fiveOfAKind
            case .fourOfAKind: .fiveOfAKind
            case .fullHouse: .fullHouse
            case .threeOfAKind: .fourOfAKind
            case .twoPair: .fullHouse
            case .onePair: .threeOfAKind
            case .highCard: .onePair
            }
        }
    }
    
    var handScore: Int {
        var handType: HandType
        
        let cardsToCheck = includeJokers ? cards.filter { $0 != "1" } : cards
        let numberOfJokers = includeJokers ? cards.filter { $0 == "1"}.count : 0
        
        let groups = Dictionary(grouping: cardsToCheck) { $0 }.values.map { $0.count }
        if groups.contains(5) {
            handType = .fiveOfAKind
        } else if groups.contains(4) {
            handType = .fourOfAKind
        } else if groups.contains(3) && groups.contains(2) {
            handType = .fullHouse
        } else if groups.contains(3) {
            handType = .threeOfAKind
        } else if groups.filter({ $0 == 2 }).count == 2 {
            handType = .twoPair
        } else if groups.contains(2) {
            handType = .onePair
        } else {
            handType = .highCard
        }
        
        if numberOfJokers > 0 {
            handType = handType.addingJokers(count: numberOfJokers)
        }
        
        return handType.rawValue
    }
    
    init(string: String, includeJokers: Bool = false) {
        self.includeJokers = includeJokers
        
        let components = string.splitAndTrim(by: " ")
        self.bid = components[1].toInt()
        
        var sortMap: [Character: Character] = [
            "T": "A",
            "Q": "C",
            "K": "D",
            "A": "E"
        ]
        
        if includeJokers {
            sortMap["J"] = "1"
        } else {
            sortMap["J"] = "B"
        }
            
        self.cards = components[0].map {
            if let replacement = sortMap[$0] {
                return replacement
            }
            return $0
        }
    }
}

struct Day7: Runnable {
    var input: String
    
    func partOne() -> String {
        input
            .lines
            .map { Hand(string: $0) }
            .sorted()
            .enumerated()
            .map { $0.element.bid * ($0.offset + 1) }
            .sum
            .description
    }
    
    func partTwo() -> String {
        input
            .lines
            .map { Hand(string: $0, includeJokers: true) }
            .sorted()
            .enumerated()
            .map { $0.element.bid * ($0.offset + 1) }
            .sum
            .description
    }
}
