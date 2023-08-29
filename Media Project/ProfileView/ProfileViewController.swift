//
//  ProfileViewController.swift
//  PhotoGram
//
//  Created by 마르 on 2023/08/29.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    let mainView = ProfileView()
    override func loadView() {
        view.self = mainView
    }
    
    let settingList = ["이름", "사용자 이름", "성별 대명사", "소개", "링크", "성별", "프로페셔널 계정으로 전환", "개인정보 설정"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.rowHeight = 40
    }
    
    override func configureView() {
        super.configureView()
        navigationItem.title = "프로필 편집"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonClicked))
    }
    
    @objc func doneButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        
        cell.label.text = settingList[indexPath.row]
        
        if indexPath.row < 6 {
            cell.textField.placeholder = settingList[indexPath.row]
        } else {
            cell.label.textColor = .systemBlue
//            cell.label.snp.makeConstraints { make in
//                make.width.equalTo(200)
//            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row > 5 { return }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ProfileTableViewCell else { return }
        
        let vc = EditViewController()
        vc.completionHandler = { txt in
            cell.textField.placeholder = txt
        }
        
        guard let text = cell.label.text else { return }
        vc.header = text
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
