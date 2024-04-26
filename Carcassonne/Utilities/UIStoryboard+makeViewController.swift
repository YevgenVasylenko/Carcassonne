//
//  UIStoryboard+makeViewController.swift
//  Carcassonne
//
//  Created by Yevgen Vasylenko on 26.04.2024.
//

import UIKit

extension UIStoryboard {

    static func makeViewController<ViewController: UIViewController>() -> ViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: "\(ViewController.self)") as! ViewController
    }
}
