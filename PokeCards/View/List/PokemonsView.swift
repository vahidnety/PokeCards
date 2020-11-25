//
//  PokemonsView.swift
//  PokeCards
//
//  Created by Vahid on 22/11/2020.
//

import Moya
import RxCocoa
import RxSwift
import Swinject
import UIKit

class PokemonsView: BaseViewController {
    private let listProvider = MoyaProvider<PokemonsService>()

    @IBOutlet var tableView: UITableView!
    var viewModel: PokemonsListViewModel!

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupTableView()
        bindViewModel()
        setTableViewModel()
    }

    private func setupViewModel() {
        viewModel = PokemonsListViewModel(mainProvider: listProvider)
    }

    // MARK: - Private functions

    private func bindViewModel() {
        // fetch pokemon cards
        viewModel.fetchPokemonCards()

        // show initial loading indicator
        viewModel.onShowingLoading
            .map { [weak self] isLoading in
                if isLoading {
                    self?.showLoadingView(self!.view)

                } else {
                    self?.hideLoadingView(self!.view)
                }
            }
            .subscribe()
            .disposed(by: disposeBag)

        // to show more loading view
        viewModel.onShowingLoadingMore
            .map { [weak self] in
                self?.setLoadingMoreView(isLoadingMore: $0)
            }
            .subscribe()
            .disposed(by: disposeBag)

        // to show if there are any alert
        viewModel.onShowAlert
            .map { [weak self] in
                self?.showAlert(title: $0.title ?? "", message: $0.message ?? "")
            }
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func setLoadingMoreView(isLoadingMore: Bool) {
        if isLoadingMore {
            var spinner: UIActivityIndicatorView!

            if #available(iOS 13.0, *) {
                spinner = UIActivityIndicatorView(style: .medium)
            } else {
                // Fallback on earlier versions
                spinner = UIActivityIndicatorView(style: .gray)
            }
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
            tableView.reloadData()
        } else {
            tableView.tableFooterView = UIView(frame: .zero)
            tableView.tableFooterView?.isHidden = true
            tableView.reloadData()
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

        present(alert, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            let vc = segue.destination as? PokemonDetailsView
            vc!.viewModel = PokemonDetailsViewModel(mainProvider: MoyaProvider<PokemonsService>(), pokemonsListViewModel: sender as! PokemonsViewModelProtocol)
        }
    }

    func onItemSelected(viewModel: PokemonsViewModelProtocol) {
        performSegue(withIdentifier: "goToDetails", sender: viewModel)
    }
}

// MARK: - TableView

extension PokemonsView {
    // MARK: - View Model TableView

    private func setTableViewModel() {
        // setting delegate
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        // when cell is selected
        tableView.rx
            .modelSelected(PokemonsViewModelProtocol.self)
            .subscribe(
                onNext: { [weak self] cellType in

                    self?.onItemSelected(viewModel: cellType)
                    if let selectedRowIndexPath = self?.tableView.indexPathForSelectedRow {
                        self?.tableView?.deselectRow(at: selectedRowIndexPath, animated: true)
                    }
                }
            )
            .disposed(by: disposeBag)

        viewModel.pokemonCells.bind(to: tableView.rx.items) { tableView, _, element in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonTableViewCell") as? PokemonTableViewCell else {
                return UITableViewCell()
            }
            cell.viewModel = element

            return cell
        }.disposed(by: disposeBag)

        // For pagination
        tableView.rx.contentOffset
            .flatMap { [weak self] _ in
                self?.tableView.isAtBottomEdge(edgeOffset: 0.0) ?? false
                    ? Observable.just(())
                    : Observable.empty()
            }.asObservable()
            .subscribe { [weak self] _ in
                if let _self = self {
                    _self.viewModel.fetchPokemonCards(isLoadingMore: true)
                }
            }.disposed(by: disposeBag)
    }

    private func setupTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.registerCellNib(PokemonTableViewCell.self)
    }
}

extension PokemonsView: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        100
    }
}
