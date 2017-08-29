//
//  CoreDataManager.swift
//  MTB Cycle
//
//  Created by 30hills on 8/16/17.
//  Copyright © 2017 Djordje Srdic. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager  {

    static let sharedCoreDataManager = CoreDataManager()
    let appDelegate : AppDelegate
    let managedContext : NSManagedObjectContext
    var listOfUsers : [User]
    typealias UserInfo = (userName : String?, password : String?, userId : String?, sessionStart : String?, sessionEnd : String?)

    private var user : User
    private var logedInUser : LogedInUser
    private var entity : NSEntityDescription
    private var delegate : ErrorHandlerProtocol?
    private var userInfo : UserInfo?
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        listOfUsers = [User]()
        user = User()
        logedInUser = LogedInUser()
        entity = NSEntityDescription()
    }
    
    
    func setUpProtocolDelegate(errorHandlerDelegate : ErrorHandlerProtocol) {
        delegate = errorHandlerDelegate
    }
    
//    func userSignUp(username name : String, userPassword password : String) -> (String)? {
//        
//        entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
//        
//        user = User(entity: entity, insertInto: managedContext)
//        let userId : String = UUID().uuidString
//        user.setValue(name, forKey: "userName")
//        user.setValue(password, forKey: "userPass")
//        user.setValue(userId, forKey: "userId")
//        user.setValue(getCurrentDate(), forKey: "userStartSessionDate")
//        
//        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        
//        let userInfo = UserInfo(name, password, userId, getCurrentDate(), nil)
//        
//        do {
//            try  managedContext.save()
//            listOfUsers.append(user)
//            saveToLogedInUserDB(userInfo: userInfo)
//            return userId
//        } catch let error as NSError {
//            delegate?.setUpErrorNotification(error: error)
//            return nil
//        }
//    }
//    
//    func updateUserEndSessionDate() {
//        fetchRequest()
//        for object in listOfUsers {
//            if logedInUser.logedInUserId == object.userId {
//                    object.userEndSessionDate = getCurrentDate()
//                do {
//                    try managedContext.save()
//                } catch let error as NSError {
//                    delegate?.setUpErrorNotification(error: error)
//                }
//                break
//            }
//        }
//    }
//    
//    
//    func getUserData(userId id : String) -> (String?) {
//        fetchRequest()
//        for userInDB in listOfUsers {
//            
//            if userInDB.value(forKeyPath: "userId") as! String == id  {
//                return userInDB.value(forKeyPath: "userName") as? (String)
//            }
//        }
//        delegate?.createError(errorName: "NoUserInDataBase", errorCodeNumber: 2, errorReason: "User does not exist")
//        return nil
//    }
//    
//    func logInUser(userName name : String, password pass : String) -> (String)? {
//
//        fetchRequest()
//        for userInDB in listOfUsers {
//            let userExists = validate(username: name, password: pass, user: userInDB)
//            if userExists {
//                let tempUserId = userInDB.value(forKeyPath: "userId") as! String
//                let userInfo = UserInfo(userInDB.userName, userInDB.userPass, userInDB.userId, getCurrentDate(), userInDB.userEndSessionDate)
//                saveToLogedInUserDB(userInfo: userInfo)
//                return tempUserId
//            }
//        }
//        delegate?.createError(errorName: "NoUserId", errorCodeNumber: 1, errorReason: "User does not exist")
//        return  nil
//    }
//    
//    func fetchRequest() {
//        let fetchRequest = NSFetchRequest<User>(entityName: "User")
//        do {
//            try listOfUsers = managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            delegate?.setUpErrorNotification(error: error)
//        }
//    }
//
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter.string(from: Date())
    }
