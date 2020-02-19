//
//  ImgMap.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-18.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import Foundation
import UIKit

class ImgMap {
    var maxWidth: Int, maxHeight: Int
    var width: Int, height: Int
    var map:[[Bool]]
    var yAxisResult: [Int] = []
    var r: Int?, g: Int?, b: Int?
    var filter: Int = 200
    var preloadedData: [[ImgPoint]]
    
    init(image: UIImage) {
        maxWidth = Int(image.size.width)
        maxHeight = Int(image.size.height)
        width = 5
        height = maxHeight
        preloadedData = []
        for y in 0..<height {
            preloadedData.append([])
            for x in 0..<width {
                preloadedData[y].append(ImgPoint(x: x, y: y))
            }
        }
        map = []
        for y in 0..<height {
            map.append([])
            for _ in 0..<width {
                map[y].append(false)
            }
        }
        let providerData = image.cgImage!.dataProvider!.data
        let data = CFDataGetBytePtr(providerData)!
        preload(data: data)
    }
    
    func preload(data: UnsafePointer<UInt8>) {
        for y in 0..<maxHeight {
            preloadedData.append([])
            var counter = 0
            let center = maxWidth / 2
            for x in (center - 2)...(center + 2) {
                preloadedData[y][counter].data = getDataByCell(pos: (x: x, y: y), data: data)
                counter += 1
            }
        }
    }
    
     func getNeigbor(x: Int, y: Int, from direction: Position) -> (x: Int, y: Int)? {
        switch direction {
        case .top:
            if y > height - 2 {
                return nil
            }
            return (x: x, y: y + 1)
        case .left:
            if x - 1 < 0 {
                return nil
            }
            return (x: x - 1, y: y)
        case .right:
            if x > width - 2 {
                return nil
            }
            return (x: x + 1, y: y)
        case .bottom:
            if y - 1 < 0 {
                return nil
            }
            return (x: x, y: y - 1)
        }
    }
    
    private func refreshMap() {
        for y in 0..<height {
            for x in 0..<width {
                map[y][x] = false
            }
        }
        yAxisResult = []
    }
    
    private func getDataByCell(pos: (x: Int, y: Int), data: UnsafePointer<UInt8>) -> [Int] {
        let numberOfComponents = 4
        let pixelInfo = ((Int(maxWidth) * pos.y) + pos.x) * numberOfComponents
        
        let r = Int(data[pixelInfo])
        let g = Int(data[pixelInfo+1])
        let b = Int(data[pixelInfo+2])
        let a = Int(data[pixelInfo+3])
        
        return [r, g, b, a]
    }
    
    private func isCorrectValue(for value:[Int]) -> Bool {
        var overallValue = false
        if r != nil{
            if value[0] > r! {
                overallValue = true
            } else {
                return false
            }
        }
        if g != nil{
            if value[1] > g! {
                overallValue = true
            } else {
                return false
            }
        }
        if b != nil{
            if value[2] > b! {
                overallValue = true
            } else {
                return false
            }
        }
        
        return overallValue
    }
    
    func getResultArray() -> [Int] {
        refreshMap()
        var resultSet: [Int] = []
        for y in 0..<height {
            let x = width / 2
                let explored = map[y][x]
                if !explored {
                    let count = getCount(origin: (x: x, y: y), count: 0)
                    if count > filter {
                        yAxisResult.append(y)
                        resultSet.append(count)
                    }
                }
        }
        return resultSet
    }
    
    private func getCount(origin: (x: Int, y: Int), count: Int) -> Int {
        let value = preloadedData[origin.y][origin.x].data
        map[origin.y][origin.x] = true
        if isCorrectValue(for: value) {
            var newCount = count + 1
            for position in Position.allValues {
                if let (x, y) = getNeigbor(x: origin.x, y: origin.y, from: position) {
                    if map[y][x] == false {
                        newCount = getCount(origin: (x, y), count: newCount)
                    }
                }
            }
            return newCount
        }
        return count
    }
    
    enum Position {
        case left, right, top, bottom
        static var allValues: [Position] {
            return [.top, .right, .left]
        }
    }
}
