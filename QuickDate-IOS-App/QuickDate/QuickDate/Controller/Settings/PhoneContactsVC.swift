//
//  PhoneContactsVC.swift
//  Playtube
//
//  Created by hunain khan on 09/02/2022.
//  Copyright © 2022 Muhammad Haris Butt. All rights reserved.
//

import UIKit
import MessageUI

struct FetchedContact {
    var firstName: String
    var lastName: String
    var telephone: String
}

class PhoneContactsVC: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Selectors
    
    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Functions
    
    // Initial Config
    func initialConfig() {
        self.registerCell()
    }
    
    // Register Cell
    func registerCell() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(resource: R.nib.contactCell), forCellReuseIdentifier: R.reuseIdentifier.contactCell.identifier)
    }
    
}

// MARK: - Extensions

// MARK: TableView Setup
extension PhoneContactsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppInstance.shared.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.contactCell.identifier, for: indexPath) as! ContactCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.nameLabel?.text = AppInstance.shared.contacts[indexPath.row].firstName + " " + AppInstance.shared.contacts[indexPath.row].lastName
        cell.phoneNumberLabel?.text = AppInstance.shared.contacts[indexPath.row].telephone
        return cell
    }
    
    private func sendSMSButtonAction(number: String) {
        guard MFMessageComposeViewController.canSendText() else {
            print("Unable to send messages.")
            return
        }
        let controller = MFMessageComposeViewController()
        controller.messageComposeDelegate = self
        controller.recipients = [number]
        controller.body = "Hi, lets join QuickDate together"
        present(controller, animated: true)
    }    
}

extension PhoneContactsVC: ContactSendDelegate {
    func sendBtnAction(_ sender: UIButton, _ indexPath: IndexPath) {
        self.view.endEditing(true)
        self.sendSMSButtonAction(number: AppInstance.shared.contacts[indexPath.row].telephone)
    }
}

// MARK: MFMessageComposeViewControllerDelegate Methods -
extension PhoneContactsVC: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
