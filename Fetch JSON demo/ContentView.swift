//
//  ContentView.swift
//  Fetch JSON demo
//
//  Created by jitu Nayak on 3/26/20.
//  Copyright © 2020 jitu Nayak. All rights reserved.
//

import SwiftUI

struct Todo: Codable, Identifiable {
    public var id: Int
    public var title: String
    public var completed: Bool
}

class FetchToDo: ObservableObject {

  @Published var todos = [Todo]()
     
    init() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
        // 2.
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            do {
                if let todoData = data {
                    // 3.
                    let decodedData = try JSONDecoder().decode([Todo].self, from: todoData)
                    DispatchQueue.main.async {
                        self.todos = decodedData
                    }
                } else {
                    print("No data")
                }
            } catch {
                print("Error")
            }
        }.resume()
    }
}

struct ContentView: View {
    @ObservedObject var fetch = FetchToDo()
       var body: some View {
        VStack() {
               // 2.
               List(fetch.todos) { todo in
                VStack() {
                       // 3.
                    Text(todo.title)
                        .multilineTextAlignment(.leading)
                       Text("\(todo.completed.description)") // print boolean
                           .font(.system(size: 11))
                           .foregroundColor(Color.white)
                    Image(systemName: "chevron.right.2")
                }.padding(12).background(todo.completed ? /*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/ : Color.green)
                .cornerRadius(12)
                    .foregroundColor(Color.white)
            }
           
    }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
