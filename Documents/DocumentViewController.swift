//
//  DocumentsViewController.swift
//  Documents
//
//  Created by Ryan Rottmann on 2/1/19.
//  Copyright © 2019 Ryan Rottmann. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var documentText: UITextView!
    
    var document: Document?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let document = document {
            documentText.text = document.content ?? ""
            nameText.text = document.name
            
            title = document.name
        } else {
            title = ""
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        guard let name = nameText.text else{
            return
        }
        Documents.save(name: name, content: documentText.text)
    }
    @IBAction func nameChange(_ sender: Any) {
        title = nameText.text
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
