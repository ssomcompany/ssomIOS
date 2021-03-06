//
//  SSFilterView.swift
//  Ssom
//
//  Created by DongSoo Lee on 2015. 12. 2..
//  Copyright © 2015년 SsomCompany. All rights reserved.
//

import UIKit

protocol SSFilterViewDelegate: NSObjectProtocol {
    func applyFilter(_ filterViewModel: SSFilterViewModel?) -> Void;
}

extension UIButton {
    var toggledSelected: Bool {
        get {
            return self.isSelected
        }
        set {
            self.toggleSelected(newValue)
        }
    }

    func toggleSelected(_ selected: Bool) {
        self.isSelected = selected

        if self.isSelected {
            self.backgroundColor = UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        } else {
            self.backgroundColor = UIColor.white
        }
    }
}

class SSFilterView: UIView {
    @IBOutlet var filterMainView: UIView!

    @IBOutlet var btnFilterSsom: UIButton!
    @IBOutlet var btnFilterSsoseyo: UIButton!

    @IBOutlet var filter20beginAgeButton: UIButton!
    @IBOutlet var filter20middleAgeButton: UIButton!
    @IBOutlet var filter20lateAgeButton: UIButton!
    @IBOutlet var filter30overAgeButton: UIButton!

    @IBOutlet var peopleLabel: UILabel!
    @IBOutlet var constPeopleLabelTop: NSLayoutConstraint!

    @IBOutlet var filter1PersonButton: UIButton!
    @IBOutlet var filter2PeopleButton: UIButton!
    @IBOutlet var filter3PeopleButton: UIButton!
    @IBOutlet var filter4PeopleButton: UIButton!

    @IBOutlet var imgViewSsomFilterIcon: UIImageView!

    @IBOutlet var btnClose: UIButton!

    weak var delegate: SSFilterViewDelegate?

    var model: SSFilterViewModel = SSFilterViewModel(ageType: .AgeAll, peopleCount: .All)

    override init(frame: CGRect) {
        super.init(frame: frame)

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)

        self.btnFilterSsom.layer.borderWidth = 0.3
        self.btnFilterSsom.layer.borderColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor

        self.btnFilterSsoseyo.layer.borderWidth = 0.3
        self.btnFilterSsoseyo.layer.borderColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor

