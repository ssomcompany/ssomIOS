//
//  SSWriteViewController.swift
//  Ssom
//
//  Created by DongSoo Lee on 2015. 11. 30..
//  Copyright © 2015년 SsomCompany. All rights reserved.
//

import UIKit

class SSWriteViewController: SSDetailViewController, UITextViewDelegate
, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var barButtonItems: SSNavigationBarItems!

    @IBOutlet var profileView: UIView!
    @IBOutlet var constProfileViewTopToSuper: NSLayoutConstraint!
    @IBOutlet var imgDefaultProfile: UIImageView!
    @IBOutlet var imgPhotoGradation: UIImageView!
    @IBOutlet var imgProfile: UIImageView!

    let minWidthPayButton:CGFloat = 76
    let minHeightPayButton:CGFloat = 68
    let maxWidthPayButton:CGFloat = 95
    let maxHeightPayButton:CGFloat = 85

    @IBOutlet var textView: UITextView!
    @IBOutlet var textGuideLabel: UILabel!

    @IBOutlet var lbAge: UILabel!
    @IBOutlet var lbAgeTrailingText: UILabel!

    @IBOutlet var ageButton1: UIButton!
    @IBOutlet var ageButton2: UIButton!
    @IBOutlet var ageButton3: UIButton!
    @IBOutlet var ageButton4: UIButton!

    @IBOutlet var lbPeopleCount: UILabel!
    @IBOutlet var lbPeopleCountTrailingText: UILabel!

    @IBOutlet var peopleButton1: UIButton!
    @IBOutlet var peopleButton2: UIButton!
    @IBOutlet var peopleButton3: UIButton!
    @IBOutlet var peopleButton4: UIButton!

    @IBOutlet var btnIPay: UIButton!
    @IBOutlet var constBtnIPayWidthRatio: NSLayoutConstraint!
    @IBOutlet var constBtnIPayAspectRatio: NSLayoutConstraint!
    @IBOutlet var constBtnIPayMinWidthRatio: NSLayoutConstraint!
    @IBOutlet var constBtnIPayMinAspectRatio: NSLayoutConstraint!

//    @IBOutlet var constWidthIPayButton: NSLayoutConstraint!
//    @IBOutlet var constHeightIPayButton: NSLayoutConstraint!

    @IBOutlet var btnYouPay: UIButton!
    @IBOutlet var constBtnYouPayWidthRatio: NSLayoutConstraint!
    @IBOutlet var constBtnYouPayAspectRatio: NSLayoutConstraint!
    @IBOutlet var constBtnYouPayMinWidthRatio: NSLayoutConstraint!
    @IBOutlet var constBtnYouPayMinAspectRatio: NSLayoutConstraint!

