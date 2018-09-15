//
//  MainUserScreenViewController.swift
//  MTB Cycle
//
//  Created by 30hills on 8/17/17.
//  Copyright © 2017 Djordje Srdic. All rights reserved.
//

import UIKit

class MainUserScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCALayer()
    }
    
    @IBOutlet weak var blackView: UIView!
    
    var blackViewLayer : CALayer {
        return blackView.layer
    }
    
    @IBAction func logOutAction(_ sender: Any) {
     //   CoreDataManager.sharedCoreDataManager.logOut()
        CoreDataManager.sharedCoreDataManager.newLogOut {
            let vc : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "LogIn"))!
            self.present(vc, animated: true, completion: nil)
        }
    }

    func setupCALayer() {
        
        blackViewLayer.backgroundColor = UIColor.red.cgColor
        blackViewLayer.borderWidth = 60
        blackViewLayer.borderColor = UIColor.blue.cgColor
        blackViewLayer.cornerRadius = 60
        
        blackViewLayer.contents = UIImage(named: "moon")?.cgImage
        blackViewLayer.contentsGravity = kCAGravityCenter
        blackViewLayer.contentsScale = 3.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func ShowInfoVC(_ sender: Any) {
        self.performSegue(withIdentifier: "infoSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoSegue" {
            let vc : InfoViewController = segue.destination as! InfoViewController
        }
    }
    
    @IBAction func rotationGesture(_ sender: Any) {
        print("rotate me bitch")
    }
}
