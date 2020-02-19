//
//  DataEncoder.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-05.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import Foundation

class DataEncoder {
    let length = 20
    let lengthWithDash = 23
    let precision = 30*60.0
    
    let map: [[Character]] = [["g","z","i","w","A","X"],["t","y","l","5","6"],["h","s","j","C","9"],["o","m","d","B"],["p","r","u","E"],["v","q","V","Q"],["e","P","R","U"],["b","O","M","D"],["c","H","S","J"],["n","T","Y","L"],["a","I","G","Z","1"],["W","0","4","8","7","N","3","2"]]

    func decryptDate(str: String) -> String {
        var output = ""
        for char: Character in str {
            switch char {
            case "g","z","i","w","A","X":
                output.append("0")
                break
            case "t","y","l","5","6":
                output.append("1")
                break
            case "h","s","j","C", "9":
                output.append("2")
                break
            case "o","m","d","B":
                output.append("3")
                break
            case "p","r","u","E":
                output.append("4")
            case "v","q","V","Q":
                output.append("5")
                break
            case "e","P","R","U":
                output.append("6")
                break
            case "b","O","M","D":
                output.append("7")
                break
            case "c","H","S","J":
                output.append("8")
            case "n","T","Y","L":
                output.append("9")
                break
            case "a","I","G","Z","1":
                output.append("/")
                break
            case "W","0","4","8","7","N","-","3","2":
                break
            default:
                break
            }
        }
        return output
    }


    func encryptData(date: Date, length: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MMdd/HHmm/ss"
        let dateString = dateFormatter.string(from: date)
        
        var edata0:[Character] = []
        for char: Character in dateString {
            if char == "/" {
                edata0.append(map[10][map[10].count.arc4random()])
            } else {
                if let num = Int("\(char)") {
                    edata0.append(map[num][map[num].count.arc4random()])
                }
            }
        }
        
        while edata0.count < length {
            edata0.insert(map[11][map[11].count.arc4random()], at: edata0.count.arc4random())
        }
        
        var output = ""
        
        for i in 0..<edata0.count {
            if i % 5 == 0  && i != 0{
                output.append("-")
            }
            output.append(edata0[i])
        }
        
        return output
    }
    
    func validate(key: String) -> Bool {
        if key.count != lengthWithDash, key.count != length {
            return false
        }
        
        let currentKey = encryptData(date: Date(), length: 20)
        
        let currentDate = stringConvertDate(string: decryptDate(str: currentKey))

        if let date = stringConvertDate(string: decryptDate(str: key)) {
            return compareDate(date0: date, date1: currentDate!)
        }
        return false
    }
    
    func compareDate(date0: Date, date1: Date) -> Bool {
        let value = date0.timeIntervalSince(date1)
        if value < precision && value > -precision {
            return true
        }
        return false
    }
    
    func stringConvertDate(string:String) -> Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy/MMdd/HHmm/ss"
            return dateFormatter.date(from: string)
    }
}

extension Int {
    func arc4random() -> Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        return self
    }
}
