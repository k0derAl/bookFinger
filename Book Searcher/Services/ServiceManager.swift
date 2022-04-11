

import Foundation

protocol ServiceManagerDelegate {
    func updateBooksList(_ serviceManager: ServiceManager, bookList: [Book])
}

struct ServiceManager {
    
    let BASE_URL = "https://www.googleapis.com/books/v1/volumes?q="
    var delegate: ServiceManagerDelegate?
    
    func parse(query: String) {
        
        let decoder = JSONDecoder()
        
        guard let url = URL(string: "\(BASE_URL)\(query)") else {return}
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Failed to fetch data with error: ", error.localizedDescription)
            }
            
            guard let data = data else {return}
            
            do {
                let decodeData = try decoder.decode(BooksData.self, from: data)
                
                var booksList: [Book] = []
                
                for bookData in decodeData.items {
                    let oneBook = bookData.volumeInfo
                    let title = oneBook.title ?? ""
                    let authors = oneBook.authors ?? []
                    let description = oneBook.description ?? ""
                    var thumbnail = ""
                    var smallThumbnail = ""
                    if let bookLink = oneBook.imageLinks {
                        smallThumbnail = bookLink.smallThumbnail ?? ""
                        thumbnail = bookLink.thumbnail ?? ""
                    }
                    
                    let parsedBook = Book(title: title, authors: authors, smallThumbnail: smallThumbnail, thumbnail: thumbnail, description: description)
                    booksList.append(parsedBook)
                }
                self.delegate?.updateBooksList(self, bookList: booksList)
                
            } catch let error {
                print("Failed to create json with error: ", error.localizedDescription)
            }
            
        }
        task.resume()
    }
}
