//
//  ContentView.swift
//  Shared
//
//  Created by Piyushh Bhutoria on 04/01/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>

    @State private var showingAddTodoView: Bool = false
    
    var body: some View {
        NavigationView {
            List{
                ForEach(self.todos, id: \.self) {todo in
                    HStack {
                        Text(todo.name ?? "Unknown")
                            .font(Font.custom("CaveatBrush-Regular", size: 22))
                        Spacer()
                        Text(todo.priority ?? "Unknown")
                            .font(Font.custom("CaveatBrush-Regular", size: 22))
                    }
                }
                .onDelete(perform: deleteTodo)
            }
            .navigationBarTitle("Todo", displayMode: .inline)
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                self.showingAddTodoView.toggle()
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $showingAddTodoView, content: {
                AddTodoView().environment(\.managedObjectContext, managedObjectContext)
            })
        }
    }
    
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
