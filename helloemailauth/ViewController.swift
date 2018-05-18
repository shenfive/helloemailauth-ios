//
//  ViewController.swift
//  helloemailauth
//
//  Created by 申潤五 on 2018/5/17.
//  Copyright © 2018年 申潤五. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    var mAuth:Auth!

    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginStatus: UITextView!
    @IBOutlet weak var forgetPassword: UIButton!
    @IBOutlet weak var accountInputGRoup: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccount: UIButton!
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // UI初始化
        self.loginStatus.text = "登入狀態：未登入"
        self.accountInputGRoup.isHidden = false
        self.createAccount.isHidden = false
        self.forgetPassword.isHidden = false
        self.loginButton.setTitle("登入", for: .normal)

        //取得 Auth 實體
        mAuth = Auth.auth()

        //監聽登入狀態
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user{
                //登入成功時執行的項目
                self.loginStatus.text = "登入狀態：己登入\n\n帳號：\(String(describing: user.email!))\n顯示名稱：\(String(describing: user.displayName ?? ""))\n己驗證電子郵件：\(user.isEmailVerified)"
                if user.isEmailVerified == false{
                    user.sendEmailVerification(completion: { (error) in
                        if let error = error{
                            print(error.localizedDescription)
                        }else{
                            self.toast(message: "己發出驗證電子郵件，請檢查你的電字郵件信箱完成驗證")
                        }
                    })
                }
                self.accountInputGRoup.isHidden = true
                self.forgetPassword.isHidden = true
                self.createAccount.isHidden = true
                self.loginButton.setTitle("登出", for: .normal)
            }else{
                //登出時執行的項目
                self.loginStatus.text = "登入狀態：未登入"
                self.accountInputGRoup.isHidden = false
                self.createAccount.isHidden = false
                self.forgetPassword.isHidden = false
                self.loginButton.setTitle("登入", for: .normal)
            }
        }
    }

    //登入/登出程式
    @IBAction func loingIn(_ sender: Any) {

        //若目前是登入狀態，就登出並結束處理
        if mAuth.currentUser != nil{
            do{
                try mAuth.signOut()
            }catch{
                print(error.localizedDescription)
            }
            return
        }

        //登入處理
        let accountString = account.text ?? ""
        let passwordString = password.text ?? ""
        if accountString != "" && passwordString != ""{
            mAuth.signIn(withEmail: accountString, password: passwordString) { (user, error) in
                if error != nil{
                    self.toast(message: "錯誤：\(error!.localizedDescription)")
                }
            }
        }else{
            self.toast(message: "請輸入帳號密碼")
        }
    }


    //忘記密碼處理
    @IBAction func forgetPassword(_ sender: Any) {
        let accountString = account.text ?? ""
        if accountString != ""{
            mAuth.sendPasswordReset(withEmail: accountString) { (error) in
                if error == nil{
                    self.toast(message: "重設密碼郵件己送出，請檢查你的電子郵件信箱")
                }else{
                    self.toast(message: "無法重設，說明：\(error!.localizedDescription)")
                }
            }
        }else{
            self.toast(message: "請輸入帳號")
        }
    }

}


// 仿造 Android 的 Toast 功能
extension UIViewController{
    func toast(message:String){
        let alert = UIAlertController.init(title: message, message: nil, preferredStyle: .actionSheet)
        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5 , execute: {
                alert.dismiss(animated: true, completion: nil)
            })
        }
    }
}

