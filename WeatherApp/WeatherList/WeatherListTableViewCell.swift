//
//  WeatherListTableViewCell.swift
//  WeatherApp
//
//  Created by Phat Chiem on 6/16/20.
//  Copyright © 2020 Phat Chiem. All rights reserved.
//

import UIKit

final class WeatherListTableViewCell: UITableViewCell {
    @IBOutlet private var infoLabel: UILabel!

    var viewModel: WeatherListCellViewModelProtocol? {
        didSet {
            infoLabel.text = viewModel?.info
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
}
