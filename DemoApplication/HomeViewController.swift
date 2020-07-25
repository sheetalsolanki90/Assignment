//
//  HomeViewController.swift
//  DemoApplication
//
//  Created by Sheetal on 20/07/20.
//  Copyright © 2020 Sheetal.com. All rights reserved.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift

class HomeViewController: UIViewController {
    var tableView = UITableView()
    private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MyCellViewModel>>(configureCell: {_, tableView, indexPath, viewModel in
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! MyCell
        cell.configure(viewModel: viewModel)
        return cell
        })

    public var countryPropertyList = PublishSubject<[CountryProperties]>()
    var countryViewModel = CountryViewModel()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        countryViewModel.requestData()
        countryViewModel.countryRowList.observeOn(MainScheduler.instance).bind(to: countryPropertyList).disposed(by: disposeBag)
        setupBinding()
        // Do any additional setup after loading the view.
    }
    func setUpTableView(){

        tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = UIColor.white
        self.view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 40))
        self.view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute:.bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
        tableView.tableFooterView = UIView()
    }

    private func setupBinding(){
        tableView.register(MyCell.self, forCellReuseIdentifier: "MyCell")

        tableView
        .rx.setDelegate(self)
        .disposed(by: disposeBag)

        self.title = "Help me!"
       countryPropertyList.bind(to: tableView.rx.items(cellIdentifier: "MyCell", cellType: MyCell.self)) {  (row,countryInfo,cell) in
            let mycellModel = MyCellViewModel.init(model: countryInfo)
            cell.configure(viewModel: mycellModel)
           }.disposed(by: disposeBag)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension

    }

}
//extension HomeViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return countryPropertyList.map{ $0.count}
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    }
//
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section name"
//    }
//}
