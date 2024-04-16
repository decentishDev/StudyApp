//
//  MainePage.swift
//  StudyApp
//
//  Created by Tirth D. Patel on 4/16/24.
//
import SwiftUI

struct ContentView: View {
    @State private var isDarkMode = true
    
    let buttonSize: CGFloat = 170
    
  
    func whiteBoxOverlay() -> some View {
        RoundedRectangle(cornerRadius: 25)
            .stroke(Color.white, lineWidth: 2)
    }
    
    var body: some View {
        ZStack {
            
            Color(isDarkMode ? .black : .white).edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                HStack {
                    Text("Dendritic Learning")
                        .foregroundColor(.white)
                        .font(.custom("Times New Roman", size: 35))
                        .padding(.leading)
                    
                    Spacer()
                    
                  
                    Toggle("", isOn: $isDarkMode)
                        .labelsHidden() // Hides the toggle label
                        .padding(.trailing)
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {
                        // Action for first button
                    }) {
                        Text("Button 1")
                            .font(.custom("Times New Roman", size: 20))
                            .foregroundColor(.white)
                            .frame(width: buttonSize, height: buttonSize)
                            .background(Color.blue)
                            .cornerRadius(25)
                            .overlay(whiteBoxOverlay())
                    }
                    
                    Button(action: {
                        // Action for second button
                    }) {
                        Text("Button 2")
                            .font(.custom("Times New Roman", size: 20))
                            .foregroundColor(.white)
                            .frame(width: buttonSize, height: buttonSize)
                            .background(Color.green)
                            .cornerRadius(25)
                            .overlay(whiteBoxOverlay())
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.top, -450)
            
            HStack(spacing: 20) {
                Button(action: {
                    // Action for Flashcards button
                }) {
                    Text("Flashcards")
                        .font(.custom("Times New Roman", size: 20))
                        .foregroundColor(.white)
                        .frame(width: buttonSize, height: buttonSize)
                        .background(Color.red)
                        .cornerRadius(25)
                        .overlay(whiteBoxOverlay())
                }
                
                Button(action: {
                    // Action for Button 4
                }) {
                    Text("Button 4")
                        .foregroundColor(.white)
                        .frame(width: buttonSize, height: buttonSize)
                        .background(Color.orange)
                        .cornerRadius(25)
                        .font(.custom("Times New Roman", size: 20))
                        .overlay(whiteBoxOverlay())
                }
            }
            .padding(.top, 180)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

