import UIKit

class BookInfoViewController: UIViewController {
    
    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIElements
    
    let coverImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    } ()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    } ()
    let authors: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    } ()
    let descriptionLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private lazy var stackViewLabels: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, authors])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    } ()
    // MARK: - Variables and properties
    
    private let book: Book
    
    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white
        setupUI()
        setupView()
    }
    
    
    
    // MARK: - Private Methods
    
    private func setupUI() {
        descriptionLabel.isEditable = false

        titleLabel.text = book.title
        authors.text = book.authors.joined(separator: ", ")
        descriptionLabel.text = book.description
        if book.thumbnail != "" {
            coverImage.kf.setImage(with: URL(string: book.thumbnail))
        } else {
            coverImage.image = UIImage(named: "NoImagePlaceholder")
        }
    }
    
    private func setupView() {
        view.addSubview(coverImage)
        view.addSubview(stackViewLabels)
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            coverImage.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            coverImage.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4),
            coverImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            stackViewLabels.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 24),
            stackViewLabels.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackViewLabels.trailingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: stackViewLabels.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor, constant: 16),
            
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16)
            
            
        ])
    }
}
