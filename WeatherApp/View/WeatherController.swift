//
//  WeatherController.swift
//  WeatherApp
//
//  Created by Apple on 17/10/22.
//

import Foundation
import UIKit
import CoreLocation


class WeatherControlller : UIViewController{
    
    let gradientLayer = CAGradientLayer()
    var locationManager = CLLocationManager()
    var currentLoc: CLLocation?
    var stackView : UIStackView!
    var latitude : CLLocationDegrees!
    var longitude: CLLocationDegrees!
    let networkManager = NetworkManager()
    var collectionView : UICollectionView!
    var forecastData: [Forecastday] = []
    
    let weatherLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Weather"
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20,weight: .heavy)
        return label
        
    }()
    
    let currentLocation : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 38,weight: .heavy)
        return label
    }()
    
    let date : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14,weight: .regular)
        return label
    }()
    
    let currentTemp : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 60,weight: .thin)
        return label
    }()
    
    let hightLowTemp : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16,weight: .regular)
        return label
        
    }()
    
    let currentWeatherView : UIView = {
        let weatherView = UIView()
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        weatherView.backgroundColor = .clear
        return weatherView
    }()
    
    let currentWeatherImage : UIImageView = {
        let weatherImage = UIImageView()
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.backgroundColor = .clear
        weatherImage.sizeToFit()
        weatherImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        weatherImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return weatherImage
    }()
    
    let currentWeatherLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12,weight: .regular)
        return label
    }()
    
    let nextfewDays : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Weather for next few days"
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12,weight: .regular)
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.spacing = 10
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addArrangedSubview(currentLocation)
        scrollViewContainer.addArrangedSubview(date)
        scrollViewContainer.addArrangedSubview(currentTemp)
        scrollViewContainer.addArrangedSubview(hightLowTemp)
        scrollViewContainer.addArrangedSubview(currentWeatherView)
        currentWeatherView.addSubview(currentWeatherLabel)
        currentWeatherView.addSubview(currentWeatherImage)
        scrollViewContainer.addArrangedSubview(nextfewDays)
        scrollViewContainer.addArrangedSubview(collectionView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewDidAppear(animated)
        view.setNeedsUpdateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionViewInit()
        
        setupViews()
        view.setNeedsUpdateConstraints()
        self.layoutViews()
        self.locationInit()
        
    }
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = self.view.bounds
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    //MARK: - Setup view constraints
    private func layoutViews(){
        let safeArea = self.view.safeAreaLayoutGuide
        
        scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 20).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -20).isActive = true
        scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: 20).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: -20).isActive = true
        
        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        // this is important for scrolling
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        currentWeatherView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        currentWeatherLabel.centerXAnchor.constraint(equalTo: currentWeatherView.centerXAnchor,constant: 0).isActive = true
        currentWeatherLabel.centerYAnchor.constraint(equalTo: currentWeatherView.centerYAnchor).isActive = true
        
        currentWeatherImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
        currentWeatherImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
        currentWeatherImage.centerXAnchor.constraint(equalTo: currentWeatherView.centerXAnchor,constant: -55).isActive = true
        currentWeatherImage.centerYAnchor.constraint(equalTo: currentWeatherView.centerYAnchor).isActive = true        
    }
    
    //MARK: - Collection view Init
    func collectionViewInit(){
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: ForecastCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        view.addSubview(collectionView)
    }
    
    //MARK: - Gradient Layer
    func setGradientBackground() {
        let colorTop =  UIColor(red: 0/255.0, green: 0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 141/255, green: 87/255, blue: 151/255, alpha: 1.0).cgColor
        let colorMiddle = UIColor(red: 20/255, green: 31/255, blue: 78/255, alpha: 1.0).cgColor
        
        gradientLayer.colors = [colorTop,colorMiddle, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    //MARK: - Location Init
    func locationInit(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - API Call for the Weather data for desired city. NOTE : City is Hardcoded
    func loadData(city: String) {
        networkManager.fetchCurrenCitytWeather(city: city) { (weather) in
            DispatchQueue.main.async {
                self.forecastData = weather.forecast?.forecastday ?? []
                self.collectionView.heightAnchor.constraint(equalToConstant: CGFloat(self.forecastData.count * 120)).isActive = true
                self.view.layoutIfNeeded()
                self.collectionView.reloadData()
                self.date.text = self.formateDate(date:weather.location?.localtime ?? "")
                self.currentTemp.text = "\(weather.current?.temp_c ?? 0.00) °C"
                self.hightLowTemp.text = "H: \((weather.forecast?.forecastday?.first)?.day?.maxtemp_c ?? 0.00)°C L: \((weather.forecast?.forecastday?.first)?.day?.mintemp_c ?? 0.00)°C"
                self.currentWeatherImage.loadImageFromURL(url: weather.current?.condition?.icon ?? "")
                self.currentWeatherLabel.text = weather.current?.condition?.text ?? ""
                self.currentWeatherImage.loadImageFromURL(url: "https:\(weather.current?.condition?.icon ?? "")")
                self.currentLocation.text = city
            }
        }
    }
}

extension WeatherControlller: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        let location = locations[0].coordinate
        latitude = location.latitude
        longitude = location.longitude
//        print("Long", longitude.description)
//        print("Lat", latitude.description)
        loadData(city: "Chennai")
    }
}

//MARK: - Collection view Delegates & Data source
extension WeatherControlller: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.reuseIdentifier, for: indexPath) as! ForecastCell
        cell.configure(with: forecastData[indexPath.row])
        cell.weekdaylabel.text = self.formateDay(date: forecastData[indexPath.row].hour?.first?.time ?? "")
        return cell
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            self.createFeaturedSection()
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
    
    func createFeaturedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top:5, leading: 5, bottom: 0, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(110))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        // layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        return layoutSection
    }
}
    
