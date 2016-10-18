//
//  UIImageExtensions.swift
//  GerbilFlicks
//
//  Created by R-J Lim on 10/17/16.
//  Copyright © 2016 R-J Lim. All rights reserved.
//

import Foundation
import AFNetworking

extension UIImageView {
    
    // Adapted from the code path guide
    func setImageWith(smallImageUrl: URL, largeImageUrl: URL, placeholderImage: UIImage?) {
        let smallImageRequest = URLRequest(url: smallImageUrl)
        let largeImageRequest = URLRequest(url: largeImageUrl)
        
        self.setImageWith(smallImageRequest, placeholderImage: placeholderImage,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                self.alpha = 0.0
                self.image = smallImage
    
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.alpha = 1.0
                    },
                    completion: { (success) -> Void in
                        self.setImageWith(
                            largeImageRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                self.image = largeImage;
                            },
                            failure: nil
                        )
                    }
                )
            },
            failure: nil
        )
    }
}