//    @IBOutlet var constWidthYouPayButton: NSLayoutConstraint!
//    @IBOutlet var constHeightYouPayButton: NSLayoutConstraint!

    @IBOutlet var btnRegister: UIButton!

    var isIPay:Bool = true

    var writeViewModel: SSWriteViewModel

    var pickedImageExtension: String!
    var pickedImageName: String!
    var pickedImageData: NSData!

    init() {
        self.writeViewModel = SSWriteViewModel()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.writeViewModel = SSWriteViewModel()

        super.init(coder: aDecoder)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }

    override func initView() {
        self.barButtonItems = SSNavigationBarItems()

        self.barButtonItems.btnBack.addTarget(self, action: #selector(tapBack), forControlEvents: UIControlEvents.TouchUpInside)
        self.barButtonItems.lbBackButtonTitle.text = "쏨 등록하기"

        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(customView: barButtonItems.backBarButtonView), animated: true)

        self.textView.delegate = self;

        if UIScreen.mainScreen().bounds.width == 320 {
            self.textGuideLabel.font = UIFont.systemFontOfSize(13)
        }

        self.registerForKeyboardNotifications()
    }

    func registerForKeyboardNotifications() -> Void {

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }

    func tapBack() {
        if self.pickedImageData != nil || self.writeViewModel.content.characters.count != 0 {
            SSAlertController.alertTwoButton(title: "알림", message: "쏨 등록이 완료되지 않았어요.\n작성했던 내용을 삭제 하시겠어요?", vc: self, button1Title: "삭제하기", button1Completion: { (action) in
                self.navigationController?.popViewControllerAnimated(true)
            }, button2Completion: { (action) in
                //
            })
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    @IBAction func tapAgeButton1(sender: AnyObject) {
        self.textView.resignFirstResponder();

        self.ageButton1.selected = true;
        self.ageButton2.selected = false;
        self.ageButton3.selected = false;
        self.ageButton4.selected = false;

        self.ageButton1.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        self.ageButton2.backgroundColor = UIColor.whiteColor()
        self.ageButton3.backgroundColor = UIColor.whiteColor()
        self.ageButton4.backgroundColor = UIColor.whiteColor()

        self.lbAge.text = (self.ageButton1.titleLabel!.text)!+"반"

        self.writeViewModel.ageType = .AgeEarly20
    }

    @IBAction func tapAgeButton2(sender: AnyObject) {
        self.textView.resignFirstResponder();

        self.ageButton1.selected = false;
        self.ageButton2.selected = true;
        self.ageButton3.selected = false;
        self.ageButton4.selected = false;

        self.ageButton1.backgroundColor = UIColor.whiteColor()
        self.ageButton2.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        self.ageButton3.backgroundColor = UIColor.whiteColor()
        self.ageButton4.backgroundColor = UIColor.whiteColor()

        self.lbAge.text = (self.ageButton2.titleLabel!.text)!+"반"

        self.writeViewModel.ageType = .AgeMiddle20
    }

    @IBAction func tapAgeButton3(sender: AnyObject) {
        self.textView.resignFirstResponder();

        self.ageButton1.selected = false;
        self.ageButton2.selected = false;
        self.ageButton3.selected = true;
        self.ageButton4.selected = false;

        self.ageButton1.backgroundColor = UIColor.whiteColor()
        self.ageButton2.backgroundColor = UIColor.whiteColor()
        self.ageButton3.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        self.ageButton4.backgroundColor = UIColor.whiteColor()

        self.lbAge.text = (self.ageButton3.titleLabel!.text)!+"반"

        self.writeViewModel.ageType = .AgeLate20
    }

    @IBAction func tapAgeButton4(sender: AnyObject) {
        self.textView.resignFirstResponder();
        
        self.ageButton1.selected = false;
        self.ageButton2.selected = false;
        self.ageButton3.selected = false;
        self.ageButton4.selected = true;

        self.ageButton1.backgroundColor = UIColor.whiteColor()
        self.ageButton2.backgroundColor = UIColor.whiteColor()
        self.ageButton3.backgroundColor = UIColor.whiteColor()
        self.ageButton4.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)

        self.lbAge.text = (self.ageButton4.titleLabel!.text)!

        self.writeViewModel.ageType = .Age30
    }

    @IBAction func tapPeopleButton1(sender: AnyObject) {
        self.textView.resignFirstResponder();

        self.peopleButton1.selected = true;
        self.peopleButton2.selected = false;
        self.peopleButton3.selected = false;
        self.peopleButton4.selected = false;

        self.peopleButton1.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        self.peopleButton2.backgroundColor = UIColor.whiteColor()
        self.peopleButton3.backgroundColor = UIColor.whiteColor()
        self.peopleButton4.backgroundColor = UIColor.whiteColor()

        self.lbPeopleCount.text = "1"

        self.writeViewModel.peopleCountType = .OnePerson
    }

    @IBAction func tapPeopleButton2(sender: AnyObject) {
        self.textView.resignFirstResponder();

        self.peopleButton1.selected = false;
        self.peopleButton2.selected = true;
        self.peopleButton3.selected = false;
        self.peopleButton4.selected = false;

        self.peopleButton1.backgroundColor = UIColor.whiteColor()
        self.peopleButton2.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        self.peopleButton3.backgroundColor = UIColor.whiteColor()
        self.peopleButton4.backgroundColor = UIColor.whiteColor()

        self.lbPeopleCount.text = "2"

        self.writeViewModel.peopleCountType = .TwoPeople
    }

    @IBAction func tapPeopleButton3(sender: AnyObject) {
        self.textView.resignFirstResponder();

        self.peopleButton1.selected = false;
        self.peopleButton2.selected = false;
        self.peopleButton3.selected = true;
        self.peopleButton4.selected = false;

        self.peopleButton1.backgroundColor = UIColor.whiteColor()
        self.peopleButton2.backgroundColor = UIColor.whiteColor()
        self.peopleButton3.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        self.peopleButton4.backgroundColor = UIColor.whiteColor()

        self.lbPeopleCount.text = "3"

        self.writeViewModel.peopleCountType = .ThreePeople
    }

    @IBAction func tapPeopleButton4(sender: AnyObject) {
        self.textView.resignFirstResponder();

        self.peopleButton1.selected = false;
        self.peopleButton2.selected = false;
        self.peopleButton3.selected = false;
        self.peopleButton4.selected = true;

        self.peopleButton1.backgroundColor = UIColor.whiteColor()
        self.peopleButton2.backgroundColor = UIColor.whiteColor()
        self.peopleButton3.backgroundColor = UIColor.whiteColor()
        self.peopleButton4.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)

        self.lbPeopleCount.text = "4+"

        self.writeViewModel.peopleCountType = .OverFourPeople
    }

    func switchTheme(isIPay:Bool) {
        self.isIPay = isIPay

        if self.isIPay {

            self.btnIPay.selected = true
            self.btnYouPay.selected = false
            self.btnRegister.setBackgroundImage(UIImage(named: "acceptButtonGreen.png"), forState: .Normal)

            if #available(iOS 8.2, *) {
                self.btnIPay.titleLabel?.font = UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)
                self.btnYouPay.titleLabel?.font = UIFont.systemFontOfSize(13, weight: UIFontWeightMedium)
            } else {
                // Fallback on earlier versions
                if let font = UIFont.init(name: "HelveticaNeue-Medium", size: 18) {
                    self.btnIPay.titleLabel?.font = font
                }
                if let font = UIFont.init(name: "HelveticaNeue-Medium", size: 13) {
                    self.btnYouPay.titleLabel?.font = font
                }
            }

            self.lbAge.textColor = UIColor(red: 0.0, green: 180.0/255.0, blue: 143.0/255.0, alpha: 1.0)
            self.lbPeopleCount.textColor = UIColor(red: 0.0, green: 180.0/255.0, blue: 143.0/255.0, alpha: 1.0)

            self.constBtnIPayWidthRatio.active = true
            self.constBtnIPayAspectRatio.active = true

            self.constBtnIPayMinWidthRatio.active = false
            self.constBtnIPayMinAspectRatio.active = false

            self.constBtnYouPayWidthRatio.active = true
            self.constBtnYouPayAspectRatio.active = true

            self.constBtnYouPayMinWidthRatio.active = false
            self.constBtnYouPayMinAspectRatio.active = false
        } else {

            self.btnIPay.selected = false
            self.btnYouPay.selected = true
            self.btnRegister.setBackgroundImage(UIImage(named: "acceptButtonRed.png"), forState: .Normal)

            if #available(iOS 8.2, *) {
                self.btnIPay.titleLabel?.font = UIFont.systemFontOfSize(13, weight: UIFontWeightMedium)
                self.btnYouPay.titleLabel?.font = UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)
            } else {
                // Fallback on earlier versions
                if let font = UIFont.init(name: "HelveticaNeue-Medium", size: 13) {
                    self.btnIPay.titleLabel?.font = font
                }
                if let font = UIFont.init(name: "HelveticaNeue-Medium", size: 18) {
                    self.btnYouPay.titleLabel?.font = font
                }
            }

            self.lbAge.textColor = UIColor(red: 237.0, green: 52.0/255.0, blue: 75.0/255.0, alpha: 1.0)
            self.lbPeopleCount.textColor = UIColor(red: 237.0, green: 52.0/255.0, blue: 75.0/255.0, alpha: 1.0)

            self.constBtnIPayWidthRatio.active = false
            self.constBtnIPayAspectRatio.active = false

            self.constBtnIPayMinWidthRatio.active = true
            self.constBtnIPayMinAspectRatio.active = true

            self.constBtnYouPayWidthRatio.active = false
            self.constBtnYouPayAspectRatio.active = false

            self.constBtnYouPayMinWidthRatio.active = true
            self.constBtnYouPayMinAspectRatio.active = true
        }

        self.btnIPay.layoutIfNeeded()
        self.btnYouPay.layoutIfNeeded()
        self.profileView.layoutIfNeeded()
    }

    @IBAction func tapIPayButton(sender: AnyObject) {
        self.writeViewModel.ssomType = .SSOM
        self.switchTheme(true)
    }

    @IBAction func tapYouPayButton(sender: AnyObject) {
        self.writeViewModel.ssomType = .SSOSEYO
        self.switchTheme(false)
    }

    @IBAction func tapCameraButton(sender: AnyObject) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self;
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.allowsEditing = true
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func tapRegisterButton(sender: AnyObject) {
        if let token: String = SSNetworkContext.sharedInstance.getSharedAttribute("token") as? String {
            let userId: String = SSNetworkContext.sharedInstance.getSharedAttribute("userId") as! String
            self.writeViewModel.userId = userId
            self.writeViewModel.content = self.textView.text

            print("SSWrite is : \(self.writeViewModel)")

            if self.pickedImageData == nil {
                SSAlertController.alertConfirm(title: "Error", message: "사진 등록은 필수입니다!", vc: self, completion: nil)
            } else {
                SSNetworkAPIClient.postFile(token, fileExt: self.pickedImageExtension, fileName: self.pickedImageName, fileData: self.pickedImageData, completion: { (photoURLPath, error) in
                    if error != nil {
                        print(error?.localizedDescription)

                        SSAlertController.alertConfirm(title: "Error", message: (error?.localizedDescription)!, vc: self, completion: nil)
                    } else {
                        self.writeViewModel.profilePhotoUrl = NSURL(string: photoURLPath!)
                        SSNetworkAPIClient.postPost(token, model: self.writeViewModel, completion: { [unowned self] (error) in
                            if error != nil {
                                print(error?.localizedDescription)

                                SSAlertController.alertConfirm(title: "Error", message: (error?.localizedDescription)!, vc: self, completion: { (action) in
//                                    self.navigationController!.popViewControllerAnimated(true)
                                })
                            } else {
                                self.navigationController!.popViewControllerAnimated(true)
                            }
                        })
                    }
                })
            }
        } else {
            self.openSignIn(nil)
        }
    }

    func openSignIn(completion: ((finish:Bool) -> Void)?) {
        SSAccountManager.sharedInstance.openSignIn(self, completion: nil)
    }

    @IBAction func tapCloseButton(sender: AnyObject) {
        self.tapBack()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if touch.view !== self.textView {
                self.textView.resignFirstResponder()
            }
        }
    }

