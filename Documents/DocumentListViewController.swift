//
//  DocumentListViewController.swift
//  Documents
//
//  Created by Ryan Rottmann on 2/1/19.
//  Copyright © 2019 Ryan Rottmann. All rights reserved.
//

import Foundation
import UIKit


struct Document {
    let url: URL
    let name: String
    let size: String
    let modDate: Date
    
    var content: String? {
        get {
            return try? String(contentsOf: url, encoding: .utf8)
        }
    }
}
class Documents {
    
    class func get() -> [Document] {
        var documents = [Document]()
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        if let urls = try? FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) {
            for url in urls {
                let name = url.lastPathComponent
                if let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
                    let size = attributes[FileAttributeKey.size] as? UInt64,
                    let modificationDate = attributes[FileAttributeKey.modificationDate] as? Date {
                    documents.append(Document(url: url, name: name, size: "1", modDate: modDate))
                }
            }
        }
        return documents
    }
    class func delete(url: URL) {
        try? FileManager.default.removeItem(at: url)
    }
    class func save(name: String, content: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsURL.appendingPathComponent(name)
        
        try? content.write(to: url, atomically: true, encoding: .utf8)
    }
}

class DocumentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var documentsTableView: UITableView!
    
    var documents = [Document]()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Documents"
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
    }
    override func viewWillAppear(_ animated: Bool) {
        documents = Documents.get()
        documentsTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {(action, indexPath) in
            let document = self.documents[indexPath.row]
            Documents.delete(url: document.url)
            self.documentsTableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [delete]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        
        if let cell = cell as? DocumentTableViewCell {
            let document = documents[indexPath.row]
            cell.nameLabel.text = document.name
            cell.sizeLabel.text = String(document.size) + "bytes"
            cell.dateLabel.text = dateFormatter.string(from: document.modDate)
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "selectedDocument" {
            if let destination = segue.destination as? DocumentViewController,
                let row = documentsTableView.indexPathForSelectedRow?.row {
                destination.document = documents[row]
            }
        }
    }
    
}

