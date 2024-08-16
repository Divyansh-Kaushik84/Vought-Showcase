//
//  InitialViewController.swift
//  Vought Showcase
//
//  Created by Divyansh Kaushik on 16/08/24.
//

import UIKit

class InitialViewController: UIViewController {


    private let imageView : UIImageView = {
        let IV = UIImageView()
         
        IV.contentMode = .scaleAspectFill
        
        IV.image = UIImage(named: "villian")
        IV.translatesAutoresizingMaskIntoConstraints = false
        IV.clipsToBounds = true

        return IV
    }()
    override func viewDidLoad() {
        super.viewDidLoad()



        view.addSubview(imageView)

        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        view.sendSubviewToBack(imageView)// Replace 'button' with your button's IBOutlet name

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) 
    
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainVc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        {
            mainVc.modalPresentationStyle = .fullScreen
            mainVc.modalTransitionStyle = .coverVertical
            self.present(mainVc, animated: true, completion: nil)
        }
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
#Preview{
InitialViewController()}
