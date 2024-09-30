//
//  SideBar.swift
//  Questrix
//
//  Created by Soumadeep Choudhury on 18/09/24.
//

import SwiftUI


struct SideBar: View {
    @EnvironmentObject var USER: User
    
    @Binding var selectedTab:String
    @State var isChangeNameTapped: Bool = false
    @State var userName: String = ""
    
    var body: some View {
        VStack{
            HStack{
                Image(.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:30,height:30)
                    .cornerRadius(5)
                    
                Text("Questrix")
                    .fontWeight(.semibold)
                    .font(.title)
                    .lineLimit(1)
                Spacer()
            }.padding(.bottom)
            VStack(spacing:22){
                TabButton(title: "Dashboard",icon: "house",selected: $selectedTab)
                TabButton(title: "Courses",icon: "book",selected: $selectedTab)
                TabButton(title: "Create a Quiz",icon: "plus.circle",selected: $selectedTab)
                TabButton(title: "Upcoming Quizzes",icon: "calendar.circle",selected: $selectedTab)
                TabButton(title: "Bookmarks",icon: "bookmark",selected: $selectedTab)
            }
            Spacer()
            Image(.quizAnim).resizable().scaledToFit()
            Spacer()
            HStack{
                Text(USER.UserName).font(.title3).fontWeight(.semibold).lineLimit(1).onTapGesture {
                    isChangeNameTapped.toggle()
                    self.userName = USER.UserName
                }.alert("Change Name", isPresented: $isChangeNameTapped) {
                    TextField("Enter your name...", text: $userName)
                    Button("Update"){
                        ContentView.fileManager.setUser(userName: userName)
                    }
                    Button("Cancel"){
                        isChangeNameTapped.toggle()
                        self.userName = ""
                    }
                }
                Spacer()
            }
        }.padding(.leading)
            .padding(.bottom)
    }
}

struct TabButton: View {
    var title: String
    var icon: String
    @Binding var selected: String
    
    var body: some View {
//        Button(action: {
//
//        }, label: {
            HStack{
                Image(systemName: selected != title ? icon : icon+".fill")
                    .font(.title2)
                Text(title)
                    .font(.title2)
                    .fontWeight(selected==title ? .semibold : .none)
                    .animation(.none)
                    .lineLimit(1)
                Spacer()
                
                //Capsule
                ZStack{
                    Capsule()
                        .fill(selected == title ? Color.blue : Color.clear)
                        .frame(width:3,height:20)
                }
            }.onTapGesture {
                withAnimation(.spring()){
                    selected=title
                }
            }
//        }).buttonStyle(PlainButtonStyle())
            
    }
}
