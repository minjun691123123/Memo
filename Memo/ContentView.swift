//
//  ContentView.swift
//  Memo
//
//  Created by 송민준 on 2023/02/10.
//


import Foundation
import UIKit
import SwiftUI
import ExytePopupView
import Toast_Swift
import ExtensionKit






//불러올 색상
struct CustomColor {
    static let darkGrey = Color("darkGrey")
    static let basicBlue = Color("basicBlue")
    // Add more here...
}

struct ContentView: View {
    
    

    @State var swipeDown: Bool
    
    
    //trash 정보에 있을 녀석들
    //AppStorage를 쓴다 앱이 종료되도 유지될
    @AppStorage("garbage0")    var garbage0 : String = ""
    @AppStorage("garbage1")    var garbage1 : String = ""
    @AppStorage("garbage2")    var garbage2 : String = ""
    @AppStorage("garbage3")    var garbage3 : String = ""
    @AppStorage("garbage4")    var garbage4 : String = ""
    
    @State private var trashPopup: Bool = false
    
    //Image Change를 위한 bool 변수
    @State var imageChange : Bool = false
    
   
    
    
    @State private var coopyPopup: Bool = false
    
    //clear버튼 클릭시 true로 변환 되는 변수
    @State private var clearPopup = false
    
    //app이 실행되면 true로 변환 되는 변수
    @State private var showingPopup =  false
    
    //복사한 text를 담아두는 변수
    @State private var buttonText = "Click to copy"
    //복사한 text가 담길 변수
    private let pasteboard = UIPasteboard.general
    
    //pikerView의 기본적인 세팅이 흰색인 변수
   // @State private var colorSelection = "White"
     //pikerView의 여러 색상을 담아둔 변수
   // let colors = ["Red", "Black","White"]
    
    //pikerView의 기본적인 Font세팅 사이즈
    @State private var fontSelection = "30"
    
    //pikerView의 Font 종류를 담아둔 변수
    let fontScale = ["20","25", "30","35","40"]
    
    //textFiled에서 적힌 text를 담아두는 변수
    @State private var text: String = ""
    
   
    
  
   
    //text를 복사함
    func copyToPasteboard() {
        pasteboard.string = text
        
    }
    
    //피커 뷰 별 글 색상 변경

    func foregroundColor(_ status: String) -> Color {
        
        
        
        switch status {
        case "White":
            return Color.white
        case "Red":
            return Color.red
        default:
            return Color.black
        }
        
    }
    
    
    
    
    
    
    
    
    //피커 뷰 별 font 크기 설정
    func fontSize(_ status: String) -> Int {
        switch status {
        case "20":
            return 20
        case "25":
            return 25
        case "30":
            return 30
        case "35":
            return 35
            
        default:
            return 40
        }
    }
    
    

    
    
