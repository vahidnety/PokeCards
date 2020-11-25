//
//  PokemonDetailsView.swift
//  PokeCards
//
//  Created by Vahid on 22/11/2020.
//
import Kingfisher
import Moya
import RxCocoa
import RxSwift
import UIKit

class PokemonDetailsView: BaseViewController {
    // MARK: - Properties

    var viewModel: PokemonDetailsViewModel!

    private var disposeBag = DisposeBag()

    @IBOutlet var labelType: UILabel!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var contentView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        curveTopCorners()
    }

    // MARK: - Private functions

    private func bindViewModel() {
        viewModel.fetchPokemonDetail()

        viewModel.onShowingLoading
            .map { [weak self] in
                if $0 {
                    self?.showLoadingView(self!.view)
                } else {
                    self?.hideLoadingView(self!.view)
                }
            }
            .subscribe()
            .disposed(by: disposeBag)

        viewModel.onShowAlert
            .map { [weak self] in
                self?.showAlert(title: $0.title ?? "", message: $0.message ?? "")
            }.subscribe()
            .disposed(by: disposeBag)

        viewModel.pokemon
            .map { [weak self] in
                self?.setPokemonDetail(pokemon: $0)
            }.subscribe()
            .disposed(by: disposeBag)
    }

    private func setUI() {
        let screenSize: CGRect = UIScreen.main.bounds
        imageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height * 0.2)
    }

    private func setPokemonDetail(pokemon: Pokemon) {
        contentView.isHidden = false

        imageView.kf.indicatorType = .activity

        if let imageURL = pokemon.imageURL, let url = URL(string: imageURL) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(named: "placeHolder")
        }

        labelName.text = "Name: " + pokemon.name
        labelType.text = "Type: " + (pokemon.types![0] as! String)
    }

    private func curveTopCorners() {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 32, height: 0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

        present(alert, animated: true)
    }
}
