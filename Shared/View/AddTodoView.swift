//
//  AddTodoView.swift
//  Todo
//
//  Created by Piyushh Bhutoria on 04/01/21.
//

import SwiftUI

struct AddTodoView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @State private var name: String = ""
    @State private var priority: String = "Normal"
    @State private var errorShowing: Bool = false
    
    let priorities = ["High", "Normal", "Low"]
     
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Todo", text: $name)
                    
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) {
                            Text($0)
                                .font(Font.custom("CaveatBrush-Regular", size: 22))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Button(action: {
                        if self.name != "" {
                            let todo = Todo(context: managedObjectContext)
                            todo.name = self.name
                            todo.priority = self.priority
                            
                            do {
                                try managedObjectContext.save()
                                print("New todo: \(self.name ), prority: \(self.priority )")
                                self.presentationMode.wrappedValue.dismiss()
                            } catch {
                                print(error)
                            }
                        } else {
                            self.errorShowing = true
                        }
                    }, label: {
                        Text("Save")
                    })
                }
                
                Spacer()
            }
            .navigationBarTitle("New Todo", displayMode: .inline)
            .navigationBarItems(trailing: Button(action:{
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
            }))
            .alert(isPresented: $errorShowing) {
                Alert(title: Text("Field Empty"), message: Text("Todo field is epmty"), dismissButton: .default(Text("ok")))
            }
        }
    }
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddTodoView()
            AddTodoView()
            AddTodoView()
            AddTodoView()
            AddTodoView()
        }
    }
}