//
//    func validate(username : String, password : String, user : User) -> Bool {
//        return (user.value(forKeyPath: "userName") as! String == username && user.value(forKeyPath: "userPass") as! String == password) ? true : false
//    }
//    
//   
//    func saveToLogedInUserDB(userInfo : UserInfo) {
//        entity = NSEntityDescription.entity(forEntityName: "LogedInUser", in: managedContext)!
//        logedInUser = LogedInUser(entity: entity, insertInto: managedContext)
//        logedInUser.setValue(userInfo.userName, forKey: "logedInUserName")
//        logedInUser.setValue(userInfo.password, forKey: "logedInUserPass")
//        logedInUser.setValue(userInfo.userId, forKey: "logedInUserId")
//        logedInUser.setValue(userInfo.sessionStart, forKey: "logedInUserStartSessionDate")
//        logedInUser.setValue(userInfo.sessionEnd, forKey: "logedInUserEndSessionDate")
//        do {
//            try  managedContext.save()
//        }  catch let error as NSError {
//                delegate?.setUpErrorNotification(error: error)
//        }
//    }
    
    
    
    
//    func logOut()  {
//       // updateUserEndSessionDate()
//        entity = NSEntityDescription.entity(forEntityName: "LogedInUser", in: managedContext)!
//        logedInUser = LogedInUser(entity: entity, insertInto: managedContext)
//        let fetchReq = NSFetchRequest<LogedInUser>(entityName: "LogedInUser")
//        do {
//            let results = try managedContext.fetch(fetchReq)
//            for object : LogedInUser in results {
//                managedContext.delete(object)
//            }
//            do {
//                try managedContext.save()
//            } catch let saveError as NSError {
//                delegate?.setUpErrorNotification(error: saveError)
//            }
//
//        } catch let error as NSError {
//            delegate?.setUpErrorNotification(error: error)
//        }
//        
//    }
//    
    
    func doCatchClousure(entityName : String, success :@escaping (Any) -> (), failure :@escaping (NSError) -> ()) {
        var fetchRequest : NSFetchRequest<NSFetchRequestResult>
        
        switch entityName {
            case "LogedInUser":
                fetchRequest = NSFetchRequest<LogedInUser>(entityName: "LogedInUser") as! NSFetchRequest<NSFetchRequestResult>
                break
            
            case "User":
                fetchRequest = NSFetchRequest<User>(entityName: "User") as! NSFetchRequest<NSFetchRequestResult>
                break
            
            default:
                fetchRequest = NSFetchRequest()
                break
        }
        
        do {
            let results =  try managedContext.fetch(fetchRequest)
            success(results)
        } catch let error as NSError {
            failure(error)
        }
    }
    
    
    func fetchListOfUsers() {
        doCatchClousure(entityName: "User",
                        success: {
                            (results) in
                                self.listOfUsers = results as! [User]
                    }) {    (error) in
                                self.delegate?.setUpErrorNotification(error: error)
                        }
    }
    
    func fetchLogedInUser() {
        doCatchClousure(entityName: "LogedInUser",
                        success: {
                            (results) in
                                for obj in results as! [LogedInUser] {
                                    self.logedInUser = obj
                                }
                    }) {    (error) in
                                self.delegate?.setUpErrorNotification(error: error)
                        }
    }
    
    func setUserInfo(_ username : String,_ password : String,_ userId : String?,_ userStartSession : String,_ userEndSession : String?) {
            userInfo = UserInfo(username, password, userId, userStartSession, userEndSession)
    }
    
    func validate(onForm : String, username : String, password : String?) -> Bool {
        
        switch onForm {
            case "Login":
                    for tmpUser in listOfUsers {
                        if tmpUser.userName == username && tmpUser.userPass == password {
                            return true
                        }
                    }
                    return false
            case "SignUp":
                    for tmpUser in listOfUsers {
                        if tmpUser.userName == username {
                            return false
                        }
                    }
                    return true
            case "ResetPass":
                for tmpUser in listOfUsers {
                    if tmpUser.userName == username && tmpUser.userPass == password {
                        user = tmpUser
                        return true
                    }
                }
                return false
            default:
                return false
        }
    }
    
    func newSignUp(username : String, pass : String) -> Bool {
        fetchListOfUsers()
        guard let newUsername = (validate(onForm: "SignUp", username: username, password: nil) ? username : nil) else {
            self.delegate?.createError(errorName: "Username taken", errorCodeNumber: 4, errorReason: "Username taken")
            return false
        }
        
        if listOfUsers.count >= 10 {
            // pitati usera pop upon da li hoce da obrise nekog usera 
//                    - ako hoce obrisi jednog kog on izabere i nastaviti sa sign up-om
//                    - ako nece obustaviti sign up
            return false
        } else {
         
            entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
            user = User(entity: entity, insertInto: managedContext)
            entity = NSEntityDescription.entity(forEntityName: "LogedInUser", in: managedContext)!
            logedInUser = LogedInUser(entity: entity, insertInto: managedContext)
            let userId : String = UUID().uuidString
            setUserInfo(newUsername, pass, userId, getCurrentDate(), nil)
            addUserInGlobalDB(userInfo: userInfo!)
            addUserInTmpDB(userInfo: userInfo!)
            managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            var returnValue : Bool?
            saveUserToDB(
                    success: {
                        returnValue = true
                }, failure: {
                        (error) in
                           self.delegate?.setUpErrorNotification(error: error)
                           returnValue = false
            })
            return returnValue!
        }
    }
    
    func newLogin(username : String, password : String) -> Bool {
        fetchListOfUsers()
        if (!validate(onForm: "Login", username: username, password: password)) {
            delegate?.createError(errorName: "NoUserId", errorCodeNumber: 1, errorReason: "User does not exist")
            return false
        }
        entity = NSEntityDescription.entity(forEntityName: "LogedInUser", in: managedContext)!
        logedInUser = LogedInUser(entity: entity, insertInto: managedContext)
        setUserInfo(username, password, getUserId(username), getCurrentDate(), nil)
        addUserInTmpDB(userInfo: userInfo!)
        var returnValue : Bool?
        saveUserToDB(
                success: {
                    self.newUpdateUserSession("startSession")
                    returnValue = true
            }) {
                (error) in
                    self.delegate?.setUpErrorNotification(error: error)
                returnValue = false
            }
        return returnValue!
    }
    
    func getUserId(_ username : String) -> String? {
        for obj in listOfUsers {
            if obj.userName == username {
                return obj.userId
            }
        }
        return nil
    }
    
    func addUserInGlobalDB(userInfo : UserInfo) {
            user.userName = userInfo.userName
            user.userPass = userInfo.password
            user.userId = userInfo.userId
            user.userStartSessionDate = userInfo.sessionStart
            user.userEndSessionDate = userInfo.sessionEnd
    }
    
    func addUserInTmpDB(userInfo : UserInfo) {
            logedInUser.logedInUserName = userInfo.userName
            logedInUser.logedInUserPass = userInfo.password
            logedInUser.logedInUserId = userInfo.userId
            logedInUser.logedInUserStartSessionDate = userInfo.sessionStart
            logedInUser.logedInUserEndSessionDate = userInfo.sessionEnd
    }
    
    func saveUserToDB(success : @escaping () -> (), failure : @escaping (NSError) -> ()) {
        do {
            try managedContext.save()
            success()
        } catch let error as NSError {
            failure(error)
        }
    }
    
    func deleteUserFromDB(obj : NSManagedObject ,success : @escaping () -> (), failure : @escaping (NSError) -> ()) {
        do {
            managedContext.delete(obj)
            try managedContext.save()
            success()
        } catch let error as NSError {
            failure(error)
        }
    }
    
    
    
    func newUpdateUserSession(_ session : String) {
        fetchListOfUsers()
        fetchLogedInUser()
        for obj in listOfUsers {
            if obj.userId == logedInUser.logedInUserId {
                switch session {
                    case "endSession":
                        obj.userEndSessionDate = getCurrentDate()
                        break
                    case "startSession":
                        obj.userStartSessionDate = getCurrentDate()
                        break
                    default:
                        break
                    }

                saveUserToDB(
                        success: {
                    
                }, failure: {
                        (error) in
                            self.delegate?.setUpErrorNotification(error: error)
                })
                break
            }
        }
    }
    
    func newLogOut(success : @escaping () -> ())  {
        newUpdateUserSession("endSession")
        deleteUserFromDB(obj: logedInUser,
                     success: {
                        success()
                    }) {
                        (error) in
                            self.delegate?.setUpErrorNotification(error: error)
                    }
        }
   
    func newResetPass(username : String, password : String, newPassword : String) -> Bool {
            fetchListOfUsers()
        if (!validate(onForm: "ResetPass" , username: username, password: password)) {
            delegate?.createError(errorName: "Invalid Credentials", errorCodeNumber: 3, errorReason: "Invalid password")
            return false
        }
        
        user.userPass = newPassword
        var returnValue : Bool?
        saveUserToDB(
                success: {
                    returnValue = true
            }) { (error) in
                    self.delegate?.setUpErrorNotification(error: error)
                    returnValue = false
        }
        return returnValue!
    }
    
    func getListOfUsers() -> Array<User> {
        return listOfUsers
    }
    
    func getLastThreeUsers() -> Array<User> {
        fetchListOfUsers()
        let listOfDates : Array<User> = listOfUsers.sorted {
            (userOne, userTwo) -> Bool in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let userOneDate = dateFormatter.date(from: userOne.userEndSessionDate!)
                let userTwoDate = dateFormatter.date(from: userTwo.userEndSessionDate!)
                if userOneDate! > userTwoDate! {
                    return true
                } else {
                    return false
                }
        }
        return listOfDates
    }
    
}
