/*
 * Copyright 2022 TikTok Pte. Ltd.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit
import PhotosUI
import TikTokOpenShareSDK

class SelectMediaViewController: UIViewController {
    let mainColor = UIColor(red: 254/255.0, green: 44/255.0, blue: 85/255.0, alpha: 1).cgColor
    let customClientKey: String?
    
    private var mediaType: TikTokShareMediaType?

    private let imgView: UIImageView = {
        let img = UIImage(named: "PicThumbUp", in: .main, compatibleWith: nil)
        var imageView = UIImageView(image: img)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var titleView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select your media to share"
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.textColor = .textColor
        return label
    }()

    private var subtitleView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You may select multiple images or videos to upload to TikTok."
        label.font = .systemFont(ofSize: 13.0)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var imageBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select Image", for: .normal)
        button.setTitleColor(UIColor(cgColor: mainColor), for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = mainColor
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.bordered()
            config.imagePadding = 9.3
            config.baseBackgroundColor = .clear
            config.baseForegroundColor = UIColor(cgColor: mainColor)
            config.image = UIImage(named: "IcoImage", in: .main, compatibleWith: nil)
            button.configuration = config
        } else {
            button.backgroundColor = .clear
            button.setImage(UIImage(named: "IcoImage", in: .main, compatibleWith: nil), for: .normal)
            button.imageView?.contentMode = .center
            button.imageEdgeInsets.right = 9.3
        }

        return button
    }()

    private lazy var videoBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.imagePadding = 9.3
            config.baseBackgroundColor = UIColor(cgColor: mainColor)
            config.baseForegroundColor = .white
            config.image = UIImage(named: "IcoVideoFill", in: .main, compatibleWith: nil)
            button.configuration = config
        } else {
            button.imageEdgeInsets.right = 9.3
            button.backgroundColor = UIColor(cgColor: mainColor)
            button.setImage(UIImage(named: "IcoVideoFill", in: .main, compatibleWith: nil), for: .normal)
            button.imageView?.contentMode = .center
        }
        button.setTitle("Select Video", for: .normal)
        return button
    }()

    private func setUpLayout() {

        view.addSubview(imgView)
        view.addSubview(titleView)
        view.addSubview(subtitleView)
        view.addSubview(videoBtn)
        view.addSubview(imageBtn)

        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 128.0),
            imgView.heightAnchor.constraint(equalToConstant: 160.0),
            imgView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imgView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 48.0),
            titleView.heightAnchor.constraint(equalToConstant: 24.0),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8.0),
            subtitleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            subtitleView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor)
        ])

        NSLayoutConstraint.activate([
            videoBtn.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            videoBtn.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            videoBtn.bottomAnchor.constraint(equalTo: imageBtn.topAnchor, constant: -16.0),
            videoBtn.heightAnchor.constraint(equalToConstant: 48.0)
        ])

        NSLayoutConstraint.activate([
            imageBtn.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            imageBtn.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            imageBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -3.5),
            imageBtn.heightAnchor.constraint(equalToConstant: 48.0)
        ])
    }

    init(_ customClientKey: String? = nil) {
        self.customClientKey = customClientKey
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        title = "Select Media"
        view.backgroundColor = .backgroundColor
        videoBtn.addTarget(self, action: #selector(tapSelectVideoBtn), for: .touchUpInside)
        imageBtn.addTarget(self, action: #selector(tapSelectImageBtn), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    @objc
    private func tapSelectVideoBtn() {
        
        mediaType = .video
        
        var config = PHPickerConfiguration.init(photoLibrary: .shared())
        config.selectionLimit = 3
        config.filter = .videos
        
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = self
        
        present(controller, animated: true)
    }

    @objc
    private func tapSelectImageBtn() {
        
        mediaType = .image
        
        var config = PHPickerConfiguration.init(photoLibrary: .shared())
        config.selectionLimit = 3
        config.filter = .images
        
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = self
        
        present(controller, animated: true)
    }
}

extension SelectMediaViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        guard !results.isEmpty else {
            picker.dismiss(animated: true)
            return
        }
        
        var assets: [String] = []
        
        for result in results {
            guard let identifier = result.assetIdentifier else {
                continue
            }
            assets.append(identifier)
        }
    
        picker.dismiss(animated: true) {
            
            let viewController = MetaInfoViewController(withMediaType: self.mediaType!, assets: assets, customClientKey: self.customClientKey)
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
        
    }

}
