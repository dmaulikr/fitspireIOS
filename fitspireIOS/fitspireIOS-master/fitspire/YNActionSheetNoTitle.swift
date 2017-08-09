//
//  YNActionSheetNoTitle.swift
//  fitspire
//
//  Created by LUNVCA on 8/8/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit

class YNActionSheetNoTitle: UIViewController {
    var layview:UIView!
    var width:CGFloat!
    var height:CGFloat!
    var CancelButton : UIButton!    //取消按钮
    var delegate :YNActionSheetDelegate!
    var btnArray = [UIButton()]
    let buttonHeight:CGFloat = 60
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.width = self.view.bounds.size.width
        self.height = self.view.bounds.size.height
        self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.view.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.7)
        let tap = UITapGestureRecognizer(target: self, action: #selector(YNActionSheet.tap))
        self.view.addGestureRecognizer(tap)
        
        btnArray = Array()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**
     下来菜单消失
     */
    func tap(){
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     *  添加一个取消按钮
     */
    func addCancelButtonWithTitle(_ Title:String){
        if(layview == nil){
            layview = UIView(frame: CGRect(x: width*0.1,y: height - ( (CGFloat)(btnArray.count) * self.buttonHeight + self.buttonHeight + 30), width: width*0.8, height: (CGFloat)(btnArray.count)*self.buttonHeight+self.buttonHeight+115))
            layview.layer.cornerRadius = 5
            layview.layer.masksToBounds = true
            layview.alpha = 0.9
            self.view.addSubview(layview)
        }else{
            var nowHeight = self.layview.bounds.size.height
            nowHeight += 50
            layview.frame = CGRect(x: width * 0.1, y: height - nowHeight, width: width*0.8, height: nowHeight)
        }
        
        if(CancelButton == nil){
            CancelButton = UIButton(frame: CGRect(x: (CGFloat)(0), y: (CGFloat)(buttonHeight * (CGFloat)(btnArray.count)+10), width: width*0.8, height: buttonHeight))
            CancelButton.setTitle(Title, for: UIControlState())
            CancelButton.layer.cornerRadius = 5
            CancelButton.layer.masksToBounds = true
            CancelButton.backgroundColor = UIColor.red
            CancelButton.addTarget(self, action: #selector(YNActionSheet.tap), for: UIControlEvents.touchUpInside)
            self.layview.addSubview(CancelButton)
        }
        
    }
    /**
     *  添加按钮
     */
    func addButtonWithTitle(_ Title:String){
        if(layview == nil){
            layview = UIView(frame: CGRect(x: width*0.1,y: height - (self.buttonHeight + 10), width: width*0.8, height: self.buttonHeight + 20))
            layview.layer.cornerRadius = 5
            layview.layer.masksToBounds = true
            layview.alpha = 0.9
            self.view.addSubview(layview)
        }else{
            var nowHeight = self.layview.bounds.size.height
            nowHeight += 40
            layview.frame = CGRect(x: width * 0.1, y: height - nowHeight, width: width*0.8, height: nowHeight)
        }
        let btn = UIButton(frame: CGRect(x: 0, y: (CGFloat)(btnArray.count)*buttonHeight, width: width * 0.8, height: buttonHeight - 1))
        btn.tag = btnArray.count
        
            btn.addTarget(self, action: #selector(YNActionSheet.buttonClick(_:)), for: UIControlEvents.touchUpInside)
            btn.backgroundColor = UIColor(red: 0/255, green: 250/255, blue: 135/255, alpha: 1)
            btn.setTitle(Title, for: UIControlState())
            btn.titleLabel!.font = UIFont(name: "Avenir", size: 17.0)
            btn.isEnabled = true
            layview.addSubview(btn)
            btnArray.append(btn)
        
        if(CancelButton != nil){
            let CancelY = CancelButton.frame.origin.y
            CancelButton.frame = CGRect(x: 0, y: CancelY + buttonHeight, width: width*0.8, height: buttonHeight)
        }
    }
    /**
     点击按钮产生事件
     */
    func buttonClick(_ sender:AnyObject){
        let btn = sender as! UIButton
        btn.backgroundColor = UIColor.cyan
        btn.titleLabel?.textColor = UIColor.black
        delegate.buttonClick(btn.tag)
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
}
