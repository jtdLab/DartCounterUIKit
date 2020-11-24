//
//  ThrowDetailsViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 15.11.20.
//

import UIKit

protocol DimissManager {
  func onDismiss()
}

class CheckoutDetailsViewController: UIViewController {

    @IBOutlet weak var btn_dartsThrown_1: UIButton!
    @IBOutlet weak var btn_dartsThrown_2: UIButton!
    @IBOutlet weak var btn_dartsThrown_3: UIButton!
    @IBOutlet weak var btn_dartsOnDouble_0: UIButton!
    @IBOutlet weak var btn_dartsOnDouble_1: UIButton!
    @IBOutlet weak var btn_dartsOnDouble_2: UIButton!
    @IBOutlet weak var btn_dartsOnDouble_3: UIButton!
    @IBOutlet weak var btn_submit: UIButton!
    
    
    @IBAction func onDartsThrown1(_ sender: UIButton) {
        onDartsThrown(digit: 1)
    }
    
    @IBAction func onDartsThrown2(_ sender: UIButton) {
        onDartsThrown(digit: 2)
    }
    
    @IBAction func onDartsThrown3(_ sender: UIButton) {
        onDartsThrown(digit: 3)
    }
    
    @IBAction func onDartsOnDouble0(_ sender: UIButton) {
        onDartsOnDouble(digit: 0)
    }
    
    @IBAction func onDartsOnDouble1(_ sender: UIButton) {
        onDartsOnDouble(digit: 1)
    }
    
    @IBAction func onDartsOnDouble2(_ sender: UIButton) {
        onDartsOnDouble(digit: 2)
    }
    
    @IBAction func onDartsOnDouble3(_ sender: UIButton) {
        onDartsOnDouble(digit: 3)
    }
    
    @IBAction func onSubmit(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    var delegate: DimissManager?
    var pointsLeft: Int?
    var pointsScored: Int?
    var dartsThrown: Int = 1
    var dartsOnDouble: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        App.game!.performThrow(t: Throw(points: pointsScored!, dartsOnDouble: dartsOnDouble, dartsThrown: dartsThrown))
        delegate?.onDismiss()
    }
    
    private func initView() {
        btn_dartsOnDouble_2.isHidden = true
        btn_dartsOnDouble_3.isHidden = true
    }

}

// Contains UserEventHandling
extension CheckoutDetailsViewController {
    
    func onDartsThrown(digit: Int) {
        // TODO reset all buttons to default looking
        btn_dartsThrown_1.backgroundColor = .black
        btn_dartsThrown_1.tintColor = .black
        
        btn_dartsThrown_2.backgroundColor = .black
        btn_dartsThrown_2.tintColor = .black
        
        btn_dartsThrown_3.backgroundColor = .black
        btn_dartsThrown_3.tintColor = .black
        
        switch digit {
        case 1:
            dartsThrown = 1
            btn_dartsThrown_1.isSelected = true
            btn_dartsThrown_1.backgroundColor = .systemGreen
            btn_dartsThrown_1.tintColor = .systemGreen
            btn_dartsOnDouble_0.isHidden = false
            btn_dartsOnDouble_1.isHidden = false
            btn_dartsOnDouble_2.isHidden = true
            btn_dartsOnDouble_3.isHidden = true
            break
        case 2:
            dartsThrown = 2
            btn_dartsThrown_2.isSelected = true
            btn_dartsThrown_2.backgroundColor = .systemGreen
            btn_dartsThrown_2.tintColor = .systemGreen
            btn_dartsOnDouble_0.isHidden = false
            btn_dartsOnDouble_1.isHidden = false
            btn_dartsOnDouble_2.isHidden = false
            btn_dartsOnDouble_3.isHidden = true
            break
        case 3:
            dartsThrown = 3
            btn_dartsThrown_3.isSelected = true
            btn_dartsThrown_3.backgroundColor = .systemGreen
            btn_dartsThrown_3.tintColor = .systemGreen
            btn_dartsOnDouble_0.isHidden = false
            btn_dartsOnDouble_1.isHidden = false
            btn_dartsOnDouble_2.isHidden = false
            btn_dartsOnDouble_3.isHidden = false
            break
        default:
            return
        }
        
        onDartsOnDouble(digit: 0)
    }
    
    func onDartsOnDouble(digit: Int) {
        if dartsThrown >= digit {
            btn_dartsOnDouble_0.backgroundColor = .black
            btn_dartsOnDouble_0.tintColor = .black
            
            btn_dartsOnDouble_1.backgroundColor = .black
            btn_dartsOnDouble_1.tintColor = .black
            
            btn_dartsOnDouble_2.backgroundColor = .black
            btn_dartsOnDouble_2.tintColor = .black
            
            btn_dartsOnDouble_3.backgroundColor = .black
            btn_dartsOnDouble_3.tintColor = .black
            
            switch digit {
            case 0:
                dartsOnDouble = 0
                btn_dartsOnDouble_0.isSelected = true
                btn_dartsOnDouble_0.backgroundColor = .systemGreen
                btn_dartsOnDouble_0.tintColor = .systemGreen
                break
            case 1:
                dartsOnDouble = 1
                btn_dartsOnDouble_1.isSelected = true
                btn_dartsOnDouble_1.backgroundColor = .systemGreen
                btn_dartsOnDouble_1.tintColor = .systemGreen
                break
            case 2:
                dartsOnDouble = 2
                btn_dartsOnDouble_2.isSelected = true
                btn_dartsOnDouble_2.backgroundColor = .systemGreen
                btn_dartsOnDouble_2.tintColor = .systemGreen
                break
            case 3:
                dartsOnDouble = 3
                btn_dartsOnDouble_3.isSelected = true
                btn_dartsOnDouble_3.backgroundColor = .systemGreen
                btn_dartsOnDouble_3.tintColor = .systemGreen
                break
            default:
                return
            }
            
        }
    }
    
}
