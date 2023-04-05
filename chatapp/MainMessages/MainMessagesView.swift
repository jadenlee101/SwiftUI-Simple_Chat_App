//
//  MainMessagesView.swift
//  chatapp
//
//  Created by Jaden Lee on 2023-04-04.
//

import SwiftUI

class MainMessaseViewModel: ObservableObject {
    @Published var errorMessage = ""
    
    init (){
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser(){
        
        guard let uid = 
        FirebaseManager.shared.auth.currentUser?.uid else {return}
        self.errorMessage = "\(uid)"
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).getDocument{snapshot, err in
                if let err = err {
                    print("failed to fetch current user", err)
                    return
                }
                
                guard let data = snapshot?.data() else {return }
                print (data)
            }
    }
}

struct MainMessagesView: View {
    
    @State var shouldShowLogOut = false
    
    @ObservedObject private var vm = MainMessaseViewModel()
    
    var body: some View {
        NavigationView{
            //nav bar
            VStack{
                Text("Current user id:  \(vm.errorMessage)")
                customNavBar
                messagesView
                
                
            }
            .overlay(
                newMessageButton, alignment: .bottom
            )
            .navigationBarHidden(true)
            
        }
    }
    
    private var customNavBar : some View {
        HStack(spacing: 14){
            Image(systemName: "person.fill")
                .font(.system(size: 34, weight: .heavy))
            
            VStack (alignment: .leading, spacing: 4){
                Text("Username")
                    .font(.system(size: 24 , weight: .bold))
                
                HStack {
                    Text("Online")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.lightGray))
                    Circle()
                        .foregroundColor(Color(.green))
                        .frame(width: 10, height: 10)
                        
                }
            }
            Spacer()
            Button{
                shouldShowLogOut.toggle()
            }  label: {
                Image(systemName: "gear")
                    .foregroundColor(Color(.label))
                    .font(.system(size: 24, weight: .bold))
            }
            
        }
        .padding(.horizontal)
        .actionSheet(isPresented: $shouldShowLogOut) {
            .init(title: Text("Settings"), message:Text("What do you want to do?"), buttons: [.destructive(Text("Sign out"), action: {print("signed out")}), .cancel()])
        }
    }
    
    private var newMessageButton : some View {
        Button{} label: {
            HStack (){
                Spacer()
                Text("+ New messages")
                    .font(.system(size: 16, weight: .bold))
                    
                Spacer()
            }
            .foregroundColor(Color.white)
            .padding(.vertical)
                .background(Color.blue)
                .cornerRadius(32)
                .padding(.horizontal)
            
        }
    }
    
    private var messagesView : some View {
        ScrollView{
            VStack{
                HStack (spacing: 16){
                    Image(systemName: "person.fill")
                        .font(.system(size: 32))
                        .padding(8)
                        .overlay(RoundedRectangle(cornerRadius: 44)
                            .stroke(Color(.label), lineWidth: 1)
                        )
                    
                    VStack (alignment: .leading){
                        Text("UserName")
                        Text("message sent to the user")
                    }
                    Spacer()
                    
                    Text("22d")
                        .font(.system(size: 14, weight: .semibold))
                }
                Divider()
                    .padding(.vertical, 8)
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 50)
    }
    
    
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}