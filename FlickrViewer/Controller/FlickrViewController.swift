//
//  FlickrViewController.swift
//  FlickrViewer
//
//  Created by Ivan Quintana on 10/03/20.
//  Copyright © 2020 Ivan Quintana. All rights reserved.
//

import UIKit

class FlickrViewController: UICollectionViewController {
    
    let imageDetailView: ImageDetailView = {
        let idv = ImageDetailView()
        idv.translatesAutoresizingMaskIntoConstraints = false
        return idv
    }()
    
    var searchBufferText = String()
    
    var photos: [Photo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    let searchController = UISearchController(searchResultsController: nil)
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        setupNavigationItems()
        setupCollectionView()
        getPhotos(for: "mexico")
        setupViews()
    }
    
    func getURLString(for tag: String) -> String {
        let formatedTag = tag.replacingOccurrences(of: " ", with: "%20")
        return "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=eb711db029b845ec8235a5c7ca6b3aba&tags=\(formatedTag)&format=json&nojsoncallback=1"
    }
    
    func setupNavigationItems() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Flickr Viewer"
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupCollectionView() {
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func getPhotos(for tag: String) {
        let urlString = getURLString(for: tag)
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print("error ", error.localizedDescription)
                return
            }
            
            if let data = data {
                let result = try? JSONDecoder().decode(FlickrResult.self, from: data)
                self.photos = result?.photos.photo ?? []
            }
        }.resume()
        
    }
    
    func setupViews() {
        guard let view = navigationController?.view else {return}
        view.addSubview(imageDetailView)
        imageDetailView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageDetailView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageDetailView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageDetailView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        imageDetailView.isHidden = true
    }
}

extension FlickrViewController: UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < photos.count else {return  UICollectionViewCell()}
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageCell
        cell.photo = photos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = view.frame.width/2 - 15
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCell {
            imageDetailView.imageView.image = cell.imageView.image
            imageDetailView.isHidden = false
        }
    }
    
}


extension FlickrViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBufferText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getPhotos(for: searchBufferText)
        searchController.isActive = false
    }
}


