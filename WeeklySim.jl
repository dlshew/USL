using DataFrames, CSV, StatsBase, LinearAlgebra, Distributions, DataConvenience

Sch = CSV.read("Sch.csv", DataFrame)
GA = CSV.read("GA.csv", DataFrame)
XG = CSV.read("XG.csv", DataFrame)
cleannames!(GA)
cleannames!(XG)
select!(GA, Not(:Column1))
select!(XG, Not(:Column1))
select!(GA, :Team, :Goals_AddedF, :Goals_AddedA)
select!(XG, :Team, :GF, :GA, :xGF, :xGA)

Stats = leftjoin!(GA, XG, on=:Team, makeunique=true)

Stats.Offense = ((Stats.Goals_AddedF ./ mean(Stats.Goals_AddedF) .* .50) .+ (Stats.GF ./ mean(Stats.GF) .* .20) .+ (Stats.xGF ./ mean(Stats.xGF) .* .30))
Stats.Defense = (1 ./ ((mean(Stats.Goals_AddedA) ./ Stats.Goals_AddedA .* .50) .+ (mean(Stats.GA) ./ Stats.GA .* .20) .+ (mean(Stats.xGA) ./ Stats.xGA) .* .30))


HomeOffDict = Dict(Stats.Team .=>  Stats.Offense)
HomeDefDict = Dict(Stats.Team .=>  Stats.Defense)
AwayOffDict = Dict(Stats.Team .=>  Stats.Offense)
AwayDefDict = Dict(Stats.Team .=>  Stats.Defense)
Sch.HomeO = [HomeOffDict[x] for x in Sch.Home]
Sch.HomeD = [HomeDefDict[x] for x in Sch.Home]
Sch.AwayO = [AwayOffDict[x] for x in Sch.Away]
Sch.AwayD = [AwayDefDict[x] for x in Sch.Away]


Sch.HomeExpGoals = (Sch.HomeO .* Sch.AwayD) .* 1.52
Sch.AwayExpGoals = (Sch.AwayO .* Sch.HomeD) .* 1.23

Sch.HomeMedianGoals = median.(rand.(Poisson.(Sch.HomeExpGoals), 10000))
Sch.AwayMedianGoals = median.(rand.(Poisson.(Sch.AwayExpGoals), 10000))

CSV.write("Sch23.csv", Sch)
