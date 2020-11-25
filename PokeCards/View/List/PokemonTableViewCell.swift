//
//  PokemonTableViewCell.swift
//  PokeCards
//
//  Created by Vahid on 22/11/2020.
//

import Foundation
import UIKit

class PokemonTableViewCell: UITableViewCell {
    @IBOutlet var labelTitle: UILabel!

    @IBOutlet var subTitle: UILabel!

    var viewModel: PokemonsViewModelProtocol? {
        didSet {
            bindViewModel()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func bindViewModel() {
        if let vm = viewModel {
            labelTitle.text = vm.titleViewModel
            subTitle.text = vm.subTitleViewModel
        }
    }
}
