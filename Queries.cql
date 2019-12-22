// 1. Show all the EPL teams involved in the season.
MATCH (n1:Team)
RETURN n1 as Team;

// 2. How many matches were played on Mondays?
// 1 for Monday, 7 for Sunday
MATCH (n1:Match)
WHERE n1.date.dayOfWeek = 1
RETURN COUNT(n1) as mondayMatches;

// 3. Display the total number of goals “Liverpool” 
// had scored and conceded in the season.
MATCH (liverpool:Team{name:"Liverpool"}) - [:Played{home:True}] -> (matchHome:Match)
WITH liverpool, SUM(matchHome.FTHG) as homeGoals, SUM(matchHome.FTAG) as homeLost
MATCH (liverpool) - [:Played{home:False}] -> (matchAway:Match)
RETURN SUM(matchAway.FTAG) + homeGoals AS goalsScored, SUM(matchAway.FTHG) + homeLost AS goalsConceded;

// 4. Which teams have the most and least shots in the season?
MATCH (team:Team) - [:Played{home:False}] -> (matchAway:Match)
WITH [SUM(matchAway.AS), team.name] AS awayShots
MATCH (team:Team) - [:Played{home:True}] -> (matchHome:Match)
WHERE awayShots[1] = team.name
WITH  [(SUM(matchHome.HS) + awayShots[0]), team.name] AS totalShots
RETURN MIN(totalShots)[1] AS leastShots, MAX(totalShots)[1] AS mostShots;


// 5. Who refereed the most matches?
MATCH (referees:Referee) - [ref:Ref] - (:Match)
WITH referees, COUNT(ref) AS countedRef 
ORDER BY countedRef DESC LIMIT 1
RETURN referees.name AS refName;

// 6. How many matches “Arsenal” won as the away team?
MATCH (:Team{name:"Arsenal"}) - [:Played{home: False, result: "Win"}] - (matches:Match)
RETURN COUNT(matches) AS wonAway;

// 7. Display all the matches that “Man United” lost.
MATCH (:Team{name:"Man United"}) - [:Played{result: "Lose"}] - (matches:Match)
RETURN matches;


// 8. Display all matches that “Liverpool” won but were down in the first half.
OPTIONAL MATCH (liverpool:Team{name:"Liverpool"}) - [:Played{home: True, result: "Win"}] -> (matchesHome:Match{HTR: 'A'})
WITH liverpool, matchesHome
OPTIONAL MATCH (liverpool:Team{name:"Liverpool"}) - [:Played{home: False, result: "Win"}] -> (matchesAway:Match{HTR: 'H'})
RETURN matchesHome, matchesAway;

// 9. Write a query to display the final ranking of all the teams based on their total points.
MATCH (team:Team) - [:Played{result: "Win"}] - (matchesWon:Match)
WITH team, matchesWon
OPTIONAL MATCH (team) - [:Played{result: "Draw"}] - (matchesDrawn:Match)
WITH team, (COUNT(DISTINCT matchesWon)) AS countWon, (COUNT(DISTINCT matchesDrawn)) AS countDrawn
RETURN team.name AS Team, toInteger(countWon)*3 + toInteger(countDrawn) AS TotalPoints
ORDER BY TotalPoints DESC;


// 10. Which team has drawn the most consecutive matches?




