//
//  ZGADViewController.swift
//  AdvertisingPage
//
//  Created by Magic on 2018/2/24.
//  Copyright © 2018年 magic. All rights reserved.
//

import UIKit

typealias FinishBlock = (_ type:NSInteger)->()
fileprivate let repeatTimes = 6

class ZGADViewController: UIViewController {

    var block:FinishBlock?
    fileprivate var space:CGFloat = 0
    fileprivate var imageUrl:String = ""
    fileprivate var localName:String = ""
    
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet weak var finishBtn: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    init(bottomSpace bottom:CGFloat,imageUrl url:String,localImage imageName:String,finishBlock:@escaping(_ type:NSInteger)->()) {
        super.init(nibName: nil, bundle: nil)
        block = finishBlock
        space = bottom
        imageUrl = url
        localName = imageName
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        resetBaseConfigue()
        
    }

}

extension ZGADViewController
{
    fileprivate func resetBaseConfigue()
    {
        bottomSpace.constant = space
        if imageUrl.lengthOfBytes(using: .utf8) > 0 {
            // 异步加载
            asyncLoadImage()
        }else if localName.lengthOfBytes(using: .utf8) > 0 {
            imageView.image = UIImage (named: localName)
            addTimer()
        }

        // 点击事件
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(finishBtnClicked))
        let tapGes2 = UITapGestureRecognizer.init(target: self, action: #selector(showAD))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGes2)
        finishBtn.isUserInteractionEnabled = true
        finishBtn.addGestureRecognizer(tapGes)
        finishBtn.layer.cornerRadius = 3
        finishBtn.layer.masksToBounds = true
    }
    // 同步加载
    fileprivate func syncLoadImage()
    {
        let url = URL (string: imageUrl)
        let data = try? Data (contentsOf: url!)
        guard let imageData = data else{return}
        imageView.image = UIImage.init(data: imageData)
        addTimer()
    }
    // 异步加载
    fileprivate func asyncLoadImage()
    {
        let url = URL (string: imageUrl)
        let request = URLRequest (url: url!)
        let session = URLSession.shared
        weak var weakSelf = self
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error != nil
            {
                print(error.debugDescription)
            }else
            {
                let image = UIImage (data: data!)
                DispatchQueue.main.async {
                    weakSelf?.imageView.image = image
                    weakSelf?.addTimer()
                }
            }
        } as URLSessionTask
        
        dataTask.resume()
    }
    fileprivate func addTimer()
    {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        var count = repeatTimes
        weak var weakSelf = self
        
        timer.schedule(wallDeadline: .now(), repeating: 1)
        timer.setEventHandler(handler: {
            count -= 1
            DispatchQueue.main.async {
                if count == 0
                {
                    timer.cancel()
                    weakSelf?.finishBtn.isHidden = true
                    weakSelf?.finishBtnClicked()
                }
                weakSelf?.finishBtn.text = "\(count)s 跳过"
            }
        })
        timer.resume()
        
    }
    
    @objc fileprivate func finishBtnClicked()
    {
        if (block != nil) {
            block!(1)
        }
    }
    @objc fileprivate func showAD()
    {
        if (block != nil) {
            block!(0)
        }
    }
    
}
