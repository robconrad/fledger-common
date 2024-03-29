//
//  LoginViewControllerUtils.swift
//  FledgerCommon
//
//  Created by Robert Conrad on 8/16/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation


public protocol LoginViewHelperDataSource {
    
    func getEmail() -> String
    func getPassword() -> String
    
}

public protocol LoginViewHelperDelegate {
    
    func notifyEmailValidity(valid: Bool)
    func notifyPasswordValidity(valid: Bool)
    func notifyLoginResult(valid: Bool)
    
}

public class LoginViewHelper {
    
    private let dataSource: LoginViewHelperDataSource
    private let delegate: LoginViewHelperDelegate
    
    public required init(_ dataSource: LoginViewHelperDataSource, _ delegate: LoginViewHelperDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    public func loginFromCache() {
        if ParseSvc().isLoggedIn() {
            handleSuccess()
        }
    }
    
    public func login() {
        if !validateFields() {
            return
        }
        
        ParseSvc().login(dataSource.getEmail(), dataSource.getPassword(), { success in
            if success {
                self.handleSuccess()
            }
            else {
                self.delegate.notifyLoginResult(false)
            }
        })
    }
    
    public func signup() {
        if !validateFields() {
            return
        }
        
        ParseSvc().signup(dataSource.getEmail(), dataSource.getPassword(), { success in
            if success {
                self.handleSuccess()
            }
            else {
                self.delegate.notifyEmailValidity(false)
            }
        })
    }
    
    public func validateFields() -> Bool {
        var valid = true
        
        delegate.notifyEmailValidity(true)
        if dataSource.getEmail().characters.count < 5 {
            delegate.notifyEmailValidity(false)
            valid = false
        }
        
        delegate.notifyPasswordValidity(true)
        if dataSource.getPassword().characters.count < 3 {
            delegate.notifyPasswordValidity(false)
            valid = false
        }
        
        return valid
    }
    
    private func handleSuccess() {
        // services can't be registered until a User is logged in
        ServiceBootstrap.register()
        delegate.notifyLoginResult(true)
    }
    
}