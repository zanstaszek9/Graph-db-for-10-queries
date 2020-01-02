// 1. Show all the EPL teams involved in the season.
MATCH (n1:Team)
RETURN n1 AS Team;

// 2. How many matches were played on Mondays?
// 1 for Monday, 7 for Sunday
MATCH (n1:Match)
WHERE n1.date.dayOfWeek = 1
RETURN COUNT(n1) AS mondayMatches;

// 3. Display the total number of goals “Liverpool” 
// had scored and conceded in the season.
MATCH (liverpool:Team{name:"Liverpool"}) - [:Played{home:True}] -> (matchHome:Match)
WITH liverpool, SUM(matchHome.FTHG) AS homeGoals, SUM(matchHome.FTAG) AS homeLost
MATCH (liverpool) - [:Played{home:False}] -> (matchAway:Match)
RETURN SUM(matchAway.FTAG) + homeGoals AS goalsScored, SUM(matchAway.FTHG) + homeLost AS goalsConceded;

// 4. Which teams have the most and least shots in the season?
MATCH (team:Team) - [:Played{home:False}] -> (matchAway:Match)
WITH [SUM(matchAway.AS), team.name] AS awayShots
MATCH (team:Team) - [:Played{home:True}] -> (matchHome:Match)
WHERE awayShots[1] = team.name 
WITH  [(SUM(matchHome.HS) + awayShots[0]), team.name] AS totalShots 
// Collecting and Unwinding to use MAX and MIN as variables 
WITH collect(totalShots) AS totalShotsCollected, 
    MAX(totalShots[0]) AS maxShots, MIN(totalShots[0]) AS minShots
UNWIND totalShotsCollected AS totalShotsUnwind 
// Getting team names with least and most number of shots to match nodes 
WITH totalShotsUnwind, maxShots, minShots
WHERE totalShotsUnwind[0] = maxShots OR totalShotsUnwind[0] = minShots
MATCH (team:Team{name:totalShotsUnwind[1]})
RETURN team AS Team, totalShotsUnwind[0] AS Shots 
ORDER BY Shots DESC;

// 5. Who refereed the most matches?
MATCH (referees:Referee) - [ref:Ref] - (:Match)
WITH [COUNT(ref), referees] AS countedRef 
WITH collect(countedRef) as colRef, MAX(countedRef[0]) AS mostRef
UNWIND colRef AS countedRefU
WITH countedRefU, mostRef
WHERE countedRefU[0] = mostRef
RETURN countedRefU[1] AS Referee, countedRefU[0] AS referedMatches;

// 6. How many matches “Arsenal” won as the away team?
MATCH (:Team{name:"Arsenal"}) - [:Played{home: False, result: "Win"}] - (matches:Match)
RETURN COUNT(matches) AS wonAway;

// 7. Display all the matches that “Man United” lost.
MATCH (:Team{name:"Man United"}) - [:Played{result: "Lose"}] - (matches:Match)
RETURN matches AS Matches;


// 8. Display all matches that “Liverpool” won 
// but were down in the first half.
OPTIONAL MATCH (:Team{name:"Liverpool"}) - [:Played{home: True, result: "Win"}] -> (matchesHome:Match{HTR: 'A'})
WITH matchesHome
OPTIONAL MATCH (:Team{name:"Liverpool"}) - [:Played{home: False, result: "Win"}] -> (matchesAway:Match{HTR: 'H'})
RETURN matchesHome, matchesAway;

OPTIONAL MATCH (:Team{name:"Liverpool"}) - [:Played{home: True, result: "Win"}] -> (matchesHome:Match{HTR: 'A'})
RETURN matchesHome AS Matches
UNION 
OPTIONAL MATCH (:Team{name:"Liverpool"}) - [:Played{home: False, result: "Win"}] -> (matchesAway:Match{HTR: 'H'})
RETURN matchesAway AS Matches;
// 9. Write a query to display the final ranking of 
// all the teams based on their total points.
MATCH (team:Team) - [:Played{result: "Win"}] - (matchesWon:Match)
WITH team, matchesWon
OPTIONAL MATCH (team) - [:Played{result: "Draw"}] - (matchesDrawn:Match)
WITH team, (COUNT(DISTINCT matchesWon)) AS countWon, (COUNT(DISTINCT matchesDrawn)) AS countDrawn
RETURN team.name AS Team, toInteger(countWon)*3 + toInteger(countDrawn) AS totalPoints
ORDER BY totalPoints DESC; 
 
 
// 10. Which team has drawn the most consecutive matches? 
MATCH (teams:Team) - [played:Played] -> (matches:Match)
WITH DISTINCT teams.name AS teamsNames, played.result AS matchResults, matches.date AS z
ORDER BY matches.date
WITH teamsNames, collect(matchResults) AS matchResultsCollected
WITH teamsNames, reduce(temporary = [], i IN range(0, size(matchResultsCollected) - 1) | 
    CASE matchResultsCollected[i] = matchResultsCollected[i-1]
      WHEN true THEN [j IN range(0, size(temporary) - 1) |
          CASE j = size(temporary) - 1
            WHEN true THEN temporary[j] + [matchResultsCollected[i]]
            ELSE temporary[j]
          END
        ]
      ELSE temporary + [[matchResultsCollected[i]]]
    END
  ) AS streaks 
UNWIND streaks AS streak
WITH teamsNames, streak
WHERE streak[0] = 'Draw'
// End of refered code; Source link above
WITH teamsNames, MAX(size(streak)) AS consecutiveDraws
ORDER BY consecutiveDraws DESC
WITH [consecutiveDraws, teamsNames] AS consecutiveDrawsArr
// Using Collect and Unwind to find Team nodes 
// with the same highest number of consecutive draws
WITH collect(consecutiveDrawsArr) AS consecutiveDraws, MAX(consecutiveDrawsArr[0]) AS maxDrawAmounts
UNWIND consecutiveDraws AS consecutiveDrawsArrUnwind
WITH consecutiveDrawsArrUnwind, maxDrawAmounts
WHERE consecutiveDrawsArrUnwind[0] = maxDrawAmounts
MATCH (winners:Team{name:consecutiveDrawsArrUnwind[1]})
RETURN winners AS Winners, maxDrawAmounts;
// Source: 
//" https://stackoverflow.com/questions/47671393/neo4j-cypher-return-most-consecutive-passes "



