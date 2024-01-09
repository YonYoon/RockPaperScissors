//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Zhansen Zhalel on 24.09.2023.
//

import SwiftUI

struct PlayerModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.system(size: 75))
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func playerStyle() -> some View {
        modifier(PlayerModifier())
    }
}

struct EnemyModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.system(size: 100))
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func enemyStyle() -> some View {
        modifier(EnemyModifier())
    }
}

struct ContentView: View {
    let moves = ["🪨", "📄", "✂️"]
    let winningMoves = ["📄", "✂️", "🪨"]
    
    @State private var enemyChoice = "🪨"
    @State private var shouldWin = true
    @State private var score = 0
    @State private var rounds = 0
    @State private var finishedGame = false
    @State private var didGetScore = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(stops: [
                Gradient.Stop(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.50),
                Gradient.Stop(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.55),
                ]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack {
                Text("Enemy's move")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                HStack {
                    Text(enemyChoice)
                        .enemyStyle()
                    Text(shouldWin ? "Win" : "Lose")
                        .font(.system(size: 50))
                        .frame(width: 120, height: 120)
                        .enemyStyle()
                }
                
                Spacer()
                
                Group {
                    Text("Round \(rounds + 1)/10")
                        .foregroundColor(.white)
                    Text("Score: \(score)")
                        .foregroundColor((score > 0) ? (didGetScore ? .green : .red) : .white)
                }
                .font(.title)
                
                Spacer()
                
                HStack {
                    ForEach(0..<3) { number in
                        Button {
                            playerTapped(number: number)
                        } label: {
                            Text(winningMoves[number])
                                .playerStyle()
                        }
                    }
                }
                
                Text("Your move")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            .padding()
            .alert("Game Over", isPresented: $finishedGame) {
                Button("Restart", action: reset)
            } message: {
                Text("Your total score: \(score)")
            }
        }
    }
    
    func playerTapped(number: Int) {
        if shouldWin && enemyChoice == moves[number] {
            score += 1
            didGetScore = true
        } else if !shouldWin && enemyChoice != moves[number] {
            score += 1
            didGetScore = true
        } else {
            score -= 1
            didGetScore = false
        }
        
        if rounds == 9 {
            finishedGame = true
        } else {
            rounds += 1
            enemyChoice = moves[Int.random(in: 0..<3)]
            shouldWin = Bool.random()
        }

    }
        
    func reset() {
        rounds = 0
        score = 0
        enemyChoice = moves[Int.random(in: 0..<3)]
        shouldWin = Bool.random()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
