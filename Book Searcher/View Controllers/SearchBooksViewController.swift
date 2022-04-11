

import UIKit

class SearchBooksViewController: UIViewController {
    
    // MARK: - UIElements
    
    let tableView = UITableView()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        searchBar.setShowsCancelButton(false, animated: false)
        return searchBar
    }()
    
    
    // MARK: - Variables and properties
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
      var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
      return recognizer
    }()
    
    var searchResults: [Book] = []
    var serviceManager = ServiceManager()
    
    // MARK: - Internal Methods
    
    @objc func dismissKeyboard() {
      searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceManager.delegate = self
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BookCell.self, forCellReuseIdentifier: BookCell.identifier)
        
        navigationItem.titleView = searchBar
        setupView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

// MARK: - TableViewDelegate Methods
extension SearchBooksViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier, for: indexPath) as? BookCell else { return UITableViewCell() }
        cell.configure(book: searchResults[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookInfoViewController = BookInfoViewController(book: searchResults[indexPath.row])
        show(bookInfoViewController, sender: self)
    }
}

// MARK: - SearchBarDelegate

extension SearchBooksViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        let searchText = searchBar.text?.replacingOccurrences(of: " ", with: "") ?? ""
        serviceManager.parse(query: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
      view.removeGestureRecognizer(tapRecognizer)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            searchResults = []
            tableView.reloadData()
        }
    }
}

// MARK: - Setup View
extension SearchBooksViewController {
    private func setupView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 120
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - ServiceManagerDelegate
extension SearchBooksViewController: ServiceManagerDelegate {
    func updateBooksList(_ serviceManager: ServiceManager, bookList: [Book]) {
        DispatchQueue.main.async {
            self.searchResults = bookList
            self.tableView.reloadData()
        }
    }
}