    //팝업 메뉴 함수
    func createBottomPopUp() -> some View {
        
        GeometryReader() { geometry in
            
          
            VStack(spacing: 0){
                
               
                HStack(){
                  
                        
                        Spacer()
                        
                        
                        //휴지통 버튼
                        Button(action:{
                            
                            trashPopup = true
                           
                            
                        }){
                            Image(systemName: !garbage0.isEmpty ? "trash.fill" :"trash")
                        }.font(.system(size:30))
                         
                    
                 
                        
           
                        
                        
                        
                        
                        Spacer()
                        
                        //피커뷰에 관한 코드
                        Picker("Select a fontSize", selection: $fontSelection) {
                            ForEach(fontScale, id: \.self) {
                                Text("Size : \($0)")
                                
                                
                                
                            }
                            
                        }
                        
                        
                        
                        
                        .pickerStyle(.menu)
                        
                        
                        Spacer()
                    
                        
                        //복사 UI
                        Button {
                            coopyPopup = true
                            copyToPasteboard()
                            self.imageChange.toggle()
                        } label: {
                            Image(systemName: self.imageChange == true ? "doc.on.doc.fill": "doc.on.doc")
                        }.font(.system(size:30))
                        
                        /* Spacer()
                         
                         
                         
                         Picker("Select a paint color", selection: $colorSelection) {
                         ForEach(colors, id: \.self) {
                         Text($0)
                         
                         
                         
                         }
                         }
                         .pickerStyle(.menu)
                         
                         
                         
                         
                         */
                        
                        
                        Spacer()
                        
                        
                        
                        
                    }//HStack
                    .padding(.bottom,15)
                    .padding(.top,0)
                    
                    
                    
                    
                    
                    
                    
                
                
                
                
                
                
                //User가 적을 TextFiled
                TextEditor(text: $text)
                    .foregroundColor(Color.white)
                    .padding()
                    .font(.system(size:CGFloat(fontSize(fontSelection))))
                    .background(CustomColor.darkGrey)
                    .scrollContentBackground(.hidden)
                    .gesture(
                          DragGesture()
                            .onChanged { (value) in
                              //MARK: What is it missing here?
                              switch value.location.y {
                              case ...(-50):
                                self.swipeDown = false
                                print("up")
                              case 50...:
                                self.swipeDown = true
                                print("down")
                                  //글자 저장
                                  UserDefaults.standard.set(text, forKey: "textData" )
                                  
                                  UserDefaults.standard.set(garbage0, forKey: "garbage0")
                                  UserDefaults.standard.set(garbage1, forKey: "garbage1")
                                  UserDefaults.standard.set(garbage2, forKey: "garbage2")
                                  UserDefaults.standard.set(garbage3, forKey: "garbage3")
                                  UserDefaults.standard.set(garbage4, forKey: "garbage4")
                               
                                  
                                  
                                  //팝업 종료
                                  showingPopup = false
                                  
                                  
                                  
                                  
                                  //앱 종료
                                  UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                      
                                      
                                      
                                      exit(0)
                                  }
                              default: ()
                              }
                                
                        })
                
                   
              
                
                
                
                
                
                
                
                
                
                
                
                //가장 아래 Clear / Save 버튼 을 담아두는 Stack
                HStack(spacing:0){
                  
                        //Clear Button
                        Button("Clear"){
                            //글자 삭제
                            self.clearPopup  = true
                            
                            
                            
                        }
                        .frame(width: geometry.size.width / 2, height: geometry.size.height / 10)
                        .background(Color.white)
                        .font(.system(.largeTitle))
                        .fontWeight(.bold)
                        .actionSheet(isPresented: $clearPopup) {
                            ActionSheet(
                                title: Text("Delete?"),
                                buttons: [
                                    .cancel(),
                                    .destructive(Text("Yes"),action: {
                                      //변수에 내용물 저장
                              
                                        if garbage0.isEmpty{
                                            garbage0 = text
                                        }
                                        else if !garbage0.isEmpty && garbage1.isEmpty{
                                            garbage1 = text
                                        }
                                        else if !garbage0.isEmpty && !garbage1.isEmpty && garbage2.isEmpty{
                                            garbage2 = text
                                        }
                                        else if !garbage0.isEmpty && !garbage1.isEmpty && !garbage2.isEmpty && garbage3.isEmpty{
                                            garbage3 = text
                                        }
                                        else if !garbage0.isEmpty && !garbage1.isEmpty && !garbage2.isEmpty && !garbage3.isEmpty && garbage4.isEmpty{
                                            garbage4 = text
                                           
                                            garbage0 = garbage1
                                            garbage1 = garbage2
                                            garbage2 = garbage3
                                            garbage3 = garbage4
                                            garbage4 = ""
                                        }
                                          
                                            
                                        
                                       
                                        text=""
                                    }
                                    
                                    ),
                                    .default(Text("No"))
                                ]
                            )
                        
                        }
                    
                    
                    //Save Button
                    Button("Save"){
                        
                        
                        
                        //글자 저장
                        UserDefaults.standard.set(text, forKey: "textData" )
                        
                        UserDefaults.standard.set(garbage0, forKey: "garbage0" )
                        UserDefaults.standard.set(garbage1, forKey: "garbage1" )
                        UserDefaults.standard.set(garbage2, forKey: "garbage2" )
                        UserDefaults.standard.set(garbage3, forKey: "garbage3" )
                        UserDefaults.standard.set(garbage4, forKey: "garbage4" )
                        
                        
                        
                
                       
                      
                        
                        //팝업 종료
                        showingPopup = false
                        
                        
                        //앱 종료
                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            
                            
                            
                            exit(0)
                        }
                        
                    }
                    .frame(width: geometry.size.width / 2,  height: geometry.size.height / 10)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .font(.system(.largeTitle))
                    .fontWeight(.bold)
                    
                    
                    
                    
                    
                }
               
                
                
            }//VStack
            
            
            
            
        }//Geo
        
        
    
        
        
        
        
        
    }//function
    
    
    func copyPopup() -> some View {
            VStack(spacing: 10) {
                

                        Button(action: {
                            self.coopyPopup = false
                        }) {
                            Text("Copy!")
                                .font(.system(size: 30))
                                .foregroundColor(CustomColor.basicBlue)
                                .fontWeight(.bold)
                        }
                        .frame(width: 300, height: 40)
                        .background(Color.white)
                        .cornerRadius(20.0)
                    }
            //        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                        .padding(.horizontal, 10)
                    .frame(width: 300, height: 100)
                    .background(Color.white)
                    .cornerRadius(10.0)
                    .shadow(radius: 10)
        }
    
    
    
    func createTrashPopup() -> some View {
        
            VStack(spacing: 10) {
                
                
                if garbage0.isEmpty{
                    Spacer()
                    Text("Nothing")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                }else {
                    Spacer()
                    Text("Trash")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                    
                    List{
                        
                        Text(garbage0)
                        
                            .foregroundColor(CustomColor.basicBlue)
                            .onTapGesture {
                                text = garbage0
                                trashPopup = false
                                
                            }
                        Text(garbage1)
                            .foregroundColor(CustomColor.basicBlue)
                            .onTapGesture {
                                text = garbage1
                                trashPopup = false
                            }
                        Text(garbage2)
                            .foregroundColor(CustomColor.basicBlue)
                            .onTapGesture {
                                text = garbage2
                                trashPopup = false
                            }
                        Text(garbage3)
                            .foregroundColor(CustomColor.basicBlue)
                            .onTapGesture {
                                text = garbage3
                                trashPopup = false
                            }
                        Text(garbage4)

                            .foregroundColor(CustomColor.basicBlue)
                            .onTapGesture {
                                text = garbage4
                                trashPopup = false
                            }
                    }//list
                    Spacer()
                    Text("Ok")
                        .font(.system(size:30))
                        .fontWeight(.bold)
                        .foregroundColor(CustomColor.basicBlue)
                        .onTapGesture {
                            trashPopup = false
                        }
                    
                    
                }
              
                
                
                
                
                 Spacer()
             
               
                   
                       
                
                Spacer()
                    .frame(height: 10)
                    }
            //        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                        .padding(.horizontal, 10)
                    .frame(width: 400, height: 600)
                    .background(Color.white)
                    .cornerRadius(10.0)
                    .shadow(radius: 10)
        
        
        }
    
    
    var body: some View {
        
   
        
        
        
        
        ZStack{
           
           
            
            
        }//ZStack
       
        
        
        //복사완료 팝업
        .popup(isPresented: $coopyPopup) {
           
         copyPopup()
           
           
           
       } customize: {
           $0
               .autohideIn(1)
               .type(.toast)
               .position(.bottom)
               .animation(.default)
               .closeOnTap(true)
               .closeOnTapOutside(true)
           
           
       }
        
        
        
        //휴지통 팝업
        .popup(isPresented: $trashPopup) {
           
         createTrashPopup()
           
           
           
       } customize: {
           $0
               .autohideIn(1000)
               .type(.toast)
               .position(.bottom)
               .animation(.default)
               .closeOnTap(true)
               .closeOnTapOutside(true)
           
           
       }
        
      
        
       
        
      
        
        
        //팝업뷰가 생성됨으로써 실행되는 사항들
        .popup(isPresented: $showingPopup) {
            
            
                
                createBottomPopUp()
           
            
            
          

            
            
        } customize: {
            
            
            $0
            
            
            
        
                .autohideIn(1000)
                .type(.toast)
                .position(.bottom)
                .animation(.default)
                .closeOnTap(false)
                .closeOnTapOutside(false)
            
            
        }
        //앱 실행시 동작 사항들
        .onAppear{
            
           
            
           
            self.showingPopup = true
            
           
            
            
          
                
                let b =  UserDefaults.standard.value(forKey: "textData") ?? ""
                text = b as! String
                
          
           
        }
        
      
        
        
        
        
    }//bodyView
        
    
}//contentView

















//프리뷰
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ContentView(swipeDown: false)
           
        
        
        
        
    }
}
