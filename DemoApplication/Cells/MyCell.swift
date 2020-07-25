//
//  SimpleTableViewCell.swift
//  SimpleTableViewController
//
//  Created by Suyeol Jeon on 6/24/16.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class MyCell: UITableViewCell {

    // MARK: Constants

    struct Font {
        static let messageLabel = UIFont.systemFont(ofSize: 14)
    }


    // MARK: Properties
    private var disposeBag: DisposeBag?
    let containerView:UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.clipsToBounds = true // this will make sure its children do not go out of the boundary
      return view
    }()
    let imgView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.layer.cornerRadius = img.frame.size.height / 2
        img.layer.borderColor = UIColor.orange.cgColor
        img.layer.borderWidth = 3.0
        img.clipsToBounds = true
       return img
    }()
    let titleLbl:UILabel = {
      let label = UILabel()
      label.font = UIFont.boldSystemFont(ofSize: 17)
      label.textColor =  UIColor.black
      label.clipsToBounds = true
      label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    let descriptionLbl:UILabel = {
      let label = UILabel()
      label.font = UIFont.boldSystemFont(ofSize: 14)
      label.textColor =  UIColor.black
      label.numberOfLines = 0
      label.lineBreakMode = .byWordWrapping
      label.clipsToBounds = true
      label.sizeToFit()
      label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    // MARK: Initializing

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       containerView.addSubview(imgView)
       containerView.addSubview(titleLbl)
       containerView.addSubview(descriptionLbl)
       self.contentView.addSubview(containerView)
       setConstraints()

    }
    func setConstraints(){
        self.contentView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute:.bottom, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: 0))

        let imageXConstraint = NSLayoutConstraint(item: imgView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: 10)
        containerView.addConstraints([imageXConstraint])
        let imageTopConstraint = NSLayoutConstraint(item: imgView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 20)
        containerView.addConstraints([imageTopConstraint])
        let imageBottomConstraint = NSLayoutConstraint(item: imgView, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: -20)
        containerView.addConstraints([imageBottomConstraint])
        let imageWidthConstraint = NSLayoutConstraint(item: imgView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        containerView.addConstraints([imageWidthConstraint])
        let imageHeigthConstraint = NSLayoutConstraint(item: imgView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        containerView.addConstraints([imageHeigthConstraint])

        titleLbl.anchor(top: containerView.topAnchor, left: imgView.rightAnchor, bottom: descriptionLbl.topAnchor, right: containerView.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width - imgView.frame.width, height: 0, enableInsets: false)
        descriptionLbl.anchor(top: titleLbl.bottomAnchor, left: imgView.rightAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width - imgView.frame.width, height: 0, enableInsets: false)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: Configuring

    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = nil
    }

    func configure(viewModel: MyCellViewModel) {
        self.disposeBag = DisposeBag()
        guard let disposeBag = self.disposeBag else { return }
       viewModel.title
        .asObservable()
        .map { $0 }
        .bind(to:self.titleLbl.rx.text)
        .disposed(by:disposeBag)

        viewModel.description
        .asObservable()
        .map { $0 }
        .bind(to:self.descriptionLbl.rx.text)
        .disposed(by:disposeBag)
        viewModel.imageUrl.asObservable().subscribe(onNext: { value in
                   print("Set \(String(describing: value))")
            self.imgView.image = nil
            if value.count > 0{
                let url = URL(string: value)!
                print("imgUrl: \(url)")
                self.imgView.kf.setImage(with: url)
            }
            else{
                self.imgView.image = UIImage(named: "placeholder")
            }

        }).disposed(by: disposeBag)


    }



    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        descriptionLbl.sizeToFit()
    }

}
extension UIView {

 func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
 var topInset = CGFloat(0)
 var bottomInset = CGFloat(0)

 if #available(iOS 11, *), enableInsets {
 let insets = self.safeAreaInsets
 topInset = insets.top
 bottomInset = insets.bottom

    print("Top: /(topInset)")

    print("bottom: /(bottomInset)")
 }

 translatesAutoresizingMaskIntoConstraints = false

 if let top = top {
 self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
 }
 if let left = left {
 self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
 }
 if let right = right {
 rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
 }
 if let bottom = bottom {
 bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
 }
 if height != 0 {
 heightAnchor.constraint(equalToConstant: height).isActive = true
 }
 if width != 0 {
 widthAnchor.constraint(equalToConstant: width).isActive = true
 }

 }

}
