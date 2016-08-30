//
//  ImageDetailViewController.swift
//  Pickit
//
//  Created by Ben Gohlke on 8/29/16.
//  Copyright © 2016 The Iron Yard. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController
{
    
    var image: UIImage?
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = image!
        view.addSubview(imageView)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
