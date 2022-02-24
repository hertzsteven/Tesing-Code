//
//  ViewController.swift
//  stub to work with url session
//
//  Created by Steven Hertz on 2/22/22.
//

import UIKit

class ViewController: UIViewController {
    
    var posts: [Post] = []
    
    let tableView: UITableView = {
        let tableview =  UITableView()
        tableview.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        
        guard let myUrl = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            fatalError("not good")
        }


        let task = URLSession.shared.dataTask(with: myUrl) { data, urlResponse, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {
                fatalError("no data returned")
            }
            

            guard let posts = try? JSONDecoder().decode([Post].self, from: data) else {
                fatalError("failed decoding")
            }
            self.posts = posts
            dump(posts[1])
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            

        }
        task.resume()
        print("good hello")

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds   
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

}

