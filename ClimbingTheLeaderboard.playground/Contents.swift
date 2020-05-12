import UIKit
//Alice is playing an arcade game and wants to climb to the top of the leaderboard and wants to track her ranking. The game uses Dense Ranking, so its leaderboard works like this:

//The player with the highest score is ranked number  on the leaderboard.

//Players who have equal scores receive the same ranking number, and the next player(s) receive the immediately following ranking number.

//For example, the four players on the leaderboard have high scores of , , , and . Those players will have ranks , , , and , respectively. If Alice's scores are ,  and , her rankings after each game are ,  and .


//Function Description

//Complete the climbingLeaderboard function in the editor below. It should return an integer array where each element represents Alice's rank after the  game.

//climbingLeaderboard has the following parameter(s):

//scores: an array of integers that represent leaderboard scores
//alice: an array of integers that represent Alice's scores

//Input Format

//The first line contains an integer , the number of players on the leaderboard.
//The next line contains  space-separated integers , the leaderboard scores in decreasing order.
//The next line contains an integer, , denoting the number games Alice plays.
//The last line contains  space-separated integers , the game scores.

//Constraints
//
//
// for
// for
//The existing leaderboard, , is in descending order.
//Alice's scores, , are in ascending order.
//Subtask
//For  of the maximum score:
//
//
//Output Format
//Print  integers. The  integer should indicate Alice's rank after playing the  game.
//6
//100 90 90 80 75 60
//5
//50 65 77 90 102

// sort the scores array and remove duplicate places

// map through both scores and alices scores, add alices scores to the score array, map alices scores and get the index for where the scores are

// I have to m

func climbingLeaderboard(scores: [Int], alice: [Int]) -> [Int] {
    
    var alicesRank: [Int] = []
    var aliceScores = alice
    var scores = scores
    
    var leaderBoard = getCurrentLeaderboard(scores: scores, aliceScores: aliceScores).0.sorted(by: { $0 > $1 })
    scores = getCurrentLeaderboard(scores: scores, aliceScores: aliceScores).1.sorted(by: { $0 > $1 })
    
   while aliceScores.count > 1 {
        let firstIndex = leaderBoard.firstIndex(of: leaderBoard.first!)!
        let index = leaderBoard.firstIndex(of: aliceScores.first!)!
        let rank = leaderBoard.distance(from: firstIndex, to: index)
        alicesRank.append(rank)
        
        aliceScores.removeFirst()
    leaderBoard = getCurrentLeaderboard(scores: scores, aliceScores: aliceScores).0.sorted(by: { $0 > $1 })
    print(leaderBoard)
    scores = getCurrentLeaderboard(scores: scores, aliceScores: aliceScores).1.sorted(by: { $0 > $1 })
    print(scores)
    }
    
    if aliceScores.count == 1 {
        let firstIndex = leaderBoard.firstIndex(of: leaderBoard.first!)!
        let index = leaderBoard.firstIndex(of: aliceScores.first!)!
        let rank = leaderBoard.distance(from: firstIndex, to: index)
        alicesRank.append(rank)
    return alicesRank
    }
    
//    while aliceScores.count >= 1 {
//
//    }
//
//    alice.map { scores.append($0) }
//    print(scores)
//
//    let leaderBoard = Set(scores).sorted(by: {$0 > $1})
//    print(leaderBoard)
//
//    print(alice)
//    alice.map {
//        let firstIndex = leaderBoard.firstIndex(of: leaderBoard.first!)!
//        let index = leaderBoard.firstIndex(of: $0)!
//        let rank = leaderBoard.distance(from: firstIndex, to: index)
//        alicesRank.append(rank)
//    }
    
    return alicesRank
    
}



func getCurrentLeaderboard(scores: [Int], aliceScores: [Int]) -> ([Int], [Int]) {
    
    print(aliceScores)
    var curreentLeaderboard = scores
    
    curreentLeaderboard.append(aliceScores.first!)
    
    return (curreentLeaderboard, curreentLeaderboard)
}

climbingLeaderboard(scores: [100,100,50,40,40,20,10], alice: [5,25,50,120])
