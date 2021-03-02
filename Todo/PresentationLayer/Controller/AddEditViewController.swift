//
//  AddEditViewController.swift
//  Todo
//
//  Created by Айдана on 1/9/21.
//

import SnapKit

class AddEditViewController: UIViewController, UITextFieldDelegate {
    
    var didSave: (_ name: String, _ information: String) -> Void = { name, information in }
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let informationTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        return navigationBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI(){
        view.backgroundColor = .white
        configureNameTextField()
        configureInformationTextField()
        configureNavigationBar()
    }
    
    private func configureNameTextField() {
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }
    }
    
    private func configureInformationTextField() {
        self.view.addSubview(informationTextField)
        informationTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }
    }
    
    private func configureNavigationBar() {
        let addButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(addButtonDidPress))
        self.navigationItem.rightBarButtonItem  = addButton
    }
    
    @objc private func addButtonDidPress(){
        didSave(nameTextField.text!, informationTextField.text!)
        self.navigationController?.popViewController(animated: true)
    }
}


