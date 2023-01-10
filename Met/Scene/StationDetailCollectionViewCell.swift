//
//  StationDetailCollectionViewCell.swift
//  Met
//
//  Created by 이송은 on 2022/12/12.
//

import SnapKit
import UIKit

final class StationDetailCollectionViewCell : UICollectionViewCell {
    private var lineLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private var remainTimeLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    func setup(with realTimeArraival : StationArrivalDataResponseModel.RealTimeArrival){
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10
        
        backgroundColor = .systemBackground
        
        [lineLabel , remainTimeLabel].forEach{ addSubview($0) }
        lineLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(16)
        }
        remainTimeLabel.snp.makeConstraints{
            $0.leading.equalTo(lineLabel)
            $0.top.equalTo(lineLabel.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        lineLabel.text = realTimeArraival.line
        remainTimeLabel.text = realTimeArraival.remainTime
    }
}
