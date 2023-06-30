//
//  ViewController.swift
//  radiusAgent_assignment
//
//  Created by Kavya Khurana on 30/06/23.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var presenter: PresenterProtocol?
    var excluded: [(String, String)] = []
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVIPER()
        setupTableView()
        subscribeObservables()
        presenter?.viewLoaded()
    }
    
    func setupVIPER() {
        let router = Router()
        let interactor = Interactor(router: router)
        presenter = Presenter(interactor: interactor)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(TableViewHeader.self, forHeaderFooterViewReuseIdentifier: TableViewHeader.identitifer)
    }
    
    func subscribeObservables() {
        presenter?.refreshSubj.subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.getNumberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfRows(for: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell,
              let facilityOptions = presenter?.getCellData(for: indexPath.section) else { return UITableViewCell() }
        
        cell.configure(image: facilityOptions[indexPath.row].icon, title:  facilityOptions[indexPath.row].name)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeader.identitifer) as? TableViewHeader else { return UITableViewHeaderFooterView() }
        headerView.titleLabel.text = presenter?.getSectionTitle(for: section)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}

extension ViewController: TableViewCellDelegate {
    func didTapCell(_ cell: TableViewCell) {
        guard let tappedIndexPath = tableView.indexPath(for: cell) else {
            return
        }

        let tappedSection = tappedIndexPath.section

        for row in 0..<tableView.numberOfRows(inSection: tappedSection) {
            let indexPath = IndexPath(row: row, section: tappedSection)
            if let cell = tableView.cellForRow(at: indexPath) as? TableViewCell {
                cell.isSelected = (indexPath == tappedIndexPath)
            }
        }

        resetExcludedCells(excluded: excluded)

        guard let exclusions = presenter?.getExcludedFacilityAndOption(selectedFacilityID: presenter?.getFacilityID(for: tappedIndexPath.section) ?? "", selectedOptionID: presenter?.getOptionID(for: tappedIndexPath.section, row: tappedIndexPath.row) ?? "") else { return }
        excluded = exclusions

        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                if let cell = tableView.cellForRow(at: indexPath) as? TableViewCell,
                   let facilityID = presenter?.getFacilityID(for: indexPath.section),
                   let optionID = presenter?.getOptionID(for: indexPath.section, row: indexPath.row),
                   exclusions.contains(where: { $0.0 == facilityID && $0.1 == optionID }) {
                    cell.isDisabled = true
                    cell.isSelected = false
                }
            }
        }

    }

    func resetExcludedCells(excluded: [(String, String)]) {
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)

                if let cell = tableView.cellForRow(at: indexPath) as? TableViewCell,
                   let facilityID = presenter?.getFacilityID(for: indexPath.section),
                   let optionID = presenter?.getOptionID(for: indexPath.section, row: indexPath.row) {

                    if excluded.contains(where: { $0.0 == facilityID && $0.1 == optionID }) {
                        cell.isSelected = false
                        cell.isDisabled = true
                    } else {
                        cell.isDisabled = false
                    }
                }
            }
        }
    }
}
