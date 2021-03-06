//
//  DefaultData.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-01-29.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import Foundation
import CoreData

struct DefaultData {
    let locations: [String] =
    ["0/9","0/11","0/13","0/14","0/3","10/0","10/40","10/62","10/63","10/65","10/68","10/71","10/72","10/73","10/74","10/77","10/78","10/79","7/1","7/2","7/3","7/4","7/5","7/6","6/15","6/16","6/17","5/51","5/48","5/49","5/50","4/7","4/8","4/10","4/12","4/20","4/38","4/39","4/41","4/57","4/66","3/27","3/26","3/33","3/36","3/35","2/28","2/29","2/30","2/31","2/32","2/43","1/42","1/44","1/45","1/46","1/47","0/4","0/5","0/18","0/19","0/21","0/22","0/23","0/24","0/25","0/34","0/37","0/53","4/52","4/54","4/55","0/56","0/58","0/59","0/60","0/61","4/64","0/67","4/69","0/75","0/76","0/80","10/70","8/42","8/43","8/44","8/45","8/46","8/47","8/31","8/30","8/29","8/28","9/51","9/52","9/53","9/54","9/48","9/49","9/50","9/55","9/56","9/58","9/59","9/60","9/66","9/61","9/64"]
    let areas: [String] =
    [
        "0/书亦店面",
        "1/书亦展示柜",
        "2/书亦冰箱",
        "3/湘村发现冰箱",
        "4/走廊",
        "5/小房间",
        "6/胶制品粉类",
        "7/茶包",
        "8/水果",
        "9/杯子相关",
        "10/其他 (此处的物品将会被默认已清点)"
    ]
    let items:[String] =
    [
        "0/仙草专用淀粉/包/0",
        "1/新红茶/袋/0",
        "2/炭烧专用茶/袋/0",
        "3/皇家经典茶包/袋/0",
        "4/翠玉四季春/袋/0",
        "5/碧玉小叶茉莉/袋/0",
        "6/烧仙草2号专用红茶/袋/0",
        "7/燕麦罐头/罐/0",
        "8/书亦奶精/箱/0",
        "9/凤梨水晶/罐/0",
        "10/书亦专用果糖/罐/0",
        "11/书亦专用仙草汁/罐/0",
        "12/红豆/罐/0",
        "13/珍珠粉圆/袋/0",
        "14/椰果/袋/0",
        "15/焦糖冻粉/袋/0",
        "16/爱玉冻粉/袋/0",
        "17/8倍布丁粉/袋/0",
        "18/冷香抹茶/袋/0",
        "19/炭烧糖浆/瓶/0",
        "20/椰浆/罐/0",
        "21/正宗黑焦糖/瓶/0",
        "22/达芬奇焦糖/瓶/0",
        "23/蜂蜜柚子/罐/0",
        "24/优菌多/瓶/0",
        "25/玫瑰盐/瓶/0",
        "26/柠檬汁/瓶/0",
        "27/橙汁/瓶/0",
        "28/冻百香果/罐/0",
        "29/冻菠萝丁/罐/0",
        "30/冻芒果肉（透明包装）/包/0",
        "31/冻芒果肉（芒果丁专用）/包/0",
        "32/葡萄浆/罐/0",
        "33/葡萄汁/瓶/0",
        "34/奶酪/盒/0",
        "35/奶油/瓶/0",
        "36/牛奶/瓶/0",
        "37/芒果糖浆/瓶/0",
        "38/酸奶爆爆珠/桶/0",
        "39/芒果爆爆珠/桶/0",
        "40/白糖/包/0",
        "41/葡萄干/包/0",
        "42/香水柠檬/个/0",
        "43/青金桔/袋/0",
        "44/橙子/个/0",
        "45/圣女果/盒/0",
        "46/葡萄柚/个/0",
        "47/黄柠/个/0",
        "48/书亦粗吸管/袋/0",
        "49/书亦细吸管/袋/0",
        "50/书亦长黑勺/袋/0",
        "51/书亦大纸杯/条/0",
        "52/书亦中纸杯/条/0",
        "53/书亦大塑杯/条/0",
        "54/书亦中塑杯/条/0",
        "55/诚宇透明盖/条/0",
        "56/书亦杯贴纸/张/0",
        "57/书亦封口膜/个/0",
        "58/书亦单杯打包袋/箱/0",
        "59/书亦双杯打包袋/箱/0",
        "60/四包大包袋/箱/0",
        "61/书亦星星叉/盒/0",
        "62/不干胶/张/0",
        "63/打单纸（大）/箱/0",
        "64/方巾纸/包/0",
        "65/打单纸（小）/箱/0",
        "66/杯托/箱/0",
        "67/新品专用黑糖糖浆/瓶/0",
        "68/饼干碎/包/0",
        "69/巧克力粉/包/0",
        "70/微笑透明口罩/盒/0",
        "71/外卖平台登记表/箱/0",
        "72/日结信封/盒/0",
        "73/培训进度表/张/0",
        "74/培训申请表/张/0",
        "75/积分印章贴纸/张/0",
        "76/积分卡（9个章）/箱/0",
        "77/外卖菜单/箱/0",
        "78/叫货单/张/0",
        "79/手套/盒/0",
        "80/小芋圆/包/0",
    ]
    
    func resetArea(dao: DaoArea) {
        dao.remove(at: nil)
        for str: String in areas {
            let areaSubstr: [Substring] = str.split(separator: "/")
            let areaStr = areaSubstr.compactMap{"\($0)"}
            let newArea = dao.getAreaObject()
            newArea.id_area = Int16(areaStr[0])!
            newArea.name = areaStr[1]
            dao.save()
        }
    }
    
    func resetItem(dao: DaoItem) {
        dao.remove(for: nil)
        for str: String in items {
            let itemSubstr: [Substring] = str.split(separator: "/")
            let itemStr = itemSubstr.compactMap {"\($0)"}
            let newItem = dao.getItemObject()
            newItem.id_item = Int16(itemStr[0])!
            newItem.name = itemStr[1]
            newItem.unit = itemStr[2]
            newItem.id_area = Int16(itemStr[3])!
            dao.save()
        }
    }
    
    func resetLocation(dao: DaoLocation) {
        dao.remove(at: nil)
        for str: String in locations {
            let itemStr = str.split(separator: "/").compactMap{"\($0)"}
            let newLocation = dao.getLocationObj()
            newLocation.id_area = Int16(itemStr[0])!
            newLocation.id_item = Int16(itemStr[1])!
            dao.save()
        }
    }
}
