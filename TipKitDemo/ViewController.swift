//
//  ViewController.swift
//  TipKitDemo
//
//  Created by 贺文杰 on 2024/5/27.
//

import UIKit
import TipKit

class ViewController: UIViewController {
    
    var oTip = operationTip()
    var sTip = InlineTip()
    var tipUIPopoverVC: TipUIPopoverViewController?
    var inlineTipTask: Task<Void, Never>?
    var operationTipTask: Task<Void, Never>?

    lazy var tipView : TipUIView = {
        let tipv = TipUIView(oTip, arrowEdge: .bottom)
        tipv.backgroundColor = .black
        tipv.tintColor = .red
        tipv.cornerRadius = 6.0
        tipv.imageSize = CGSize(width: 40, height: 40)
        tipv.translatesAutoresizingMaskIntoConstraints = false
        return tipv
    }()

    lazy var bttn: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        button.setTitle("测试", for: .normal)
        button.backgroundColor = .blue
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button .addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.addSubview(bttn)
        
        Task{
            await InlineTip.appOpenedCount.donate()
        }
    }

    @objc func btnClick(){
        print("各网格万能工匠污泥干化哦i问你")
        InlineTip.showTip = true
        
        inlineTipTask = inlineTipTask ?? Task { @MainActor in
            for await shouldDisplay in sTip.shouldDisplayUpdates {
                if shouldDisplay {
                    tipUIPopoverVC = TipUIPopoverViewController(sTip, sourceItem: bttn)
                    present(tipUIPopoverVC!, animated: true)
                }else{
                    tipUIPopoverVC?.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        operationTipTask = operationTipTask ?? Task { @MainActor in
            for await shouldDisplay in oTip.shouldDisplayUpdates {
                if shouldDisplay {
                    view.addSubview(tipView)
                    NSLayoutConstraint.activate([
                        tipView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
                        tipView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                        tipView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
                    ])
                }else{
                    tipView.removeFromSuperview()
                }
            }
            
        }
    }

}

