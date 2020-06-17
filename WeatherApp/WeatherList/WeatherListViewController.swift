//
//  WeatherListViewController.swift
//  WeatherApp
//
//  Created by Phat Chiem on 6/16/20.
//  Copyright © 2020 Phat Chiem. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import MBProgressHUD

final class WeatherListViewController: UIViewController {
    private lazy var searchBar = UISearchBar()
    private lazy var tableView = UITableView()
    private var hud: MBProgressHUD?

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather Forecast"
        setupView()
        bindData()
    }

    private func setupView() {
        view.addSubview(searchBar)
        view.addSubview(tableView)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.text = "Saigon"

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(.init(nibName: WeatherListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: WeatherListTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()

        view.addConstraints([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func bindData() {
        typealias Section = SectionModel<Int, WeatherListCellViewModelProtocol>

        let dataSource = RxTableViewSectionedReloadDataSource<Section>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: WeatherListTableViewCell.reuseIdentifier, for: indexPath) as! WeatherListTableViewCell
                cell.viewModel = item
                return cell
        })

        let viewModel = WeatherListViewModel(
            query: searchBar.rx.text
                .distinctUntilChanged()
                .debounce(.microseconds(300), scheduler: MainScheduler.asyncInstance)
                .asObservable(),
            repository: WeatherRepository(provider: .init()))

        viewModel.cells
            .map { [Section(model: 0, items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        viewModel.isLoading
            .bind { [unowned self] in
                if $0 && self.hud == nil {
                    self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                } else {
                    self.hud?.hide(animated: true)
                    self.hud = nil
                }
        }
        .disposed(by: disposeBag)

        viewModel.error
            .bind { [unowned self] in
                guard let message = $0, !message.isEmpty else { return }
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(.init(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
        }
        .disposed(by: disposeBag)
    }
}
