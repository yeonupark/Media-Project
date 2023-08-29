//
//  EditViewController.swift
//  Media Project
//
//  Created by 마르 on 2023/08/29.
//

import UIKit

class EditViewController: BaseViewController {
    
    var completionHandler: ((String) -> Void)?
    var header = ""
    let textField = {
        let view = UITextField()
        //view.backgroundColor = .lightGray
        //view.layer.borderWidth = 1
        view.placeholder = "이곳에 입력하세요"
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = header
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let text = textField.text else { return }
        completionHandler?(text)
    }
    
    override func configureView() {
        super.configureView()
        view.addSubview(textField)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonClicked))
    }
    
    @objc func doneButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    override func setConstraints() {
        textField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
    }
}
