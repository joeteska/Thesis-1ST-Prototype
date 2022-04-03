//
//  NewProfileView.swift
//  Thesis 1ST Prototype
//
//  Created by Josef Teska on 26.01.2022.
//

import SwiftUI
import Combine


struct ProfileView: View {
    
    @State private var speed = 0.0
    @State private var isEditing = false
    @State var showSheetView = false
    @State private var MyBalance = 0
    @State private var myColor = Color(red: 0.997, green: 0.383, blue: 0.405)
    @State var userProgress = ""
    @State var userGoal = ""
    @State var userTask = ""
    @State var userTotal = ""
    @State var userTaskCompleted: CGFloat = 3
    @State var userTaskToComplete: CGFloat = 10
    @State var userTaskMoney: CGFloat = 400
    @State var activeAndCompletedTasks = ("0", "0")
    @AppStorage("isDarkMode") private var isDarkMode = false


    
    var userProgressCGFloat: CGFloat{
        if let n = NumberFormatter().number(from: userProgress) {
            return CGFloat(truncating: n)
        }
        return 0.0
    }
    var userGoalCGFloat: CGFloat{
        if let n = NumberFormatter().number(from: userGoal) {
            return CGFloat(truncating: n)
        }
        return 0.0
    }
    var userTaskCGFloat: CGFloat{
        if let n = NumberFormatter().number(from: userTask) {
            return CGFloat(truncating: n)
        }
        return 0.0
    }
    var activeAndCompleteTasksCGFloat0: CGFloat{
        if let n = NumberFormatter().number(from: activeAndCompletedTasks.0) {
            return CGFloat(truncating: n)
        }
        return 0.0
    }
    var activeAndCompleteTasksCGFloat1: CGFloat{
        if let n = NumberFormatter().number(from: activeAndCompletedTasks.1) {
            return CGFloat(truncating: n)
        }
        return 0.0
    }
   
    
  
var body: some View {
    
    
NavigationView {
    
    
    ScrollView(showsIndicators: false) {
        
        
        Spacer()
            .frame(height: 20)
        
        HStack {
            
        VStack{
                            
            HStack {
        

                VStack(alignment: .center){
                
                Text("Total")
                    Text("\(CurrencyManager.shared.getCurrencySign())\(userTaskCGFloat+userProgressCGFloat, specifier: "%.0f")")
                .font(.custom("Poppins-SemiBold", size: 35, relativeTo: .body))

                }
                .foregroundColor(.white)
                .padding([ .leading, .trailing])
                
                }
             
            }
            
           
        }
        .frame(width: 310.0, height: 140)
        .padding([.leading, .trailing])
        .background(Color(red: 0.293, green: 0.771, blue: 1.006))
        .cornerRadius(15)
        
        Spacer()
            .frame(height: 30)
        
        HStack {
            
            VStack{
            
            HStack {
        
                VStack(alignment: .center){
                
                Text("Your Progress")
                Text("\(CurrencyManager.shared.getCurrencySign())\(userProgress)")
                        .font(.custom("Poppins-SemiBold", size: 25, relativeTo: .body))
                    
                }
                
                .foregroundColor(.white)
                .padding([ .leading, .trailing])
                

                Capsule()
                .frame(width: 7, height: 60)
                .foregroundColor(.white)


                VStack(alignment: .center){
                
                Text("Your Goal")
                        .padding([ .leading, .trailing])

                    Text("\(CurrencyManager.shared.getCurrencySign())\(userGoal)")
                .font(.custom("Poppins-SemiBold", size: 25, relativeTo: .body))
                    

                }
                .foregroundColor(.white)
                .padding([ .leading, .trailing])
                
                }
                
                Spacer()
                    .frame(height: 15)
                ZStack(alignment: .leading) {
                    
                RoundedRectangle(cornerRadius: 20)
                .frame(width: 270, height: 20)
                .foregroundColor(Color(hue: 0.001, saturation: 0.596, brightness: 0.82))
                
                
                if userGoalCGFloat != 0.0{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 270*(userProgressCGFloat/userGoalCGFloat), height: 20)
                            .foregroundColor(.white)
                    
                }
                }
            }
            
           
        }
        .frame(width: 310.0, height: 150)
        .padding([.leading, .trailing])
        .background(myColor)
        .cornerRadius(15)
        
        Spacer()
            .frame(height: 30)
        
        HStack {
            
            VStack{
                
            HStack {
                ZStack{
                VStack(alignment: .center){
                
                Text("Completed")
                Text("\(activeAndCompletedTasks.0)/\(activeAndCompletedTasks.1)")
                        .font(.custom("Poppins-SemiBold", size: 25, relativeTo: .body))
                    
                }
                .foregroundColor(.white)
                .padding([ .leading, .trailing])
                    
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 15.0)
                            .foregroundColor(Color(red: 0.737, green: 0.447, blue: 0.278))
                            .frame(width: 130, height: 130)

                        Circle()
                            .trim(from: 0.0, to: (activeAndCompleteTasksCGFloat0/activeAndCompleteTasksCGFloat1))
                            .stroke(style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                            .foregroundColor(Color.white)
                            .rotationEffect(Angle(degrees: 270.0))
                            .frame(width: 130, height: 130)

                    }
                }
         
                VStack(alignment: .center){
                
                    
                Text("Collected")
                Text("\(CurrencyManager.shared.getCurrencySign())\(userTask)")
                .font(.custom("Poppins-SemiBold", size: 25, relativeTo: .body))

                }
                .foregroundColor(.white)
                .padding([ .leading, .trailing])
                
                }
            
                
               /* ZStack(alignment: .leading) {
                    
                RoundedRectangle(cornerRadius: 20)
                .frame(width: 270, height: 20)
                .foregroundColor(Color(red: 0.819, green: 0.508, blue: 0.335))
                
                
                if activeAndCompleteTasksCGFloat0 != 0.0{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 270*(activeAndCompleteTasksCGFloat0/activeAndCompleteTasksCGFloat1), height: 20)
                            .foregroundColor(.white)
                    
                    }
                }*/

            }
   
        }
        .frame(width: 310.0, height: 200)
        .padding([.leading, .trailing])
        .background(Color(red: 0.997, green: 0.592, blue: 0.378))
        .cornerRadius(15)
        
        /*
        
        Spacer()
            .frame(height: 30)
        
        HStack {
            
            VStack{
                            
            HStack {
                
                VStack(alignment: .center){
                
                Text("Completed")
                    Text("\(activeAndCompletedTasks.0)/\(activeAndCompletedTasks.1)")
                        .font(.custom("Poppins-SemiBold", size: 25, relativeTo: .body))
                    
                }
                .foregroundColor(.white)
                .padding([ .leading, .trailing])
                
            Capsule()
                .frame(width: 7, height: 60)
                .foregroundColor(.white)
                

                VStack(alignment: .center){
                
                Text("Collected")
                Text("\(CurrencyManager.shared.getCurrencySign())\(userTask)")
                .font(.custom("Poppins-SemiBold", size: 25, relativeTo: .body))

                }
                .foregroundColor(.white)
                .padding([ .leading, .trailing])
                
                }
                
                Spacer()
                    .frame(height: 15)
                ZStack(alignment: .leading) {
                    
                RoundedRectangle(cornerRadius: 20)
                .frame(width: 270, height: 20)
                .foregroundColor(Color(red: 0.819, green: 0.508, blue: 0.335))
                
                
                if activeAndCompleteTasksCGFloat0 != 0.0{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 270*(activeAndCompleteTasksCGFloat0/activeAndCompleteTasksCGFloat1), height: 20)
                            .foregroundColor(.white)
                    
                    }
                }

            }
            
          
            
           
        }
        .frame(width: 310.0, height: 150)
        .padding([.leading, .trailing])
        .background(Color(red: 0.997, green: 0.592, blue: 0.378))
        .cornerRadius(15)
        */
        

      Spacer()
    }
 
    .navigationTitle("Profile 👻")
    .font(Font.custom("Poppins", size: 15))
    .onAppear{
        
        let progressAndTotal = CoreDataManager.shared.getProgressAndTotal()
        
        userProgress = progressAndTotal.0
        userGoal = progressAndTotal.1
        
        let getTotalTask = CoreDataManager.shared.getTotalTask()
        
        userTask = getTotalTask
        
        activeAndCompletedTasks = CoreDataManager.shared.getCompletedTasks()
        
        
    }
    .toolbar {
               
        ToolbarItem(placement: .navigationBarTrailing){

                Button(action: {
                    self.showSheetView.toggle()
                }) {
                    Image(systemName: "gear")
                        .foregroundColor(isDarkMode == true ? .white: .black)
                }.sheet(isPresented: $showSheetView) {
                        Settings()
                    
                    }
                }
            }
        }
    }
}


struct NewProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .previewDevice("iPhone 13")
           
    }
}
