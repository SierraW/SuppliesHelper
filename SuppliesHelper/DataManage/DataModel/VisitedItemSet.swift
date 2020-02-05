//
//  VisitedItemSet.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-02.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import Foundation

class VisitedItemSet {
    var items: [VisitedItem]
    var visited: [Int]
    var unvisited: [Int]
    var labeled: [Int]
    
    init(items set: [ShuyiSupplyItem]) {
        items = set.compactMap{VisitedItem(item: $0)}
        visited = []
        unvisited = items.compactMap{Int($0.shuyiItem.id_item)}
        labeled = []
    }
    
    init(items set: [VisitedItem]) {
        items = set
        visited = []
        unvisited = items.compactMap{Int($0.shuyiItem.id_item)}
        labeled = []
    }
    
    func setVisited(items set: [Int]) {
        unvisited = []
        visited = set.sorted()
        var j = 0
        for i in 0..<items.count {
            if visited.count > 0, visited[j] == i {
                if j + 1 < set.count {
                    j += 1
                }
            } else {
                unvisited.append(i)
            }
        }
    }
    
    func setLabeled(items set: [(Int, Int)]) {
        labeled = []
        for item: (index: Int, count: Int) in set {
            items[item.index].itemCount = item.count
            labeled.append(item.index)
        }
    }
    
    func visit(at index: Int) {
        visited.append(index)
        removeFromUnvisited(for: index)
    }
    
    func unvisit(at index: Int) {
        unvisited.append(index)
        removeFromVisited(for: index)
    }
    
    func removeFromLabel(for index: Int) {
        if !labeled.contains(index){
            return
        }
        for i in 0..<labeled.count {
            if index == labeled[i] {
                labeled.remove(at: i)
                return
            }
        }
    }
    
    func label(at index: Int) {
        if !labeled.contains(index) {
            labeled.append(index)
        }
    }
    
    func setCount(at index: Int, value: Int?) {
        if value != nil, value! < 0 {
            return
        }
        items[index].itemCount = value
    }
    
    func getCount (at index: Int) -> Int? {
        return items[index].itemCount
    }
    
    func getItemsFromIndexes(indexes: [Int]) -> [VisitedItem] {
        var output: [VisitedItem] = []
        for index: Int in indexes {
            output.append(items[index])
        }
        return output
    }
    
    private func removeFromUnvisited(for index: Int) {
        for i in 0..<unvisited.count {
            if index == unvisited[i] {
                unvisited.remove(at: i)
                return
            }
        }
    }
    
    private func removeFromVisited(for index: Int) {
        for i in 0..<visited.count {
            if index == visited[i] {
                visited.remove(at: i)
                return
            }
        }
    }
}
