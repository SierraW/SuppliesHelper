//
//  ImgContrast.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-19.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import Foundation

struct ImgContrast {
    var count = 0
    var r = 0
    var g = 0
    var b = 0
    var y: Int
    var a = 0
    var mode = Mode.ascending
        
    mutating func addNewMember(r red: Int, g green: Int, b blue: Int) {
        count += 1
//        r = (r * (count - 1) + red) / count
//        g = (g * (count - 1) + green) / count
//        b = (b * (count - 1) + blue) / count
        r = red
        g = green
        b = blue
        
//        if r == 0, g == 0, b == 0 {
//            r = red
//            g = green
//            b = blue
//        }
    }
    
    mutating func compare(with color: [Int], filter: Int) -> Bool {
        let r1 = color[0]
        let g1 = color[1]
        let b1 = color[2]
        
        if r.compare(to: r1) < filter, g.compare(to: g1) < filter, b.compare(to: b1) < filter {
            return true
        } else {
            if r1 >= r { // ascending
                switch mode {
                case .ascending:
                    return true
                case .descending:
                    return false
                }
            } else { //descending
                switch mode {
                case .ascending:
                    
                    self.mode = .descending
                    return true
                case .descending:
                    return true
                }
            }
        }
    }
    
    enum Mode {
        case ascending, descending
    }
}

extension Int {
    func compare(to x: Int) -> Int {
        if self > x {
            return self - x
        } else {
            return x - self
        }
    }
}
