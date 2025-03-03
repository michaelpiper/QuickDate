//
//  PaymentOpetionViewController.swift
//  QuickDate
//
//  Created by iMac on 13/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

protocol PaymentOptionDelegate {
    func selectedPaymentMethod(vc:PaymentOpetionViewController, _ type: PaymentName)
}

class PaymentOpetionViewController: BaseViewController, PanModalPresentable {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var paymentMethodsView: [UIView]!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var panScrollable: UIScrollView? {
        return scrollView
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(500.0)
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(840.0)
    }
    
    var delegate: PaymentOptionDelegate?
    
    var paymentName = PaymentName.bank
    var paymentType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
}

//MARK: Custom Method
extension PaymentOpetionViewController {
    private func setupUI() {
        setupUIColor()
    }
    
    private func setupUIColor() {
        paymentMethodsView.forEach { view in
            view.addShadow(radius: 1.0, opacity: 0.5)
        }
        
    }
    
    //MARK: - Action -
        
    @IBAction func onBtnPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        switch sender.tag {
        case 1001:
            paymentName = .paypal
        case 1002:
            paymentName = .creditCard
        case 1003:
            paymentName = .bank
        case 1004:
            paymentName = .razorPay
        case 1005:
            paymentName = .cashfree
        case 1006:
            paymentName = .paystack
        case 1007:
            paymentName = .securionPay
        case 1008:
            paymentName = .authorizeNet
        case 1009:
            paymentName = .iyziPay
        case 1010:
            paymentName = .aamarPay
        case 1011:
            paymentName = .flutterWave
        case 1012:
            paymentName = .coinbase
        case 1013:
            paymentName = .ngenius
        default:
            break
        }
        self.dismiss(animated: true) {
            self.delegate?.selectedPaymentMethod(vc: self, self.paymentName)
        }
    }
}
