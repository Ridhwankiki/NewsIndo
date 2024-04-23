//
//  ContentView.swift
//  NewsIndo
//
//  Created by MacBook Pro on 23/04/24.
//

import SwiftUI
import SafariServices

struct ContentView: View {
    
    @StateObject private var newsVM = NewsVM()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(newsVM.articles) { article in
                    VStack (alignment: .leading, spacing: 16) {
                        AsyncImage(url: URL(string: article.image.medium)) {
                            image in
                            image.resizable()
                                .scaledToFit().clipShape(RoundedRectangle(cornerRadius: 10))
                        } placeholder: {
                            ZStack {
//                                Color.red
                                waitingView()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        Text(article.title)
                            .font(.headline)
                        
                        Text(article.author)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        HStack {
                            Text(article.isoDate.relativeToCurrentDate())
                                .font(.subheadline)
                            
                            Button {
                                let vc = SFSafariViewController(url: URL(string: article.link)!)
                                UIApplication.shared.firstKeyWindow?.rootViewController?.present(vc, animated: false)
                            } label: {
                                Text("Selengkapnya")
                                    .font(.subheadline)
                                    .foregroundStyle(.purple)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle(Constant.newsTitle)
            .task {
                await newsVM.fetchNews()
            }
            .overlay(newsVM.isLoading ? ProgressView() : nil)
        }
    }
}

#Preview {
    ContentView()
}

@ViewBuilder
func waitingView() -> some View {
    VStack(spacing : 20) {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(.pink)
        
//        Text("Fetch Image....")
    }
}

extension UIApplication {
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { scene in
                scene as? UIWindowScene
            }
            .filter { filter in
                filter.activationState == .foregroundActive
            }
            .first?.keyWindow
    }
}
