//
//  ViewController.swift
//  TestTask
//
//  Created by Nikita Yashchenko on 31.08.2022.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var titleList: [String] = []
    var yearList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
        yearTF.delegate = self
    }
    
    func createTable() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == yearTF {
                    let allowedCharacters = "1234567890"
                    let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
                    let typedCharacterSet = CharacterSet(charactersIn: string)
                    let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
                    return alphabet


          }
        return true
      }

    
    @IBAction func addButton(_ sender: UIButton) {
        if titleList.contains(titleTF.text ?? "") {
            titleTF.text = "this movie is added"
            yearTF.text = ""
        } else {
            titleList.append(titleTF.text ?? "")
            yearList.append(yearTF.text ?? "")
            tableView.reloadData()
            titleTF.text = ""
            yearTF.text = ""
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell",
                                                 for: indexPath) as! TableViewCell
        cell.stringLabel.text = "\(titleList[indexPath.row]) \(yearList[indexPath.row])"
        return cell
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
}

