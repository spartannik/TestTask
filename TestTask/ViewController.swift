//
//  ViewController.swift
//  TestTask
//
//  Created by Nikita Yashchenko on 31.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var movieTitleTextField: UITextField!
    @IBOutlet weak var movieYearTextField: UITextField!
    
    private var movieList: [Model] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieYearTextField.delegate = self
        tableviewConfigurator()
    }

    private func tableviewConfigurator() {
        movieTableView.delegate = self
        movieTableView.dataSource = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func addMoviePressed() {
        guard let title = movieTitleTextField.text,
              let year = movieYearTextField.text,
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !year.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            showAlert(title: "Something get wrong", message: "Please, check your information and try again")
            return
        }
        
        let movie = Model(title: title, year: Int(year) ?? 0)

        guard !(movieList.contains(movie)) else {
            showAlert(title: "Movie is already exist", message: "Movie is already exist in your list")
            return
        }

        movieList.append(movie)

        movieTableView.reloadData()

        movieTitleTextField.text = ""
        movieYearTextField.text = ""
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let movie = movieList[indexPath.row]

        cell.textLabel?.text = movie.title
        cell.detailTextLabel?.text = "\(movie.year)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            movieList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == movieYearTextField {
            let allowedCharacters = CharacterSet(charactersIn: "0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
