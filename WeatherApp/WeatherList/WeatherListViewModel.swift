//
//  WeatherListViewModel.swift
//  WeatherApp
//
//  Created by Phat Chiem on 6/16/20.
//  Copyright © 2020 Phat Chiem. All rights reserved.
//

import Foundation
import RxSwift
import Moya

protocol WeatherListViewModelProtocol {
    var cells: Observable<[WeatherListCellViewModelProtocol]> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<String?> { get }
}

final class WeatherListViewModel: WeatherListViewModelProtocol {
    let cells: Observable<[WeatherListCellViewModelProtocol]>
    let isLoading: Observable<Bool>
    let error: Observable<String?>

    init(
        query: Observable<String?>,
        repository: WeatherRepositoryProtocol
    ) {
        let request = query
            .flatMapLatest { repository.getWeatherList(query: $0) }
            .share()

        cells = request
            .map { ((try? $0.get()) ?? []).map { WeatherListCellViewModel(model: $0) } }

        isLoading = Observable.merge(query.map { _ in true }, request.map { _ in false })

        error = request
            .map {
                switch $0 {
                case let .failure(error):
                    return "Something went wrong"
                    // TODO: uncomment this if want exact error
//                    return error.localizedDescription
                default:
                    return nil
                }
        }
    }
}
