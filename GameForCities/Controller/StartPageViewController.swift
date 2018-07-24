//
//  StartPageViewController.swift
//  GameForCities
//
//  Created by Sokol Vadym on 22.07.2018.
//  Copyright © 2018 Sokol Vadym. All rights reserved.
//

import UIKit

class StartPageViewController: UIViewController {

    @IBAction private func startNewGameButton(_ sender: Any) {
       Game.shared.startNewGame()
    }
    
}
