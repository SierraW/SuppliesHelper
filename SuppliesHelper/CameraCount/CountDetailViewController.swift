//
//  CountDetailViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-18.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class CountDetailViewController: UIViewController {

    @IBOutlet weak var txtOutput: UITextView!
    
    @IBOutlet weak var imgInput: UIImageView!
    
    @IBOutlet weak var txtTitle: UILabel!
    
    var img: UIImage!
    var controller: ImgMap!
    var mode: CountMode!
    var outputData: [Int] = []
    
    enum CountMode {
        case normal, contrast
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller = ImgMap(image: img)
        imgInput.image = img
        
        if mode == .normal {
            txtTitle.text = "结果（纸杯）"
            outputData.append(4)
            txtOutput.text = displayResult(output: getResult())
        } else if mode == .contrast {
            txtTitle.text = "结果（塑料杯）"
            outputData.append(0)
            txtOutput.text = displayResult(output: getResultContrastMode())
        }
    }
    
    func getResultContrastMode() -> [Int: Int] {
        var outputMap: [Int: Int] = [:]
        for filter in 16...19 {
            controller.filter = filter
            let result = controller.getResultBasedOnContrast()
            let filteredOutput = controller.filterOutput(record: result, filter: (100,100,100))
            let count = controller.processContrastComparingResult(filteredOutput: filteredOutput)
            outputMap[count] = (outputMap[count] ?? 0) + 1
        }
        return outputMap
    }
    
    func getResult() -> [Int: Int] {
        let highest = img!.getHighestValue()
        
        controller.filter = 3
        
        var outputMap:[Int: Int] = [:]
        for difference in 25...40 {
            controller.r = highest[0] - difference
            controller.g = highest[1] - difference
            controller.b = highest[2] - difference
            let _ = controller.getResultArray()
            
            if controller.yAxisResult.count > 0 {
                var totalDif = 0
                var previous:Int? = nil
                var output:[Int] = []
                for i in 0..<controller.yAxisResult.count {
                    let point = controller.yAxisResult[i]
                    if previous != nil {
                        let dif = point - previous!
                        totalDif += dif
                        output.append(dif)
                    }
                    previous = point
                }
                let med = output.sorted()[output.count / 2]
                
                var final: [Int] = []
                for element in output {
                    if !(element < med * 6 / 10), !(element > med * 13 / 10) {
                        final.append(element)
                    }
                }
                
                let finalValue = final.count + 1
                outputMap[finalValue] = (outputMap[finalValue] ?? 0) + 1
                
            }
        }
        return outputMap
    }
    
    func displayResult(output map:[Int: Int]) -> String {
        var total = 0
        var maxKey = 0
        var maxValue = 0
        for (key, value) in map {
            total += value
            
            if value > maxValue {
                maxKey = key
                maxValue = value
            }
        }
        
        outputData.append(maxKey)
        
        var output = ""
        for (key, value) in map {
            output.append("一共有\(key)个杯子 \(String(format: "%.1f%@", Double(value) / Double(total) * 100.0, "%"))\n")
        }
        return output
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Camera Count Output" {
            if let ccvc = segue.destination as? CupCountViewController {
                ccvc.dataInputed = outputData
            }
        }
    }

}

extension UIImage{
    func getData() -> UnsafePointer<UInt8> {
        let providerData = self.cgImage!.dataProvider!.data
        return CFDataGetBytePtr(providerData)
    }
    
    func getHighestValue() -> [Int] {
    var output: [[Int]] = []
    
    let x = Int(self.size.width / 2)
    let providerData = self.cgImage!.dataProvider!.data
    let data = CFDataGetBytePtr(providerData)
    
    let numberOfComponents = 4
    for i in 0..<Int(self.size.height) {
        let y = i
        
        let pixel0 = ((Int(size.width) * y) + (x - 2)) * numberOfComponents
        let pixel1 = ((Int(size.width) * y) + (x - 1)) * numberOfComponents
        let pixel2 = ((Int(size.width) * y) + x) * numberOfComponents
        let pixel3 = ((Int(size.width) * y) + (x + 1)) * numberOfComponents
        let pixel4 = ((Int(size.width) * y) + (x + 2)) * numberOfComponents
        
        var mod = 0
        let r = Int((Double(data![pixel0 + mod]) + Double(data![pixel1 + mod]) + Double(data![pixel2 + mod]) + Double(data![pixel3 + mod]) + Double(data![pixel4 + mod])) / 5.0)
        mod = 1
        let g = Int((Double(data![pixel0 + mod]) + Double(data![pixel1 + mod]) + Double(data![pixel2 + mod]) + Double(data![pixel3 + mod]) + Double(data![pixel4 + mod])) / 5.0)
        mod = 2
        let b = Int((Double(data![pixel0 + mod]) + Double(data![pixel1 + mod]) + Double(data![pixel2 + mod]) + Double(data![pixel3 + mod]) + Double(data![pixel4 + mod])) / 5.0)
        mod = 3
        let a = Int((Double(data![pixel0 + mod]) + Double(data![pixel1 + mod]) + Double(data![pixel2 + mod]) + Double(data![pixel3 + mod]) + Double(data![pixel4 + mod])) / 5.0)
        
        //print("r\(r) g\(g) b\(b) a\(a)")
        
        output.append([r,g,b,a])
    }
    
    var maxR = 0
    var maxG = 0
    var maxB = 0
    
    for color in output {
        if maxR < color[0] {
            maxR = color[0]
        }
        if maxG < color[1] {
            maxG = color[1]
        }
        if maxB < color[2] {
            maxB = color[2]
        }
    }
    
    return [maxR, maxG, maxB]
    }
}
