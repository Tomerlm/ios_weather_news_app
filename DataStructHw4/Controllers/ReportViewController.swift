//
//  ReportViewController.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 12/5/18.
//  Copyright © 2018 Tomer Landesman. All rights reserved.
//

import UIKit


class ReportViewController: UIViewController , UITextViewDelegate{
    
    let VIEW_OFFSET: CGFloat = 17

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setTextViewLayout(textView: problemTextView)
        setViewLayout(view: greenView)
        setViewLayout(view: redView)
        problemTextView.delegate = self

        redMinHeight = redViewHeight.constant
        greenMinHeight = greenViewHeight.constant

        
    }
    
    @IBOutlet weak var pinchScaleView: UIView!
    @IBOutlet weak var problemTextView: UITextView!

    
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var redViewHeight: NSLayoutConstraint!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var greenViewHeight: NSLayoutConstraint!
    var pinchStartImageCenter : CGPoint!
    var redMinHeight : CGFloat!
    var greenMinHeight : CGFloat!
    @IBAction func pinchGesture(_ sender: UIPinchGestureRecognizer){
        if sender.state == .began || sender.state == .changed {
            let currentScale = self.pinchScaleView.frame.size.width / self.pinchScaleView.bounds.size.width
            var newScale = currentScale*sender.scale
            if newScale < 1{
                newScale = 1
            }
            if newScale > 3.5 {
                newScale = 3.5
                sendMessege()
                sender.state = .ended
            }
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            self.pinchScaleView.transform = transform
            sender.scale = 1
        }
        else if sender.state == .ended {
            UIView.animate(withDuration: 0.3, animations: {
                self.pinchScaleView.transform = CGAffineTransform.identity
            })
        }
    }

    
    func setTextViewLayout(textView: UITextView){
        
        textView.layer.cornerRadius = textView.frame.height / 3
        textView.isEditable = true
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowRadius = 2
        textView.layer.shadowOpacity = 0.5
        textView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
    
    func setViewLayout(view: UIView){
        
        view.layer.cornerRadius = redView.frame.height / 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        problemTextView.resignFirstResponder()
    }

    
    func sendMessege(){
        let alert = UIAlertController(title: "Error", message: "no one cares.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // TextViewDelegate functions
    public func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width - VIEW_OFFSET , height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach{(constraints) in
            if constraints.firstAttribute == .height{
                constraints.constant = estimatedSize.height
                greenView.setNeedsLayout()
                

            }
        }
    }
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    

    
}

