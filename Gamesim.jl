using DataFrames, CSV, StatsBase, LinearAlgebra, DataConvenience, Distributions, StatsPlots

Sch = CSV.read("Sch23.csv", DataFrame)

function GameSim(home::Float64, away::Float64, TeamH::String, TeamA::String, FDHomeOdds::Float64, FDDrawOdds::Float64, FDAwayOdds::Float64)
    HomeTeam = rand(Poisson(home), 10000)
    AwayTeam = rand(Poisson(away), 10000)
    scores = DataFrame([HomeTeam AwayTeam], [:Home, :Away])

    HomeWto0 = subset(scores, :Home => ByRow(score -> score ∈ [1,2,3,4,5,6,7,8,9,10]))
    subset!(HomeWto0, :Away => ByRow(score -> score == 0))
    HomeWto0Prob = (Int64(length(HomeWto0.Home)) / 10000)
    HomeWto0Odds = (1 / HomeWto0Prob)

    println("Odds of $TeamH win 123 to 0 $HomeWto0Odds ")    

    HomeWto1 = subset(scores, :Home => ByRow(score -> score ∈ [2,3,4,5,6,7,8,9,10]))
    subset!(HomeWto1, :Away => ByRow(score -> score == 1))
    HomeWto1Prob = (Int64(length(HomeWto1.Home)) / 10000)
    HomeWto10Odds = (1 / HomeWto1Prob)

    HomeWto2 = subset(scores, :Home => ByRow(score -> score ∈ [3,4,5,6,7,8,9,10]))
    subset!(HomeWto2, :Away => ByRow(score -> score == 2))
    HomeWto2Prob = (Int64(length(HomeWto2.Home)) / 10000)
    HomeWto2Odds = (1 / HomeWto2Prob)


    AwayWto0 = subset(scores, :Away => ByRow(score -> score ∈ [1,2,3,4,5,6,7,8,9,10]))
    subset!(AwayWto0, :Home => ByRow(score -> score == 0))
    AwayWto0Prob = (Int64(length(AwayWto0.Away)) / 10000)
    AwayWto0Odds = (1 / AwayWto0Prob)

    println("Odds of $TeamA win 123 to 0 $AwayWto0Odds ") 

    AwayWto1 = subset(scores, :Away => ByRow(score -> score ∈ [2,3,4,5,6,7,8,9,10]))
    subset!(AwayWto1, :Home => ByRow(score -> score == 1))
    AwayWto1Prob = (Int64(length(AwayWto1.Away)) / 10000)
    AwayWto1Odds = (1 / AwayWto1Prob)

    AwayWto2 = subset(scores, :Away => ByRow(score -> score ∈[3,4,5,6,7,8,9,10]))
    subset!(AwayWto2, :Home => ByRow(score -> score == 2))
    AwayWto2Prob = (Int64(length(AwayWto2.Away)) / 10000)
    AwayWto2Odds = (1 / AwayWto2Prob)

    HomeWinProb = HomeWto0Prob + HomeWto1Prob + HomeWto2Prob
    AwayWinProb = AwayWto0Prob + AwayWto1Prob + AwayWto2Prob
    DrawProb = 1.00 - HomeWinProb - AwayWinProb

    HomeWinOdds = 1 / HomeWinProb
    AwayWinOdds = 1 / AwayWinProb
    DrawOdds = 1 / DrawProb
    println("$TeamH win odds = $HomeWinOdds" )
    println("$TeamA win odds = $AwayWinOdds")
    println("Draw odds = $DrawOdds")


    homeg = @df scores histogram([:Home], label=("$TeamH"), xlabel="Goals", ylabel="Frequency", xticks=0:8)
    awayg = @df scores histogram([:Away], label=("$TeamA"), xlabel="Goals", ylabel="Frequency", color=:orange, xticks=0:8)


    
    data = [HomeWinOdds, FDHomeOdds, DrawOdds, FDDrawOdds, AwayWinOdds, FDAwayOdds]
    labels = ["HWin", "FDHWin", "Draw", "FDDraw", "AWin", "FDAWin"]
    OddsBar = bar(data, xticks=(1:length(data), labels), title="OddsVsFanduel", xlabel="Bet Type", ylabel="Odds (Decimal)",     
            legend=false, rotation=(45))


    plot(homeg, awayg, OddsBar, layout=(3,1))
    savefig("CombinedPlot$TeamH.png")
end
GameSim(.86, 1.17, "LOU", "MIA", 1.71, 3.40, 4.00)
GameSim(2.15, 1.13, "PIT", "BHM", 1.90, 3.40, 3.30)
GameSim(1.84, .77, "TBR", "DET", 1.55, 3.70, 5.00)
GameSim(1.36, 1.19, "CHS", "SA", 2.40, 3.10, 2.60)
GameSim(1.71, 1.05, "MEM", "COS", 2.25, 3.30, 2.65)


