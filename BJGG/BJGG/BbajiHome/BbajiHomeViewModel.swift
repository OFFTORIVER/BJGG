//
//  BbajiHomeViewModel.swift
//  BJGG
//
//  Created by 이재웅 on 2023/04/11.
//

import UIKit
import Combine

final class BbajiHomeViewModel: ObservableObject {
    @Published var homeWeather: [BbajiHomeWeather] = []
    
    private var cancellable = Set<AnyCancellable>()
    
    init(weatherManager: WeatherManager = WeatherManager()) {
        fetchBbajiHomeWeather(weatherManager: weatherManager)
    }
    
    private func fetchBbajiHomeWeather(weatherManager: WeatherManager) {
        let bbajiInfo = BbajiInfo()
        let bbajiCoord = bbajiInfo.getCoordinate()
        
        Task {
            do {
                let weatherItems = try await weatherManager.requestCurrentTimeWeather(nx: bbajiCoord.x, ny: bbajiCoord.y).response.body.items
                let weatherSet = weatherItems.requestCurrentWeatherItem()
                self.homeWeather = weatherItems.requestWeatherDataSet(weatherSet)
            } catch WeatherManagerError.apiError(let message) {
                print(message)
            } catch WeatherManagerError.networkError(let message) {
                print(message)
            } catch DecodingError.dataCorrupted(let description) {
                print(description.codingPath, description.debugDescription, description.underlyingError ?? "", separator: "\n")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
