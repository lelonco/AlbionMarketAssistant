//
//  ContentView.swift
//  AlbionAssistant
//
//  Created by Yaroslav Ark on 31.01.2021.
//

import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var viewModel = SearchViewModel()
    @State var data: Data? = nil
    var sub: Cancellable? = nil

    private var disposables = Set<AnyCancellable>()
//    @FetchRequest(
//        entity: AlbionItem.entity(), sortDescriptors: []
//    ) var fetched: FetchedResults<AlbionItem>
    @State var text: String = "" {
        didSet {
            
        }
    }
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $viewModel.searchText)
                if let data = viewModel.data {
                    Image(uiImage: UIImage(data: data)!)
                }
                Button(action: {
                    viewModel.buttonTapped()
//                            .store(in: &disposables)
//                      self.showDetails.toggle()
                  }) {
                      Text("Show details")
                  }
                List(viewModel.fecthedResults) {
//                    let text = ($0.localizedNames?.allObjects.first as? LocalizedOjbect)
//                    Text(text?.localizedString ?? "")

                    let text = ($0.localizedNames?.allObjects.first(where: { (local) -> Bool in
                        (local as! LocalizedOjbect).language == LocalisationLenguage.ru.rawValue
                    }) as? LocalizedOjbect)
                    Text((text as? LocalizedOjbect)?.localizedString ?? "")
                }
                .ignoresSafeArea()
            }
            .navigationBarTitle("Title")
        }
        .navigationBarColor(backgroundColor: .black, tintColor: .white)
    }
    mutating func buttonTapped() {
        let req = URLRequest(url: URL(string: "https://gameinfo.albiononline.com/api/gameinfo/items/T4_2H_WARBOW")!)
        let pub = URLSession.shared.dataTaskPublisher(for: req)
            .eraseToAnyPublisher()
        sub = pub
            .sink(receiveCompletion: { (complition) in
                switch complition {
                
                case .finished:
                    break
                case let .failure(error):
                    print(error)
                }
            }, receiveValue: { [self] (data: Data, response: URLResponse) in
                self.data = data
                print(response)
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct NavigationBarColor: ViewModifier {

  init(backgroundColor: UIColor, tintColor: UIColor) {
    let coloredAppearance = UINavigationBarAppearance()
    coloredAppearance.configureWithOpaqueBackground()
    coloredAppearance.backgroundColor = backgroundColor
    coloredAppearance.titleTextAttributes = [.foregroundColor: tintColor]
    coloredAppearance.largeTitleTextAttributes = [.foregroundColor: tintColor]
                   
    UINavigationBar.appearance().standardAppearance = coloredAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    UINavigationBar.appearance().compactAppearance = coloredAppearance
    UINavigationBar.appearance().tintColor = tintColor
  }

  func body(content: Content) -> some View {
    content
  }
}

extension View {
  func navigationBarColor(backgroundColor: UIColor, tintColor: UIColor) -> some View {
    self.modifier(NavigationBarColor(backgroundColor: backgroundColor, tintColor: tintColor))
  }
}

extension String.SubSequence: Identifiable {
    public var id: String.SubSequence {
        self
    }
}

extension String: Identifiable {
    public var id: String {
        self
    }
}
