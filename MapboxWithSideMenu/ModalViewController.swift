//
//  ModalViewController.swift
//  MapboxWithSideMenu
//
//  Created by ivan on 12.02.2021.
//

import UIKit


class ModalViewController: UIViewController {
    
    let bottomView = UIView()
    let whiteView = UIView()
    let privateLabel = UILabel()
    let privateImageView = UIImageView(image: #imageLiteral(resourceName: "house"))
    let driverButton = UIButton()
    let corporatButton = UIButton()
    
    let menuItems = [0: ["Поездки","Оплата","Что нового","Промокоды","Избранные","Помощь", "Taxi for Business"], 1: ["Настройки","О сервисе"]]
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        setupConstraints()
        driverButton.addTarget(self, action: #selector(driverButtonTapped), for: .touchUpInside)
        corporatButton.addTarget(self, action: #selector(corporatButtonTapped), for: .touchUpInside)
     }
    
    @objc func driverButtonTapped() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func corporatButtonTapped() {
        showDismissAlert(withTitle: "Логин", message: "Корпоративный аккаунт", cancelBlock: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == view {
                presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
        super.touchesBegan(touches, with:event)
    }
}

extension ModalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let menuItem = menuItems[indexPath.section]?[indexPath.row] else { return cell }
        cell.textLabel?.text = menuItem
        cell.imageView?.image = UIImage(named: menuItem)
        if indexPath.section == 1 {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0: return UIView()
        case 1: return nil
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 60 : 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let menuItem = menuItems[indexPath.section]?[indexPath.row] else { return }
        showAlert(withTitle: "\(menuItem)", withMessage: "Section: \(indexPath.section) Row: \(indexPath.row)")
    }
}

extension ModalViewController {
    
    private func setupConstraints() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 1
        
        bottomView.backgroundColor = #colorLiteral(red: 0.9175665975, green: 0.9176985621, blue: 0.9175377488, alpha: 1)
        
        whiteView.backgroundColor = .white
        
        privateLabel.text = "Личный"
        privateLabel.font = UIFont.systemFont(ofSize: 12)
        
        privateImageView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [privateImageView, privateLabel])
        stackView.axis = .vertical
        
        driverButton.setTitle("Taxi Driver", for: .normal)
        driverButton.backgroundColor = #colorLiteral(red: 0.7838824987, green: 0.848469913, blue: 0.9584324956, alpha: 1)
        driverButton.layer.cornerRadius = 10
        
        corporatButton.setImage(#imageLiteral(resourceName: "company"), for: .normal)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        corporatButton.translatesAutoresizingMaskIntoConstraints = false
        driverButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addSubview(bottomView)
        view.addSubview(whiteView)
        view.addSubview(stackView)
        view.addSubview(corporatButton)
        view.addSubview(driverButton)
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            whiteView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            whiteView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            stackView.heightAnchor.constraint(equalToConstant: 85),
            stackView.widthAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            corporatButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            corporatButton.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -15),
            corporatButton.heightAnchor.constraint(equalToConstant: 50),
            corporatButton.widthAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            driverButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            driverButton.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -10),
            driverButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            driverButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