        self.btnFilterSsom.addTarget(self, action: #selector(tapFilterOptions(_:)), for: .touchUpInside)
        self.btnFilterSsoseyo.addTarget(self, action: #selector(tapFilterOptions(_:)), for: .touchUpInside)

        self.layoutIfNeeded()
        self.filterMainView.layer.cornerRadius = 25

        self.filter20beginAgeButton.addTarget(self, action: #selector(tapFilterOptions(_:)), for: UIControlEvents.touchUpInside)
        self.filter20middleAgeButton.addTarget(self, action: #selector(tapFilterOptions(_:)), for: UIControlEvents.touchUpInside)
        self.filter20lateAgeButton.addTarget(self, action: #selector(tapFilterOptions(_:)), for: UIControlEvents.touchUpInside)
        self.filter30overAgeButton.addTarget(self, action: #selector(tapFilterOptions(_:)), for: UIControlEvents.touchUpInside)

        self.filter1PersonButton.addTarget(self, action: #selector(tapFilterOptions(_:)), for: UIControlEvents.touchUpInside)
        self.filter2PeopleButton.addTarget(self, action: #selector(tapFilterOptions(_:)), for: UIControlEvents.touchUpInside)
        self.filter3PeopleButton.addTarget(self, action: #selector(tapFilterOptions(_:)), for: UIControlEvents.touchUpInside)
        self.filter4PeopleButton.addTarget(self, action: #selector(tapFilterOptions(_:)), for: UIControlEvents.touchUpInside)
    }

    func configView() {
        if self.model.ssomType == [.SSOM, .SSOSEYO] {
            self.btnFilterSsom.toggledSelected = true
            self.btnFilterSsoseyo.toggledSelected = true
        } else {
            if self.model.ssomType == [.SSOM] {
                self.btnFilterSsom.toggledSelected = true
                self.btnFilterSsoseyo.toggledSelected = false
            } else {
                self.btnFilterSsom.toggledSelected = false
                self.btnFilterSsoseyo.toggledSelected = true
            }
        }

        self.changeSsomFilterIcon()

        if self.model.ageTypes.contains(.AgeAll) {
            self.filter20beginAgeButton.toggledSelected = true
            self.filter20middleAgeButton.toggledSelected = true
            self.filter20lateAgeButton.toggledSelected = true
            self.filter30overAgeButton.toggledSelected = true
        } else {

            self.filter20beginAgeButton.toggledSelected = false
            self.filter20middleAgeButton.toggledSelected = false
            self.filter20lateAgeButton.toggledSelected = false
            self.filter30overAgeButton.toggledSelected = false

            if self.model.ageTypes.contains(.AgeEarly20) {
                self.filter20beginAgeButton.toggledSelected = true
            }
            if self.model.ageTypes.contains(.AgeMiddle20) {
                self.filter20middleAgeButton.toggledSelected = true
            }
            if self.model.ageTypes.contains(.AgeLate20) {
                self.filter20lateAgeButton.toggledSelected = true
            }
            if self.model.ageTypes.contains(.Age30) {
                self.filter30overAgeButton.toggledSelected = true
            }
        }

        if self.model.peopleCountTypes.contains(.All) {
            self.filter1PersonButton.toggledSelected = true
            self.filter2PeopleButton.toggledSelected = true
            self.filter3PeopleButton.toggledSelected = true
            self.filter4PeopleButton.toggledSelected = true
        } else {

            self.filter1PersonButton.toggledSelected = false
            self.filter2PeopleButton.toggledSelected = false
            self.filter3PeopleButton.toggledSelected = false
            self.filter4PeopleButton.toggledSelected = false

            if self.model.peopleCountTypes.contains(.OnePerson) {
                self.filter1PersonButton.toggledSelected = true
            }
            if self.model.peopleCountTypes.contains(.TwoPeople) {
                self.filter2PeopleButton.toggledSelected = true
            }
            if self.model.peopleCountTypes.contains(.ThreePeople) {
                self.filter3PeopleButton.toggledSelected = true
            }
            if self.model.peopleCountTypes.contains(.OverFourPeople) {
                self.filter4PeopleButton.toggledSelected = true
            }
        }

        let translateTrasnform = CGAffineTransform(translationX: UIScreen.main.bounds.width / 2.0 - 20, y: -(UIScreen.main.bounds.height / 4.0 - 20))
        let scaleTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.filterMainView.transform = scaleTransform.concatenating(translateTrasnform)
    }

    func openAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.filterMainView.transform = CGAffineTransform.identity
            self.alpha = 1.0
        }) { (finish) in
            //
        }
    }

    func closeAnimation() {
        let translateTrasnform = CGAffineTransform(translationX: UIScreen.main.bounds.width / 2.0 - 20, y: -(UIScreen.main.bounds.height / 4.0 - 20))
        let scaleTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.filterMainView.transform = scaleTransform.concatenating(translateTrasnform)
            self.alpha = 0.0
        }) { (finish) in
            if let _ = self.superview {
                self.removeFromSuperview()
            }
        }
    }

    func handleTap(_ gesture: UITapGestureRecognizer) {
        if let _ = self.filterMainView.hitTest(gesture.location(in: self.filterMainView), with: nil) {

        } else {
            self.tapCloseButton()
        }
    }

    @IBAction func tapCloseButton() {
        self.closeAnimation()
    }

    func tapFilterOptions(_ sender: UIButton) {
        let filterButton = sender

        if filterButton === self.btnFilterSsom {
            if !self.btnFilterSsoseyo.isSelected && filterButton.isSelected {
                self.makeToast("\"쏨\"과 \"쏴\" 둘 중 하나는 반드시 선택되어야 합니다!!", duration: 2.0, position: .top)
                return
            }
        }
        if filterButton === self.btnFilterSsoseyo {
            if !self.btnFilterSsom.isSelected && filterButton.isSelected {
                self.makeToast("\"쏨\"과 \"쏴\" 둘 중 하나는 반드시 선택되어야 합니다!!", duration: 2.0, position: .top)
                return
            }
        }

        filterButton.toggledSelected = !filterButton.isSelected

        self.changeSsomFilterIcon()
    }

    func changeSsomFilterIcon() {
        if self.btnFilterSsom.isSelected && self.btnFilterSsoseyo.isSelected {
            self.imgViewSsomFilterIcon.image = #imageLiteral(resourceName: "topIconGreenred")
        } else if !self.btnFilterSsom.isSelected && self.btnFilterSsoseyo.isSelected {
            self.imgViewSsomFilterIcon.image = #imageLiteral(resourceName: "topIconRed")
        } else if self.btnFilterSsom.isSelected && !self.btnFilterSsoseyo.isSelected {
            self.imgViewSsomFilterIcon.image = #imageLiteral(resourceName: "topIconGreen")
        }
    }

    @IBAction func tapInitializieFilter(_ sender: AnyObject) {
        self.btnFilterSsom.isSelected = true
        self.btnFilterSsoseyo.isSelected = true

        self.filter20beginAgeButton.isSelected = true
        self.filter20middleAgeButton.isSelected = true
        self.filter20lateAgeButton.isSelected = true
        self.filter30overAgeButton.isSelected = true

        self.filter1PersonButton.isSelected = true
        self.filter2PeopleButton.isSelected = true
        self.filter3PeopleButton.isSelected = true
        self.filter4PeopleButton.isSelected = true

        let filterValue: SSFilterViewModel = SSFilterViewModel(ageType: .AgeAll, peopleCount: .All)

        guard let _ = self.delegate?.applyFilter(filterValue) else {
            NSLog("%@", "This SSFilterView isn't implemented applyFilter function")

            return
        }
    }

    @IBAction func tapApplyFilter(_ sender: AnyObject) {
        var filterValue: SSFilterViewModel = SSFilterViewModel()

        if self.btnFilterSsom.isSelected {
            filterValue.ssomType.append(.SSOM)
        }
        if self.btnFilterSsoseyo.isSelected {
            filterValue.ssomType.append(.SSOSEYO)
        }

        if self.filter20beginAgeButton.isSelected {
            filterValue.ageTypes.append(.AgeEarly20)
        }
        if self.filter20middleAgeButton.isSelected {
            filterValue.ageTypes.append(.AgeMiddle20)
        }
        if self.filter20lateAgeButton.isSelected {
            filterValue.ageTypes.append(.AgeLate20)
        }
        if self.filter30overAgeButton.isSelected {
            filterValue.ageTypes.append(.Age30)
        }

        if filterValue.ageTypes.count == 4 {
            filterValue.ageTypes = [.AgeAll]
        }

        // how many people
        if self.filter1PersonButton.isSelected {
            filterValue.peopleCountTypes.append(.OnePerson)
        }
        if self.filter2PeopleButton.isSelected {
            filterValue.peopleCountTypes.append(.TwoPeople)
        }
        if self.filter3PeopleButton.isSelected {
            filterValue.peopleCountTypes.append(.ThreePeople)
        }
        if self.filter4PeopleButton.isSelected {
            filterValue.peopleCountTypes.append(.OverFourPeople)
        }

        if filterValue.peopleCountTypes.count == 4 {
            filterValue.peopleCountTypes = [.All]
        }

        guard let _ = self.delegate?.applyFilter(filterValue) else {
            NSLog("%@", "This SSFilterView isn't implemented applyFilter function")

            return
        }
    }
}
