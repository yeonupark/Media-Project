//
//  LocationViewController.swift
//  Media Project
//
//  Created by 마르 on 2023/08/23.
//

import UIKit
import CoreLocation
import MapKit
import SnapKit

class LocationViewController: UIViewController {

    let locationManager = CLLocationManager()
    let mapView = MKMapView()
    let myLocationButton = UIButton()
    let theaterButton = UIButton()
    
    var cgvCoord: [MKPointAnnotation] = []
    var lotteCoord: [MKPointAnnotation] = []
    var megaCoord: [MKPointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(30)
        }

        theaterButton.setImage(UIImage(systemName: "popcorn.circle"), for: .normal)
        theaterButton.addTarget(self, action: #selector(theatherButtonClicked), for: .touchUpInside)
        view.addSubview(theaterButton)
        theaterButton.snp.makeConstraints { make in
            make.top.leading.equalTo(mapView).inset(20)
            make.size.equalTo(50)
        }
        
        myLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        myLocationButton.addTarget(self, action: #selector(checkDeviceLocationAuthorization), for: .touchUpInside)
        view.addSubview(myLocationButton)
        myLocationButton.snp.makeConstraints { make in
            make.leading.equalTo(mapView).inset(20)
            make.top.equalTo(theaterButton.snp.bottom)
            make.size.equalTo(50)
        }
        
        setTheaterList()
        checkDeviceLocationAuthorization()
        setRegionAndAnnotation(center: CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270))
    }
    
    @objc func theatherButtonClicked() {
        showTheaterTypeSheet()
    }
    
    func showTheaterTypeSheet() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cgv = UIAlertAction(title: "CGV", style: .default) { _ in
            self.setAnnotation(type: 0)
        }
        let lotte = UIAlertAction(title: "롯데시네마", style: .default) { _ in
            self.setAnnotation(type: 1)
        }
        let megabox = UIAlertAction(title: "메가박스", style: .default) { _ in
            self.setAnnotation(type: 2)
        }
        
        alert.addAction(cgv)
        alert.addAction(lotte)
        alert.addAction(megabox)
        
        present(alert, animated: true)
    }
    
    func setTheaterList() {
        let theaters = TheaterList().mapAnnotations
        for theater in theaters {
            
            let annotation = MKPointAnnotation()
            annotation.title = theater.location
            annotation.coordinate = CLLocationCoordinate2D(latitude: theater.latitude, longitude: theater.longitude)
            
            let type = theater.type
            switch type {
            case "CGV" : cgvCoord.append(annotation)
            case "롯데시네마" : lotteCoord.append(annotation)
            case "메가박스": megaCoord.append(annotation)
            default: print("에러")
            }
        }
    }
    
    func setAnnotation(type: Int) {
        
        let allCoord = [cgvCoord, lotteCoord, megaCoord]
        
//        for coordList in allCoord {
//            mapView.removeAnnotations(coordList)
//        }
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.addAnnotations(allCoord[type])
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        
        let center = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        let allCoord = [cgvCoord, lotteCoord, megaCoord]
        for coordList in allCoord {
            mapView.addAnnotations(coordList)
        }
    }
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)

        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
    
    @objc func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                
                let authorization: CLAuthorizationStatus
                
                if #available(iOS 14.0, *) {
                    authorization = self.locationManager.authorizationStatus
                } else {
                    authorization = CLLocationManager.authorizationStatus()
                }
                
                print(authorization)
                
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
                
            } else {
                print("위치 서비스 꺼져있어서 위치 권한 요청이 불가합니다.")
            }
        }
        
    }
    
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("notDetermined")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
            showRequestLocationServiceAlert()
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            locationManager.startUpdatingLocation()
        case .authorized:
            print("authorized")
        @unknown default:
            print("default")
        }
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("위치: ",locations)
        
        if let coordinate = locations.last?.coordinate {
            print(coordinate)
            setRegionAndAnnotation(center: coordinate)
            //showTheaterTypeSheet()
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치를 가져오는데 실패함")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkDeviceLocationAuthorization()
    }
}

extension LocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
    }
}
