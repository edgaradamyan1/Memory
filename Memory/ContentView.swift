//
//  ContentView.swift
//  Memory
//
//  Created by Edgar Adamyan on 31.01.25.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var viewModel = GameViewModel()
  
  var column = Array(repeating: GridItem(.fixed(70)), count: 5)
  
    var body: some View {
        VStack {
          title
          message
          board
          startGameButtom
        }
    }
  
  var title: some View {
    Text("Memory")
      .foregroundStyle(Color.orange)
      .font(.system(size: 80).weight(.black))
  }
  
  var message: some View {
    Text(viewModel.message)
      .font(.system(size: 18).weight(.bold))
      .padding(.horizontal, 5)
      .padding(.top, 20)
      .padding(.bottom)
  }
  
      
  var board: some View {
    LazyVGrid(columns: column) {
      ForEach(0..<viewModel.board.count, id: \.self) { row  in
        ForEach(0..<viewModel.board[row].count, id: \.self) { column in
          CardView(card: viewModel.board[row][column])
            .onTapGesture {
              viewModel.flipCard(row: row, column: column)
            }
        }
      }
    }
  }
  

  
  var startGameButtom: some View {
    Button {
      viewModel.restartGame()
    } label: {
      RoundedRectangle(cornerRadius: 10)
        .fill(Color.green)
        .frame(maxWidth: .infinity, maxHeight: 60)
        .padding()
        .padding(.vertical)
        .overlay {
          Text("Start Game")
            .fontWeight(.black)
            .foregroundStyle(.white)
            
        }
        
    }

  }
}
struct CardView: View {
  let card: Card
  var body: some View {
    RoundedRectangle(cornerRadius: 6)
      .fill(card.isFaceUp ? Color.yellow : Color.blue)
      .frame(width: 70, height: 70)
      .shadow(radius: 5)
      .overlay {
        if card.isFaceUp {
          Text(card.content)
            .font(.largeTitle)
        }
      }
  }
}

#Preview {
  ContentView()
}
