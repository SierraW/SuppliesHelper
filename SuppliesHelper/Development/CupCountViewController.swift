//
//  CupCountViewController.swift
//  SuppliesHelper
//
//  Created by Yiyao Zhang on 2020-02-05.
//  Copyright © 2020 Yiyao Zhang. All rights reserved.
//

import UIKit

class CupCountViewController: UIViewController, UITextFieldDelegate {
    
    var daoCupCount: DaoCupCount!
    var cupCountRecord: [ShuyiCupHistory]!
    var cupCount: ShuyiCupHistory!

    @IBOutlet var txtInputField: [UITextField]!
    
    @IBOutlet var lblTotal: [UILabel]!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var stackMorning: UIStackView!
    @IBOutlet weak var stackNight: UIStackView!
    @IBOutlet weak var stackSubtotal: UIStackView!
    
    @IBAction func txtAction(_ sender: Any) {
        if let txtInput = sender as? UITextField {
            let updatedValue = Int(txtInput.text ?? "0") ?? 0
            txtInput.text = "\(updatedValue)"
            calculateSubtotal()
        }
    }
    
    @IBOutlet weak var historyCollectionView: UICollectionView!
    
    @IBAction func emptyAllField(_ sender: Any) {
        popUpWindow(message: "是否清空表格数据？", isDeleting: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        daoCupCount = DaoCupCount()
        
        cupCount = daoCupCount.getCupCount(at: Date())
        cupCountRecord = daoCupCount.getCupCounts(predicate: nil)
        
        reloadData()
        

        lblDate.text = "\(dateToString(at: Date(), format: "YYYY-MM-dd"))"
        
        (self.historyCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .vertical
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.handle)))
    }
    
    @objc func handle(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.view.endEditing(false)
        }
        sender.cancelsTouchesInView = false
    }
    
    func writeData() {
        var morning: [Int] = []
        var night: [Int] = []
        for i in 1..<9 {
            if let txtInput0 = stackMorning.arrangedSubviews[i] as? UITextField,
                let txtInput1 = stackNight.arrangedSubviews[i] as? UITextField{
                let value0 = Int(txtInput0.text ?? "0") ?? 0
                let value1 = Int(txtInput1.text ?? "0") ?? 0
                morning.append(value0)
                night.append(value1)
            }
        }
        daoCupCount.writeData(morningData: morning, nightData: night, record: cupCount)
    }
    
    func reloadData() {
        let (morning, night) = daoCupCount.readData(record: cupCount)
        for i in 0..<night.count {
            if let txtInput0 = stackMorning.arrangedSubviews[i + 1] as? UITextField,
                let txtInput1 = stackNight.arrangedSubviews[i + 1] as? UITextField{
                txtInput0.text = "\(morning[i])"
                txtInput1.text = "\(night[i])"
            }
        }
        calculateSubtotal()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(false)
        return true
    }
    
    func calculateSubtotal() {
        var multiplier = 1
        for i in 1..<9 {
            multiplier = 1
            if let txtInput0 = stackMorning.arrangedSubviews[i] as? UITextField,
                let txtInput1 = stackNight.arrangedSubviews[i] as? UITextField{
                if let value0 = Int(txtInput0.text ?? "0"), let value1 = Int(txtInput1.text ?? "0") {
                    if let lblSubtotal = stackSubtotal.arrangedSubviews[i] as? UILabel {
                        if i == 2 || i == 4 {
                            multiplier = 25
                        } else if i == 6 || i == 8 {
                            multiplier = 50
                        }
                        lblSubtotal.text = "\((value0 - value1) * multiplier)"
                    }
                }
            }
        }
        updateLabel()
    }
    
    func updateLabel() {
        var total0 = 0
        var total1 = 0
        var total = 0
        var multiplier = 1
        for i in 1..<9 {
            if i == 2 || i == 4 {
                multiplier = 25
            } else if i == 6 || i == 8 {
                multiplier = 50
            } else {
                multiplier = 1
            }
            if let txtInput0 = stackMorning.arrangedSubviews[i] as? UITextField, let value0 = Int(txtInput0.text ?? "0") {
                total0 += value0 * multiplier
            }
            if let txtInput1 = stackNight.arrangedSubviews[i] as? UITextField, let value1 = Int(txtInput1.text ?? "0") {
                total1 += value1 * multiplier
            }
            if let lblSubtotal = stackSubtotal.arrangedSubviews[i] as? UILabel, let value = Int(lblSubtotal.text ?? "0") {
                total += value
            }
        }
        lblTotal[0].text = "\(total0)"
        lblTotal[1].text = "\(total1)"
        lblTotal[2].text = "\(total)"
        writeData()
    }
    
    func dateToString(at date: Date, format: String) -> String {
//            let interval = NSTimeZone.system.secondsFromGMT()
//            let localDate = date.addingTimeInterval(TimeInterval(interval))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: date)
    }
    
    func deleteCurrentData() {
        for i in 1..<9 {
            if let txtInput0 = stackMorning.arrangedSubviews[i] as? UITextField,
                let txtInput1 = stackNight.arrangedSubviews[i] as? UITextField{
                txtInput0.text = ""
                txtInput1.text = ""
            }
        }
        
        confirmMessage()
    }
    
    func addNewData() {
        cupCount = daoCupCount.newCupCount(previous: cupCountRecord.last)
        cupCountRecord = daoCupCount.getCupCounts(predicate: nil)
        reloadData()
        
        if let cv = view.subviews[2] as? UICollectionView {
            cv.reloadData()
        }
    }
    
    
    
    func popUpWindow(message str: String, isDeleting: Bool){
        let alert = UIAlertController(title: "提示", message: "Delete Data", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        let confirmAction = UIAlertAction(title: "确定", style: .destructive, handler: { (alert: UIAlertAction) -> Void in
            if isDeleting {
                self.deleteCurrentData()
            } else {
                self.addNewData()
            }
        } )
        let attrStr = NSMutableAttributedString(string: str)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        attrStr.addAttributes([NSAttributedString.Key.paragraphStyle: style], range: NSMakeRange(0, str.count))
        attrStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: NSMakeRange(0, str.count))
        alert.setValue(attrStr, forKey: "attributedMessage")

        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
    func confirmMessage() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "好", style: .default, handler: {
            [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        let str = "已清空数据"
        let attrStr = NSMutableAttributedString(string: str)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        attrStr.addAttributes([NSAttributedString.Key.paragraphStyle: style], range: NSMakeRange(0, str.count))
        attrStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: NSMakeRange(0, str.count))
        alert.setValue(attrStr, forKey: "attributedMessage")
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }

}

extension CupCountViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cupCountRecord.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Date Cell", for: indexPath)
        
        let stack = cell.contentView.subviews[0] as! UIStackView
        
        let labelM = stack.arrangedSubviews[0] as! UILabel
        let labelT = stack.arrangedSubviews[1] as! UILabel
        
        if indexPath.item == cupCountRecord.count {
            cell.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            labelM.text = "新纪录"
            labelT.text = dateToString(at: Date(), format: "dd HH:mm")
            return cell
        }
        
        let index = indexPath.item
        
        if cupCount.date == cupCountRecord[index].date {
            cell.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        } else {
            cell.backgroundColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        }
        
        let date = cupCountRecord[index].date
        labelM.text = dateToString(at: date, format: "MM/dd")
        labelT.text = dateToString(at: date, format: "HH:mm")
        
        return cell
    }
    
    
}

extension CupCountViewController: UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == cupCountRecord.count {
            popUpWindow(message: "是否添加新纪录？", isDeleting: false)
            collectionView.reloadData()
            return
        }
        let index = indexPath.item
        if cupCount != cupCountRecord[index] {
            cupCount = cupCountRecord[index]
            reloadData()
            collectionView.reloadData()
        }
    }
}
