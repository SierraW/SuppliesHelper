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
    
    // MARK: contrast section
    
    func getResultBasedOnContrast() -> [ImgContrast]{
        var output: [ImgContrast] = []
        
        for y in 0..<height {
            let x = 2
            
            if !map[y][x] {
                let record = ImgContrast(y: y)
                let count = getContrastCount(origin: (x, y), record: record)
                output.append(count)
            }
            
        }
        
        refreshMap()
        return output
    }
    
    func getContrastCount(origin: (x: Int, y: Int), record: ImgContrast) -> ImgContrast{
        if record.count > 300 {
            return record
        }
        let data = preloadedData[origin.y][origin.x].data
        map[origin.y][origin.x] = true
        
        let r = data[0]
        let g = data[1]
        let b = data[2]
        
        if isInRange(for: (r,g,b), in: record) || record.count == 0 {
            var newRecord = record
            newRecord.addNewMember(r: r, g: g, b: b)
            
            for position in Position.allValues {
                if let (x, y) = getNeigbor(x: origin.x, y: origin.y, from: position) {
                    if map[y][x] == false {
                        newRecord = getContrastCount(origin: (x, y), record: newRecord)
                    }
                }
            }
            return newRecord
        }
        return record
    }
        
    func isInRange(for color: (r: Int, g: Int, b: Int), in record: ImgContrast) -> Bool {
        if color.r.compare(to: record.r) < filter, color.b.compare(to: record.b) < filter, color.g.compare(to: record.g) < filter {
            return true
        }
        return false
    }
    
    func filterOutput(record: [ImgContrast], filter: (r: Int, g: Int, b: Int)) -> [ImgContrast] {
        var output: [ImgContrast] = []
        
        for element in record {
            if filter.r < element.r, filter.g < element.g, filter.b < element.b {
                output.append(element)
            }
        }
                
        return output
    }
    
    func processContrastComparingResult(filteredOutput: [ImgContrast]) -> Int {
        var resultWithDeltaY:[ImgContrast] = []
        //var resultWithDeltaYIntArray: [Int] = [] todo: find most frequently appear deltaY
        for i in 1..<filteredOutput.count {
            var record = filteredOutput[i]
            let difference = record.y - filteredOutput[i - 1].y
            record.a = (difference)
            resultWithDeltaY.append(record)
            //resultWithDeltaYIntArray.append(difference)
        }
        
        let midDeltaY = 100//resultWithDeltaYDeltaY.sorted()[resultWithDeltaYDeltaY.count / 2]
        
        var filteredDeltaY: [ImgContrast] = []
        let range = 40
        for element in resultWithDeltaY {
            if element.a.compare(to: midDeltaY) < range {
                filteredDeltaY.append(element)
            }
        }
        
        var final: [Int] = []
        if filteredDeltaY.count < 2 {
            return 0
        }
        for i in 1..<filteredDeltaY.count {
            final.append((filteredDeltaY[i].y.compare(to: filteredDeltaY[i - 1].y)))
        }
        let midCount = final.sorted()[final.count / 2]
        var finalCount = 2
        for element in final {
            if element.compare(to: midCount) < range {
                finalCount += 1
            }
        }
        return finalCount
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
