//
//  ViewController.swift
//  Flowers
//
//  Created by Mister on 23/05/2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    //appDelegaet instance
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //Context
    var managedContext: NSManagedObjectContext!
    
    var flowers: [Flower]?
    
    @IBOutlet var textFields : [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = appDelegate.persistentContainer.viewContext
      //  NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.willResignActiveNotification, object: nil)
        loadCoreData()
    }

    func getDataFilePath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = documentPath.appending("/flower.txt")
        return filePath
    }
    
    @IBAction func addFlowerInfo(_ sender: UIButton ) {
        let id = textFields[0].text ?? ""
        let name = textFields[1].text ?? ""
        let price = Double(textFields[2].text ?? "0") ?? 0
        let provider = textFields[3].text ?? ""
        let description = textFields[4].text ?? ""

        let flower = Flower(flower_id: id, name: name, price: price, provider: provider, description: description)
        flowers?.append(flower)
        self.saveData()
        for textField in textFields {
            textField.text = ""
            textField.resignFirstResponder()
        }
    }
    
    
    func loadData() {
        flowers = [Flower]()
        let filePath = getDataFilePath()
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                // creating string of the file path
                let fileContent = try String(contentsOfFile: filePath)
                // seperating the books from each other
                let contentArray = fileContent.components(separatedBy: "\n")
                for content in contentArray {
                    // seperating each book's contents
                    let flowerContent = content.components(separatedBy: ",")
                    if flowerContent.count == 4 {
                        let flower = Flower(flower_id: flowerContent[0], name: flowerContent[1], price: Double(flowerContent[3])!,provider: flowerContent[2], description: flowerContent[4])
                        flowers?.append(flower)
                    }
                }
            } catch {
                print(error)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let flowerListVC = segue.destination as? FlowersListVC {
            flowerListVC.flowers = self.flowers
        }
    }
    
    
    @objc func saveData() {
       // clearCoreData()
        for flower in flowers! {
            let flowerEntity = NSEntityDescription.insertNewObject(forEntityName:"FlowerDataModel", into: managedContext)
            flowerEntity.setValue(flower.flower_id, forKey: "flower_id")
            flowerEntity.setValue(flower.name, forKey: "name")
            flowerEntity.setValue(flower.price, forKey: "price")
            flowerEntity.setValue(flower.provider, forKey: "provider")
            flowerEntity.setValue(flower.description, forKey: "descrption")
        }
        do {
            try managedContext.save()
        } catch {
            print(error)
        }
    }
    
    func loadCoreData() {
        
        flowers = [Flower]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FlowerDataModel")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if results is [NSManagedObject] {
                for result in (results as! [NSManagedObject]) {
                    let flower_id = result.value(forKey: "flower_id") as! String
                    let name = result.value(forKey: "name") as! String
                    let price = result.value(forKey: "price") as! Double
                    let provider = result.value(forKey: "provider") as! String
                    let description = result.value(forKey: "description") as! String
                    flowers?.append(Flower(flower_id:flower_id , name: name, price: price,provider: provider, description:description))
                }
            }
            
        } catch {
            print(error)
        }
    }
    
    
    
    func clearCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"FlowerDataModel")
//        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for result in results {
                if let managedObject = result as? NSManagedObject {
                    managedContext.delete(managedObject)
                }
            }
        } catch {
            print("Error deleting records \(error)")
        }
    }
    
}

