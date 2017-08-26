//
//  CalculatorViewController.swift
//  Ratios
//
//  Created by Edward Wellbrook on 09/01/2017.
//  Copyright © 2017 Brushed Type. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    let totalInputView = LabelInputView(label: "TOTAL BREW (ML)", initialValue: "0")
    let waterInputView = LabelInputView(label: "WATER (ML)", initialValue: "0")
    let groundsInputView = LabelInputView(label: "GROUNDS (G)", initialValue: "0")
    let ratioInputView = LabelInputView(label: "RATIO", initialValue: "16")

    var centerYConstraint: NSLayoutConstraint? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Calculator"
        self.navigationController?.isNavigationBarHidden = true

        self.view.backgroundColor = UIColor(red: 0.87256, green: 0.79711, blue: 0.71713, alpha: 1)

        let stackView = UIStackView(arrangedSubviews: [
            self.ratioInputView,
            self.totalInputView,
            self.groundsInputView,
            self.waterInputView
        ])

        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 8

        self.view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 8).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true

        self.totalInputView.textField.addTarget(self, action: #selector(self.handleFieldValueChange), for: .editingChanged)
        self.waterInputView.textField.addTarget(self, action: #selector(self.handleFieldValueChange), for: .editingChanged)
        self.groundsInputView.textField.addTarget(self, action: #selector(self.handleFieldValueChange), for: .editingChanged)
        self.ratioInputView.textField.addTarget(self, action: #selector(self.handleFieldValueChange), for: .editingChanged)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.groundsInputView.textField.becomeFirstResponder()
    }

    @objc func handleFieldValueChange(_ sender: AnyObject) {
        let total = Double(self.totalInputView.textField.text ?? "0") ?? 0
        let water = Double(self.waterInputView.textField.text ?? "0") ?? 0
        let grounds = Double(self.groundsInputView.textField.text ?? "0") ?? 0
        let ratio = Int(self.ratioInputView.textField.text ?? "16") ?? 16

        guard let field = sender as? UITextField else {
            return
        }

        switch field {
        case self.totalInputView.textField:
            let newGrounds = Calculator.calculateGrounds(brew: total, ratio: ratio)
            let newWater = Calculator.calculateWater(grounds: newGrounds, ratio: ratio)
            self.groundsInputView.textField.text = CalculatorViewController.formatDoubleToString(newGrounds)
            self.waterInputView.textField.text = CalculatorViewController.formatDoubleToString(newWater)

        case self.waterInputView.textField:
            let newGrounds = Calculator.calculateGrounds(water: water, ratio: ratio)
            let newBrew = Calculator.calculateBrew(grounds: newGrounds, water: water)
            self.groundsInputView.textField.text = CalculatorViewController.formatDoubleToString(newGrounds)
            self.totalInputView.textField.text = CalculatorViewController.formatDoubleToString(newBrew)

        case self.groundsInputView.textField, self.ratioInputView.textField:
            let newWater = Calculator.calculateWater(grounds: grounds, ratio: ratio)
            let newBrew = Calculator.calculateBrew(grounds: grounds, water: newWater)
            self.waterInputView.textField.text = CalculatorViewController.formatDoubleToString(newWater)
            self.totalInputView.textField.text = CalculatorViewController.formatDoubleToString(newBrew)

        default:
            break
        }
    }

    static func formatDoubleToString(_ value: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0

        return formatter.string(from: NSNumber(value: value))
    }

}
