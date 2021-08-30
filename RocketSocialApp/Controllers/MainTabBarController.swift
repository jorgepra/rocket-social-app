//
//  MainTabBarController.swift
//  RocketSocialApp
//
//  Created by Jorge Pillaca Ramirez on 21/08/21.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // select the middle tabbar to show the picker
        if viewControllers?.firstIndex(of: viewController) == 1 {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    let homeController = HomeController()
    let profileController = ProfileController(userId: "")
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        viewControllers = [
            createNavController(viewController: homeController, tabBarImage: UIImage(systemName: "house.fill")),
            createNavController(viewController: UIViewController(), tabBarImage: UIImage(systemName: "plus.circle")),
            createNavController(viewController: profileController, tabBarImage: UIImage(systemName: "person"))
        ]
        
        tabBar.tintColor = .black
    }
        
    
    func createNavController(viewController: UIViewController, tabBarImage: UIImage?) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = tabBarImage
        return navController
    }
}

extension MainTabBarController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        
        dismiss(animated: true) {
            print("image selected")
            let createPostController = CreatePostController(image: image)
            createPostController.delegate = self
            self.present(createPostController, animated: true, completion: nil)
        }        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MainTabBarController: CreatePostControllerDelegate{
    func didFinishUploading() {
        homeController.handleFetchData()
        profileController.fetchUserProfile()
    }
}
