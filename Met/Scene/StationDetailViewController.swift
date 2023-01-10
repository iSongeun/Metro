//
//  StationDetailViewController.swift
//  Met
//
//  Created by 이송은 on 2022/12/12.
//

import Alamofire
import SnapKit
import UIKit

final class StationDetailViewController : UIViewController {
    private let station : Station
    private var realtimeArrivalList : [StationArrivalDataResponseModel.RealTimeArrival] = []
    
    private lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        return refreshControl
    }()
    
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: view.frame.width - 32 , height: 100)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(StationDetailCollectionViewCell.self, forCellWithReuseIdentifier: "StationDetailCollectionViewCell")
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        return collectionView
        
    }()
    
    init(station: Station) {
        self.station = station
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = station.stationName
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{$0.edges.equalToSuperview()}
        fetchData()
    }
    
    
    @objc private func fetchData(){
        //        refreshControl.endRefreshing()
        let stationName = station.stationName
        let urlString = "http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/\(stationName.replacingOccurrences(of: "역", with: ""))"
        AF
            .request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of:StationArrivalDataResponseModel.self) {response in
                guard case .success(let data) = response.result else { return }
                self.refreshControl.endRefreshing()
                
                self.realtimeArrivalList = data.realtimeArrivalList
                self.collectionView.reloadData()

            }
            .resume()

    }
    
    @objc func timerCallBack(){
        //1초마다 시간 갱신
    }
    //filter로 같은 역 이름 바꾸기
}

extension StationDetailViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realtimeArrivalList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StationDetailCollectionViewCell", for: indexPath) as? StationDetailCollectionViewCell
        
        let realTimeArrival = realtimeArrivalList[indexPath.row]
        cell?.setup(with: realTimeArrival)
        return cell ?? UICollectionViewCell()
    }
    
    
}
