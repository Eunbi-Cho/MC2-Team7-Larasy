//
//  SearchView.swift
//  Recorder
//
//  Created by 이지원 on 2022/06/12.
//

import SwiftUI
import UIKit

struct SearchView: View {
    
    @StateObject var viewModel = ViewModel()
    @State var search = ""
    
    init() { UITableView.appearance().backgroundColor = UIColor.clear }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("기록을 통해 기억하고 싶은 음악을 알려주세요")
                .frame(width: 300)
                .font(.system(size: 24, weight: .bold))
            
            //search bar
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("기록하고 싶은 음악, 가수를 입력하세요", text: $search)
                        .onSubmit {
                            viewModel.getSearchResults(search: search)
                        }
                }
                .foregroundColor(.titleGray)
                .padding(13)
            }
            .frame(height: 40)
            .cornerRadius(10)
            .padding(20)
            
            // result view
            List {
                ForEach(viewModel.musicList, id: \.self) { music in
                    HStack {
                        URLImage(urlString: music.artworkUrl100)
                        
                        VStack(alignment: .leading) {
                            Text(music.trackName)
                                .font(.system(size: 17, weight: .bold))
                                .padding(6)
                                .lineLimit(1)
                            Text(music.artistName)
                                .font(.system(size: 17))
                                .padding(6)
                        }
                    }
                }
                .padding()
            }
            .listStyle(.sidebar)
        }
    }
}

struct URLImage: View {
    
    @State var data: Data?
    let urlString: String
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 55, height: 55)
                .cornerRadius(5)
                .background(.gray)
        } else {
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 55, height: 55)
                .onAppear() {
                    fetchData()
                }
        }
    }
    
    private func fetchData() {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.data = data
        }
        task.resume()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}