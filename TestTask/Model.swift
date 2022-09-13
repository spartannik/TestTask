//
//  Model.swift
//  TestTask
//
//  Created by Nikita Yashchenko on 13.09.2022.
//

import Foundation

struct Model {
    let title: String
    let year: Int

    static func createMovie(title: String, year: Int) -> Model {
        Model(title: title, year: year)
    }
}

extension Model: Equatable {
    static func ==(lhs: Model, rhs: Model) -> Bool {
        return lhs.title == rhs.title && lhs.year == rhs.year
    }
}