// MARK: - UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        self.textGuideLabel.hidden = true;
    }

    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.characters.count == 0 {
            self.textGuideLabel.hidden = false;
        }
    }


// MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.imgDefaultProfile.hidden = true
        self.imgPhotoGradation.hidden = true    

        self.imgProfile.contentMode = .ScaleAspectFill
        self.imgProfile.clipsToBounds = true
        self.imgProfile.image = image
        self.imgProfile.hidden = false

        let pickedImageURL: NSURL = editingInfo![UIImagePickerControllerReferenceURL] as! NSURL
        let pickedImageURLQueryParams: Array = pickedImageURL.query!.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "=&"))
        let pickedImage: UIImage = editingInfo![UIImagePickerControllerOriginalImage] as! UIImage
        var isExt: Bool = false;
        for queryParam: String in pickedImageURLQueryParams {
            if queryParam == "ext" {
                isExt = true
                continue
            }
            if isExt {
                switch queryParam {
                case "PNG":
                    self.pickedImageExtension = "png"
                    self.pickedImageData = UIImagePNGRepresentation(pickedImage)
                case "JPG", "JPEG":
                    self.pickedImageExtension = "jpeg"
                    self.pickedImageData = UIImageJPEGRepresentation(pickedImage, 1.0)
                default:
                    print("unable to upload!!")
                    break
                }

                break
            }
        }
        self.pickedImageName = pickedImageURL.lastPathComponent

        picker.dismissViewControllerAnimated(true, completion: nil)

        self.btnRegister.enabled = true
    }

// MARK: - Keyboard show & hide event
    func keyboardWillShow(notification: NSNotification) -> Void {
        if let info = notification.userInfo {
            if let keyboardFrame: CGRect = info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue() {

                self.constProfileViewTopToSuper.constant = -self.profileView.bounds.size.height
            }
        }
    }

    func keyboardWillHide(notification: NSNotification) -> Void {
        self.constProfileViewTopToSuper.constant = 0
    }
}
