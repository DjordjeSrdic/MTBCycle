//
//  LogInViewController.swift
//  MTB Cycle
//
//  Created by 30hills on 8/8/17.
//  Copyright © 2017 Djordje Srdic. All rights reserved.
//

import UIKit


class LogInViewController: UIViewController, UITextFieldDelegate, ErrorHandlerProtocol, UITableViewDelegate, UITableViewDataSource, DeleteUserProtocol, UserInfoProtocol {
    
    typealias ActiveTextFields = (currentActiveTF : UITextField?, lastActiveTF : UITextField?, nextActiveTF : UITextField?)
    typealias AlertControllerInfo = (alertControllerTitle : String, alertControllerMessage : String, alertActionYesTitle : String, alertActionNoTitle : String)
    
    @IBOutlet var resetPasswordView: UIView!
    @IBOutlet var blurEffectView: UIVisualEffectView!
    
    @IBOutlet var rpvUserNameTextField: UITextField!
    @IBOutlet var rpvOldPasswordTextField: UITextField!
    @IBOutlet var rpvNewPassTextField: UITextField!
    @IBOutlet var rpvRetypeNewPassTextField: UITextField!
    
    var visualEffect : UIVisualEffect!
    var tmpBlurView : UIVisualEffectView!
    
    var animateSunImageView = UIImageView()
    var animateMoonImageView = UIImageView()
    var counter : Int = 0
    
    var tempViewPoint : CGPoint!
    
    @IBOutlet var deleteUserView: UIView!
    @IBOutlet var deleteUsersTableView: UITableView!
    @IBOutlet var deleteUserViewCancelButton: UIButton!
    @IBOutlet var deleteUserViewDeleteButton: UIButton!
    
    
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var passLabel: UILabel!
    
    @IBOutlet var signUpInfoLabel: UILabel!
    @IBOutlet var signUpInfoLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var userInputStackView: UIStackView!
    @IBOutlet var skyView: UIView!
    
    @IBOutlet var dayNightSkyView: UIView!
    
    @IBOutlet var lastThreeUsersTableView: UITableView!
    @IBOutlet var lastThreeUsersTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var noUserRecordLabel: UILabel!
    
    var tempSignUpInfoLabel : CGFloat!
    
