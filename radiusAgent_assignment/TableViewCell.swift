//
//  TableViewCell.swift
//  radiusagent
//
//  Created by Kavya Khurana on 30/06/23.
//

import Foundation
import UIKit

protocol TableViewCellDelegate: AnyObject {
    func didTapCell(_ cell: TableViewCell)
}

class TableViewCell: UITableViewCell {
    
    static let identifier = "TableViewCell"
    
    private var icon: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private var selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.alpha = 0.5
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var disabledView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.alpha = 0.4
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var delegate: TableViewCellDelegate?
    override var isSelected: Bool {
        didSet {
            selectedView.isHidden = !isSelected
        }
    }
    
    var isDisabled: Bool = false {
        didSet {
            disabledView.isHidden = !isDisabled
            self.isUserInteractionEnabled = !isDisabled
            self.alpha = isDisabled ? 0.5 : 1
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupViews() {
        contentView.addSubview(selectedView)
        contentView.addSubview(disabledView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(icon)
        addConstraints()
        addTapGestureRecognizer()
    }
    
    private func addConstraints() {
        let constraints = [
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 30),
            icon.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            titleLabel.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
            
            selectedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            disabledView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            disabledView.topAnchor.constraint(equalTo: contentView.topAnchor),
            disabledView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            disabledView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTapCell(self)
    }
    
    public func configure(image: String, title: String) {
        icon.image = UIImage(named: image)
        titleLabel.text = title
        selectedView.isHidden = !isSelected
    }
    
}
