//
//  ViewController.swift
//  TestTask
//
//  Created by Nikita Yashchenko on 31.08.2022.
//

import UIKit

struct Model {
    let title: String
    let year: String
    
    static func createMovie(title: String, year: String) -> Model {
        Model(title: title, year: year)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var movieTitleTextField: UITextField!
    @IBOutlet weak var movieYearTextField: UITextField!
    
    private var movieList: [Model] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieYearTextField.delegate = self
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.separatorStyle = .none
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
            showAlert()
            return
        }
        
        let movie = Model.createMovie(title: title, year: year)
        if !(movieList.contains(movie)) {
            movieList.append(movie)
            movieTableView.reloadData()
        }
        
        movieTitleTextField.text = ""
        movieYearTextField.text = ""
    }
    
    private func showAlert() {
        let alertController = UIAlertController(
            title: "Has already been added",
            message: "Сheck your list",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .destructive)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

extension Model: Equatable {
    static func ==(lhs: Model, rhs: Model) -> Bool {
        return lhs.title == rhs.title && lhs.year == rhs.year
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let movie = movieList[indexPath.row]
        cell.configureCell(with: movie)
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

extension UITableViewCell {
    func configureCell(with movie: Model) {
        var content = defaultContentConfiguration()
        content.text = movie.title
        content.secondaryText = movie.year
        contentConfiguration = content
    }
}

