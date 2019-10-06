//
//  ContentView.swift
//  Learn SwiftUI
//
//  Created by Petrus Nguyễn Thái Học on 10/5/19.
//  Copyright © 2019 Petrus Nguyễn Thái Học. All rights reserved.
//

import SwiftUI
import Combine
import class Kingfisher.ImageDownloader
import struct Kingfisher.DownloadTask
import class Kingfisher.ImageCache

let url = URL.init(string: "https://hoc081098.github.io/hoc081098.github.io/users.json")

struct Person: Identifiable, Decodable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatar: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Person.Keys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.firstName = try container.decode(String.self, forKey: .first_name)
        self.lastName = try container.decode(String.self, forKey: .last_name)
        self.avatar = try container.decode(String.self, forKey: .avatar)
    }

    enum Keys: String, CodingKey {
        case id
        case email
        case first_name
        case last_name
        case avatar
    }
}

class PeopleViewModel: ObservableObject {
    @Published var people = [Person]()
    @Published var isLoading = false

    func fetchPeople() {
        guard let url = url else { return }

        self.isLoading = true
        URLSession.shared.dataTask(with: url) { [weak self] (data, urlResponse, error) in
            guard let data = data, error == nil else { return }
            guard let people = try? JSONDecoder.init().decode([Person].self, from: data) else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.people = people
                self?.isLoading = false
            }
        }.resume()
    }
}

struct ContentView: View {
    @ObservedObject var peopleVM = PeopleViewModel()

    init() {
        peopleVM.fetchPeople()
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {

                List(self.peopleVM.people) { person in
                    HStack {
                        URLImageView(url: URL.init(string: person.avatar)!)
                        VStack(alignment: .leading) {
                            Text("\(person.firstName) \(person.lastName)")
                                .font(.title)
                            Text(person.email)
                        }
                    }
                }

                ActivityIndicator(isAnimating: .constant(peopleVM.isLoading), style: .large)
            }
                .navigationBarTitle("Fetch json")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct URLImageView: View {

    @ObservedObject var imageLoader: ImageLoader

    init(url: URL) {
        self.imageLoader = ImageLoader.init(url: url)
    }

    var body: some View {
        Image(uiImage: imageLoader.uiImage!)
            .frame(width: 96, height: 96)
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
    }
}


class ImageLoader: ObservableObject {
    @Published var uiImage: UIImage = UIImage.init(systemName: "photo")
    private var task: DownloadTask?

    init(url: URL) {
        load(url)
    }

    func load(_ url: URL) {
        let key = url.absoluteString
        if ImageCache.default.isCached(forKey: key) {
            ImageCache.default.retrieveImage(forKey: key) { [weak self] (result) in
                switch result {

                case .success(let value):
                    DispatchQueue.main.async {
                        self?.uiImage = value.image
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            task = ImageDownloader.default.downloadImage(with: url) { [weak self] result in
                switch result {
                case .success(let value):
                    DispatchQueue.main.async {
                        self?.uiImage = value.image
                    }
                    ImageCache.default.storeToDisk(value.originalData, forKey: key)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    deinit {
        self.task?.cancel()
        print("Cancel")
    }
}


struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
