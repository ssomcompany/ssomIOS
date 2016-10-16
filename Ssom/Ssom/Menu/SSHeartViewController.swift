//
//  SSHeartViewController.swift
//  Ssom
//
//  Created by DongSoo Lee on 2016. 10. 10..
//  Copyright © 2016년 SsomCompany. All rights reserved.
//

import UIKit
import StoreKit

enum SSHeartGoods: Int {
    case heart2Package
    case heart8Package
    case heart17Package
    case heart28Package

    static var AllProductIDs: Array<String> {
        return ["ssom2HeartPackage", "ssom8HeartPackage", "ssom17HeartPackage", "ssom28HeartPackage"]
    }

    var productID: String {
        return SSHeartGoods.AllProductIDs[self.rawValue]
    }

    var heartCount: Int {
        switch self {
        case .heart2Package:
            return 2
        case .heart8Package:
            return 8
        case .heart17Package:
            return 17
        case .heart28Package:
            return 28
        }
    }

    var isEconomyPackage: Bool {
        switch self {
        case .heart8Package:
            return true
        default:
            return false
        }
    }

    var isHotPackage: Bool {
        switch  self {
        case .heart28Package:
            return true
        default:
            return false
        }
    }

    var tagIconImage: UIImage? {
        switch self {
        case .heart2Package:
            return nil
        case .heart8Package:
            return UIImage(named: "greenRibSmall")
        case .heart17Package:
            return nil
        case .heart28Package:
            return UIImage(named: "redRibSmall")
        }
    }

    var tagName: String? {
        switch self {
        case .heart2Package:
            return nil
        case .heart8Package:
            return "실속"
        case .heart17Package:
            return nil
        case .heart28Package:
            return "인기"
        }
    }

    var price: String {
        switch self {
        case .heart2Package:
            return "$ 3.99"
        case .heart8Package:
            return "$ 12.99"
        case .heart17Package:
            return "$ 23.99"
        case .heart28Package:
            return "$ 32.99"
        }
    }

    var sale: String? {
        switch self {
        case .heart2Package:
            return nil
        case .heart8Package:
            return "19%"
        case .heart17Package:
            return "29%"
        case .heart28Package:
            return "41%"
        }
    }

    var saleIconImage: UIImage? {
        switch self {
        case .heart2Package:
            return nil
        case .heart8Package:
            return UIImage(named: "saleGray")
        case .heart17Package:
            return UIImage(named: "saleGray")
        case .heart28Package:
            return UIImage(named: "salePink")
        }
    }

    var iconImage: UIImage? {
        switch self {
        case .heart2Package:
            return UIImage(named: "heartShadowX2")!
        case .heart8Package:
            return UIImage(named: "heartShadowX8")!
        case .heart17Package:
            return UIImage(named: "heartX17")!
        case .heart28Package:
            return UIImage(named: "heartX28")!
        }
    }

    var boundaryColor: UIColor {
        switch self {
        case .heart2Package:
            return UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        case .heart8Package:
            return UIColor(red: 0.0/255.0, green: 180.0/255.0, blue: 143.0/255.0, alpha: 1.0)
        case .heart17Package:
            return UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        case .heart28Package:
            return UIColor(red: 237.0/255.0, green: 52.0/255.0, blue: 75.0/255.0, alpha: 1.0)
        }
    }
}

class SSHeartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKPaymentTransactionObserver, SKProductsRequestDelegate {

    @IBOutlet var heartTableView: UITableView!
    var products: [SKProduct]!

    var indicator: SSIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }

    override func initView() {
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)

        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: Set(SSHeartGoods.AllProductIDs))
            request.delegate = self

            self.indicator = SSIndicatorView()
            self.indicator.showIndicator()

            request.start()
        } else {
            SSAlertController.alertConfirm(title: "Error", message: "설정>일반>차단 메뉴에서 인앱결제를 활성화해주십시요!", vc: self, completion: nil)
        }
    }

    deinit {
        SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
    }

    @IBAction func tapNaviClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func tapClose(sender: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK:- UITableViewDelegate & UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products == nil ? 0 : self.products.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 81
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("heartTableViewCell", forIndexPath: indexPath) as! SSHeartTableViewCell

        let heartGood = SSHeartGoods(rawValue: indexPath.row)!
        var priceWithTax: String = "$"
        for product in self.products {
            if product.productIdentifier == heartGood.productID {
                priceWithTax.appendContentsOf("\(product.price)")
                break
            }
        }
        cell.configView(SSHeartGoods(rawValue: indexPath.row)!, priceWithTax: priceWithTax)
        cell.selectionStyle = .None

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // purchase
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? SSHeartTableViewCell {
            for product in self.products {
                if product.productIdentifier == cell.heartGood.productID {
                    let payment = SKPayment(product: product)
                    SKPaymentQueue.defaultQueue().addPayment(payment)
                    break
                }
            }
        }
    }

    // MARK:- SKProductsRequestDelegate
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        self.products = response.products

        if self.products.count != 0 {
            self.heartTableView.reloadData()
        } else {
            SSAlertController.alertConfirm(title: "Error", message: "유효한 상품이 없습니다!\n관리자에게 문의바랍니다.", vc: self, completion: nil)
        }

        self.indicator.hideIndicator()
    }

    // MARK:- SKPaymentTransactionObserver
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.Purchased:
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                self.tapClose(nil)
            case SKPaymentTransactionState.Failed:
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}
