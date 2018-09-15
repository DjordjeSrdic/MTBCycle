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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutAction(_ sender: Any) {
     //   CoreDataManager.sharedCoreDataManager.logOut()
        CoreDataManager.sharedCoreDataManager.newLogOut {
            let vc : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "LogIn"))!
            self.present(vc, animated: true, completion: nil)
        }
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
}
