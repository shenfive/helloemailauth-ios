//
//  CreateAccountViewController.swift
//  helloemailauth
//
//  Created by 申潤五 on 2018/5/18.
//  Copyright © 2018年 申潤五. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var newAccount: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newPasswordC: UITextField!
    @IBOutlet weak var displayName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func createAccount(_ sender: Any) {
        let account = newAccount.text ?? ""
        let password = newPassword.text ?? ""
        let passwordC = newPasswordC.text ?? ""

        if account == "" {toast(message:"請輸入帳號");return}
        if password == ""{toast(message:"請輸入密碼");return}
        if password != passwordC{toast(message:"兩次密碼不一致, 請確認密碼");return}

        //建立帳號
        Auth.auth().createUser(withEmail: account, password: password) { (user, error) in
            if error == nil{
                if let user = user{

                    //成功時修改顯示名稱
                    let request = user.createProfileChangeRequest()
                    request.displayName = self.displayName.text
                    request.commitChanges(completion: { (error) in
                        if error != nil {print(error!.localizedDescription)}
                    })
                }
                self.navigationController?.popViewController(animated: true)
            }else{
                self.toast(message: error!.localizedDescription)
            }
        }
    }

}