    var activeTextFields : ActiveTextFields?
    var selectedCellIndex : Int = -1
    var selectedUser : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear (animated)
        setUpDelegates()
        setUpUI()
        setUpNotificationObserver()
        initializeVariables()
    }
    
    func setUpNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorWithAnimation(_:)), name: NSNotification.Name(rawValue: "ManageError"), object: nil)
    }
    
    func setUpDelegates() {
        userNameTextField.delegate = self
        passTextField.delegate = self
        rpvUserNameTextField.delegate = self
        rpvOldPasswordTextField.delegate = self
        rpvNewPassTextField.delegate = self
        rpvRetypeNewPassTextField.delegate = self
        CoreDataManager.sharedCoreDataManager.setUpProtocolDelegate(errorHandlerDelegate: self)
        deleteUsersTableView.delegate = self
        deleteUsersTableView.dataSource = self
        lastThreeUsersTableView.delegate = self
        lastThreeUsersTableView.dataSource = self
    }
    
    func  setUpUI() {

        blurEffectView.isHidden = true
        noUserRecordLabel.isHidden = true
        visualEffect = blurEffectView.effect
        blurEffectView.effect = nil
        resetPasswordView.layer.cornerRadius = 20
        
        userInputStackView.alpha = 0
        signUpInfoLabel.alpha = 0
        tempSignUpInfoLabel = signUpInfoLabelHeightConstraint.constant
        signUpInfoLabelHeightConstraint.constant = 0
        
        logInButton.setCustomCornerRadius(selectedView: logInButton, radius: 20)
        signUpButton.setCustomCornerRadius(selectedView: signUpButton, radius: 20)
   
        animateSunImageView.frame = CGRect(x: -80, y: 125, width: 30, height: 30)
        animateSunImageView.layer.cornerRadius = animateSunImageView.frame.size.height / 2
        animateSunImageView.image = UIImage.init(named: "Sunny")
        animateSunImageView.contentMode = .scaleAspectFit
        
        animateMoonImageView.frame = CGRect(x: -80, y: 125, width: 30, height: 30)
        animateMoonImageView.layer.cornerRadius = animateMoonImageView.frame.size.height / 2
        animateMoonImageView.image = UIImage.init(named: "white_moon")
        animateMoonImageView.contentMode = .scaleAspectFit
    
        deleteUserViewCancelButton.setCustomCornerRadius(selectedView: deleteUserViewCancelButton, radius: 15)
        deleteUserViewDeleteButton.setCustomCornerRadius(selectedView: deleteUserViewDeleteButton, radius: 15)
        
        if self.view.frame.size.height < 667 {
            lastThreeUsersTableViewHeightConstraint.constant = 80
        }
    }
    
    func initializeVariables() {
        activeTextFields = ActiveTextFields(nil, nil, nil)
        CoreDataManager.sharedCoreDataManager.fetchListOfUsers()
        lastThreeUsersTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sunMovementAnimation(skyView: skyView,sunImage: animateSunImageView)
        moonMovementAnimation(skyView: skyView, moonImage: animateMoonImageView)
        animateDayNightCycle(controller: self)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
       
            case userNameTextField:
                setCustomKeyboardToolbar(selectedTextField: textField)
        
            case passTextField:
                setCustomKeyboardToolbar(selectedTextField: textField)
        
            case  rpvUserNameTextField:
                setCustomKeyboardToolbar(selectedTextField: textField)
        
            case rpvOldPasswordTextField:
                setCustomKeyboardToolbar(selectedTextField: textField)
            
            case rpvNewPassTextField:
                setCustomKeyboardToolbar(selectedTextField: textField)
        
            case  rpvRetypeNewPassTextField:
                setCustomKeyboardToolbar(selectedTextField: textField)
        
            default:
                return false
            }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        switch textField {
            case userNameTextField:
                    passTextField.becomeFirstResponder()
        
            case passTextField:
                    submit()
        
            case rpvUserNameTextField:
                    rpvOldPasswordTextField.becomeFirstResponder()
            
            case rpvOldPasswordTextField:
                    rpvNewPassTextField.becomeFirstResponder()
            
            case rpvNewPassTextField:
                    rpvRetypeNewPassTextField.becomeFirstResponder()
        
            case rpvRetypeNewPassTextField:
                    resetPassword()
        
            default:
                    return false
            }
        return true
    }
    
    func setCustomKeyboardToolbar(selectedTextField textField : UITextField) {
        
        let toolBar = UIToolbar()
        var toolBarItemsArray = Array<UIBarButtonItem>()
        switch textField {
       
            case userNameTextField:
                toolBarItemsArray.append(doneBarItemButton())
                activeTextFields = ActiveTextFields(userNameTextField, nil, nil)
            
            case passTextField:
                    activeTextFields = (passTextField, userNameTextField, nil)
                    toolBarItemsArray.append(backBarItemButton())
        
            case rpvUserNameTextField:
                    activeTextFields = (rpvUserNameTextField, nil, rpvOldPasswordTextField)
                    toolBarItemsArray.append(doneBarItemButton())
                    toolBarItemsArray.append(forwardBarItemButton())
            
            case rpvOldPasswordTextField:
                    activeTextFields = (rpvOldPasswordTextField, rpvUserNameTextField,rpvNewPassTextField)
                    toolBarItemsArray.append(doneBarItemButton())
                    toolBarItemsArray.append(backBarItemButton())
                    toolBarItemsArray.append(forwardBarItemButton())
            
            case rpvNewPassTextField:
                    activeTextFields = (rpvNewPassTextField, rpvOldPasswordTextField, rpvRetypeNewPassTextField)
                    toolBarItemsArray.append(doneBarItemButton())
                    toolBarItemsArray.append(backBarItemButton())
                    toolBarItemsArray.append(forwardBarItemButton())
        
            case rpvRetypeNewPassTextField:
                    activeTextFields = (rpvRetypeNewPassTextField, rpvNewPassTextField, nil)
                    toolBarItemsArray.append(doneBarItemButton())
                    toolBarItemsArray.append(backBarItemButton())
            
            default:
                return
        }
        
        toolBar.setItems(toolBarItemsArray, animated: false)
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }

    func doneBarItemButton() -> UIBarButtonItem {
        let doneBarItem = UIBarButtonItem.init(barButtonSystemItem: .done,
                                               target: self,
                                               action: #selector(hideKeyboard))
        return doneBarItem
    }
    
    func backBarItemButton() -> UIBarButtonItem {
        let backBarItem = UIBarButtonItem.init(image: UIImage.init(named: "toolBarItem_backArrow_brown"),
                                               style: .plain,
                                               target: self,
                                               action:#selector(previousTextField))
        return backBarItem
    }
    
    func forwardBarItemButton() -> UIBarButtonItem {
        let forwardBarItem = UIBarButtonItem.init(image: UIImage.init(named: "toolBarItem_forwardArrow_brown"),
                                               style: .plain,
                                               target: self,
                                               action:#selector(nextTextField))
        return forwardBarItem
    }
    
    func  previousTextField() {
        activeTextFields?.lastActiveTF?.becomeFirstResponder()
    }

    func hideKeyboard() {
        activeTextFields?.currentActiveTF?.resignFirstResponder()
    }
    
    func nextTextField() {
        activeTextFields?.nextActiveTF?.becomeFirstResponder()
    }
    
    func submit() {
        passTextField.resignFirstResponder()
        guard let name = userNameTextField.text, (userNameTextField.text?.characters.count)! > 0 else {
            createError(errorName: "Invalid Credentials", errorCodeNumber: 3, errorReason: "Usernama field is empty")
            return
        }
        
        guard let password = passTextField.text, (passTextField.text?.characters.count)! > 0 else {
            createError(errorName: "Invalid Credentials", errorCodeNumber: 3, errorReason: "Password field is empty")
            return
        }
        
        if signUpInfoLabel.frame.size.height == 0 {
            
            guard CoreDataManager.sharedCoreDataManager.newLogin(username: name, password: password)  else {
                return
            }
            
            // TO DO napraviti i model u bazi koji ce da prima trenutno ulogovanog usera
        } else {
            guard CoreDataManager.sharedCoreDataManager.newSignUp(username: name, pass: password)  else {
                let alertInfo = AlertControllerInfo("Max user limit reached", "Delete a user to create new one", "Delete", "Cancel")
                deleteUserAlert(alertControllerInfo: alertInfo,
                                alertActionYes: {
                                        (deleteAction) in
                                                self.deleteUserView.alpha = 0
                                                self.deleteUserView.isHidden = false
                                                self.view.addSubview(self.deleteUserView)
                                                self.deleteUserView.center = CGPoint.init(x: self.view.center.x, y: 365)
                                                self.deleteUserView.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
                                                self.showDeleteUserView()
                                }, alertActionNo: {
                                    (cancelAction) in
                            })
                return
            }
        }
        
        let vc : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainUserScreen"))!
        let navVC = UINavigationController.init(rootViewController: vc)
        self.present(navVC, animated: true, completion: nil)
    }
    
    
    
    func submitSuccessful() {
        let vc : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainUserScreen"))!
        let navVC = UINavigationController.init(rootViewController: vc)
        self.present(navVC, animated: true, completion: nil)
    }
    
    
    @IBAction func logInButtonAction(_ sender: Any) {
        // za izbacivanje tastature istog trenutka staviti becomesfirstresponder van if/else-a
        clearTextFields()
        if (userInputStackView.alpha == 0) {
           
            logInButtonAnimation(
                animation: {
                    self.userInputStackView.alpha = 1
                    self.signUpInfoLabel.alpha = 0
            },
                completition: {
                    (succes : Bool) in
                    self.signUpInfoLabelHeightConstraint.constant = 0
                    self.userNameTextField.becomeFirstResponder()
            })
            
        } else {
            if (userNameTextField.text!.characters.count > 0 && passTextField.text!.characters.count > 0) {
                print("user je uneo credentials, odradi login")
            } else {
                logInButtonAnimation(
                        animation: {
                        self.signUpInfoLabel.alpha = 0
                    }, completition: {
                        (success) in
                            self.signUpInfoLabelHeightConstraint.constant = 0
                            self.userNameTextField.becomeFirstResponder()
                    })
                }
            }
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        // za izbacivanje tastature istog trenutka staviti becomesfirstresponder van if/else-a
        clearTextFields()
        if (userInputStackView.alpha == 0) {
            
            signUpButtonAnimation(
                animation: {
                    self.userInputStackView.alpha = 1
                    self.signUpInfoLabel.alpha = 1
                    self.signUpInfoLabelHeightConstraint.constant = self.tempSignUpInfoLabel
            }, completition: {
                        (success) in
                        self.userNameTextField.becomeFirstResponder()
            })
        } else if (signUpInfoLabel.alpha == 0 || signUpInfoLabel.frame.size.height == 0) {
            
            signUpButtonAnimation(
                animation: {
                    self.signUpInfoLabel.alpha = 1
                    self.signUpInfoLabelHeightConstraint.constant = self.tempSignUpInfoLabel
            
            }, completition: {
                    (success : Bool) in
                    self.userNameTextField.becomeFirstResponder()
            })
        }
    }
    
    
    @IBAction func resetPassword(_ sender: Any) {
        showResetPasswordView()
    }
    
    func showResetPasswordView() {
        
        blurEffectView.isHidden = false
        self.view.addSubview(resetPasswordView)
        resetPasswordView.center = CGPoint.init(x: self.view.center.x, y: 180)
        // promeniti ovo 142
        //resetPasswordView.center = self.view.center

        resetPasswordView.transform = CGAffineTransform.init(scaleX: 0.3, y: 0.3)
        resetPasswordView.alpha = 0
        
        showViewAnimation(animation: {
                self.blurEffectView.effect = self.visualEffect
                self.resetPasswordView.alpha = 1
                self.resetPasswordView.transform = CGAffineTransform.identity
        }) {  (success : Bool) in

        }
    }
    
    func hideResetPasswordView() {
         hideViewAnimation(animation: {
    
            self.resetPasswordView.alpha = 0
            self.resetPasswordView.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
            self.blurEffectView.effect = nil
    
        }) { (success : Bool) in
        
                self.resetPasswordView.removeFromSuperview()
                self.blurEffectView.isHidden = true
        }
    }
   
    @IBAction func rpvResetPassButtonAction(_ sender: Any) {
        resetPassword()
    }

    func resetPassword() {
        rpvRetypeNewPassTextField.resignFirstResponder()
        guard let username = rpvUserNameTextField.text else {
            createError(errorName: "Invalid Credentials", errorCodeNumber: 3, errorReason: "Invalid username")
            return
        }
    
        
        guard let oldPassword = rpvOldPasswordTextField.text else {
            createError(errorName: "Invalid Credentials", errorCodeNumber: 3, errorReason: "Invalid password")
            return
        }
        
        guard let newPassword = (rpvNewPassTextField.text == rpvRetypeNewPassTextField.text) ? rpvNewPassTextField.text : nil else {
            createError(errorName: "Invalid Credentials", errorCodeNumber: 3, errorReason: "Invalid password")
            return
        }
        
        if(CoreDataManager.sharedCoreDataManager.newResetPass(username: username, password: oldPassword, newPassword: newPassword)) {
            createError(errorName: "Success", errorCodeNumber: 10, errorReason: "You successfuly changed your password")
        }
        
        clearTextFields()
    }
    
    @IBAction func rpvCloseViewAction(_ sender: Any) {
        hideResetPasswordView()
    }
    
    func deleteUserAlert(alertControllerInfo : AlertControllerInfo, alertActionYes : @escaping (UIAlertAction) -> (), alertActionNo : @escaping (UIAlertAction) -> ()) {
        //"Max user limit reached" "Delete a user to create new one" "Delete" "Cancel"
        
        let alertController = UIAlertController.init(title: alertControllerInfo.alertControllerTitle, message: alertControllerInfo.alertControllerMessage, preferredStyle: .alert)
        
        let alertActionDelete = UIAlertAction.init(title: alertControllerInfo.alertActionYesTitle, style: .destructive, handler: alertActionYes)
        
        let alertActionCancel = UIAlertAction.init(title: alertControllerInfo.alertActionNoTitle, style: .cancel, handler: alertActionNo)
        
        alertController.addAction(alertActionDelete)
        alertController.addAction(alertActionCancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == lastThreeUsersTableView) {
            switch CoreDataManager.sharedCoreDataManager.getListOfUsers().count {
                case 0:
                    noUserRecordLabel.isHidden = false
                    return 0
                case 1:
                    noUserRecordLabel.isHidden = true
                    return 1
                case 2:
                    noUserRecordLabel.isHidden = true
                    return 2
                default:
                    noUserRecordLabel.isHidden = true
                    return 3
            }
        } else {
            return CoreDataManager.sharedCoreDataManager.getListOfUsers().count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView == lastThreeUsersTableView) {
            return 60
        } else {
            return 82
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == lastThreeUsersTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastThreeUsersCell") as! LastThreeUsersTableViewCell
                cell.initWith(lastThreeUser: CoreDataManager.sharedCoreDataManager.getLastThreeUsers(), position: indexPath.row, userInfoProtocolDelegate: self)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "deleteCell") as! DeleteUserTableViewCell
            cell.initCellWith(user: CoreDataManager.sharedCoreDataManager.getListOfUsers(), position: indexPath.row, delegate: self, selectedCellPosition: selectedCellIndex)
            return cell
        }
    }
    
    func selectedCellInfo(user: User, position : Int) {
        if selectedCellIndex != position {
            selectedCellIndex = position
            selectedUser = user
        } else {
            selectedCellIndex = -1
            selectedUser = nil
        }
        deleteUsersTableView.reloadData()
    }
    
    
    @IBAction func cancelDeleteUserButtonAction(_ sender: Any) {
        hideDeleteUserView()
    }
    
    @IBAction func deleteUserActionButton(_ sender: Any) {
        
        let alertInfo = AlertControllerInfo("Delete selected user", "Are you sure ?", "Delete", "Cancel")
        
        guard let _ = selectedUser else {
            createError(errorName: "User was not selected!",
                  errorCodeNumber: 9,
                      errorReason: "User was not selected!")
            return
        }
        
        deleteUserAlert(alertControllerInfo: alertInfo,
                        alertActionYes: {
                                (alertActionYes) in
                                        CoreDataManager.sharedCoreDataManager.deleteUserFromDB(
                                                        obj: self.selectedUser!,
                                                        success: {
                                                                self.clearTextFields()
                                                                self.hideDeleteUserView()
                                }) { (error) in
                                        self.createError(errorName: "Error with deleting user!",
                                                         errorCodeNumber: 8,
                                                         errorReason: "Error with deleting user!")
                                }
                        }) { (alertActionNo) in
                
                        }
    }
    
    func showDeleteUserView() {
        self.showViewAnimation(
            animation: {
                self.deleteUserView.alpha = 1
                self.deleteUserView.transform = CGAffineTransform.identity
        }, completition: { (success) in
            self.deleteUsersTableView.reloadData()
        })
    }
    
    func hideDeleteUserView() {
            hideViewAnimation(
                animation: {
                    self.deleteUserView.alpha = 0
                    self.deleteUserView.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
            }) {
                (success : Bool) in
                    self.deleteUserView.removeFromSuperview()
                    self.deleteUserView.transform = CGAffineTransform.identity
                    self.lastThreeUsersTableView.reloadData()
            }
    }
    
    func clearTextFields() {
        rpvUserNameTextField.text = ""
        rpvOldPasswordTextField.text = ""
        rpvNewPassTextField.text = ""
        rpvRetypeNewPassTextField.text = ""
        userNameTextField.text = ""
        passTextField.text = ""
    }
    
    func selectedCellInfo(user: User) {
        userNameTextField.text = user.userName
        passTextField.text = user.userPass
    }
}
