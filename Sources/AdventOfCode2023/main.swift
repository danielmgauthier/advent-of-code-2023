import Foundation

let day = Calendar.current.component(.day, from: .now)

let inputPath = FileManager.default.currentDirectoryPath.appending("/input\(day).txt")
let sessionPath = FileManager.default.currentDirectoryPath.appending("/privateSession.txt")
var input = ""

if let storedInput = try? String(contentsOfFile: inputPath) {
    input = storedInput
} else {
    var request = URLRequest(url: URL(string: "https://adventofcode.com/2023/day/\(day)/input")!)
    let session = try! String(contentsOfFile: sessionPath)
    request.setValue("session=\(session)", forHTTPHeaderField: "Cookie")
    
    let data = try! await URLSession.shared.data(for: request).0
    input = String(data: data, encoding: .utf8)!
    
    try? input.write(toFile: inputPath, atomically: false, encoding: .utf8)
}

switch day {
case 1:
    Day1(input: input).run()
case 2:
    Day2(input: input).run()
case 3:
    Day3(input: input).run()
case 4:
    Day4(input: input).run()
case 5:
    Day5(input: input).run()
case 6:
    Day6(input: input).run()
case 7:
    Day7(input: input).run()
case 8:
    Day8(input: input).run()
case 9:
    Day9(input: input).run()
case 10:
    Day10(input: input).run()
case 11:
    Day11(input: input).run()
case 12:
    Day12(input: input).run()
case 13:
    Day13(input: input).run()
case 14:
    Day14(input: input).run()
case 15:
    Day15(input: input).run()
case 16:
    Day16(input: input).run()
case 17:
    Day17(input: input).run()
case 18:
    Day18(input: input).run()
case 19:
    Day19(input: input).run()
case 20:
    Day20(input: input).run()
case 21:
    Day21(input: input).run()
case 22:
    Day22(input: input).run()
case 23:
    Day23(input: input).run()
case 24:
    Day24(input: input).run()
case 25:
    Day25(input: input).run()
default:
    break
}


