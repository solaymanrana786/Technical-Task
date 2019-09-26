//
//  splashViewController.swift
//  Task
//
//  Created by Solayman Rana on 25/9/19.
//  Copyright © 2019 Solayman Rana. All rights reserved.
//

import UIKit

class splashViewController: UIViewController {


    @IBOutlet weak var logoAnimation: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //gifView.loadGif(name: "Silver-Balls-Swinging")
        
            
            UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
                
                self.logoAnimation.frame = CGRect(x: 200, y: 300, width: 200, height: 200)
                
            }, completion: nil)
          DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.performSegue(withIdentifier: "goto2nd", sender: self)
            }
         //self.logoAnimation.layer.removeAllAnimations()
         //self.performSegue(withIdentifier: "goto2nd", sender: self)
        }

}


/* UIView.animate(withDuration: 1, animations:{
 self.gifView.frame.origin.y -= 100
 }){_ in
 UIView.animateKeyframes(withDuration: 1, delay: 0.25,options: [autorelease, .repeat], animations: {
 self.gifView.frame.origin.y; +=100
 
 })
 }
 self.performSegue(withIdentifier: "goto2nd", sender: self)
 
 }*/

    

