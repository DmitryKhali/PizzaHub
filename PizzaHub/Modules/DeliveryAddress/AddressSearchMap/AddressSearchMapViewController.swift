//
//  AddressSearchMapViewController.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 15.02.2026.
//

import Foundation
import SnapKit
import MapKit
import CoreLocation

//1. Создаем mapView и растягиваем его на экран
//2. Берем локацию и регион и просовываем в карту
//3. Считываем локацию по центру карты с помощью метода делегата карты - mapView:regionDidChangeAnimated:
//4. Отображаем по центру карты иконку с пином

final class AddressSearchMapViewController: UIViewController {
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        
        return mapView
    }()
    
//    private let pinImageView: UIImageView = {
//        var imageView = UIImageView()
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
}

// MARK: - Setup
extension AddressSearchMapViewController {
    private func setupViews() {
        view.addSubview(mapView)
    }
    
    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
}

//MARK: - MKMapViewDelegate
extension AddressSearchMapViewController: MKMapViewDelegate {
    
}
