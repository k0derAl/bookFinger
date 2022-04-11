import UIKit
import Kingfisher

class BookCell: UITableViewCell {
    
    // MARK: - Class Constants
    
    static let identifier = "BookCell"
    
    // MARK: - UIElements
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    } ()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    } ()
    
    let bookImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    } ()
    
    private lazy var stackViewLabels: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    } ()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupView()
        }

    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    
    // MARK: - Private Methods
    
    private func setupView() {
        contentView.addSubview(stackViewLabels)
        contentView.addSubview(bookImage)
        
        NSLayoutConstraint.activate([
            bookImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bookImage.widthAnchor.constraint(equalToConstant: 62),
            bookImage.heightAnchor.constraint(equalToConstant: 96),
            
            bookImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            stackViewLabels.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: stackViewLabels.trailingAnchor, constant: 16),
            stackViewLabels.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
            
        ])
    }
    
    // MARK: - Internal Methods
    
    func configure(book: Book) {
        titleLabel.text = book.title
        subTitleLabel.text = book.authors.joined(separator: ", ")
        if book.smallThumbnail != "" {
            bookImage.kf.setImage(with: URL(string: book.smallThumbnail))
        } else {
            bookImage.image = UIImage(named: "NoImagePlaceholder")
        }
    }
}
