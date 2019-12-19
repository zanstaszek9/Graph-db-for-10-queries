// 1. Show all the EPL teams involved in the season.
MATCH (n1:Team)
RETURN n1;

// 2. How many matches were played on Mondays?
// 1 for Monday, 7 for Sunday
MATCH (n1:Match)
WHERE n1.Date.dayOfWeek = 1
RETURN COUNT(n1);

// 3. Display the total number of goals “Liverpool” 
// had scored and conceded in the season.
MATCH (n1:Team{name:"Liverpool"}) - [r1:Played] - (n2:Match)
WHERE (r1.home = True AND n2.HTR = 'A')
RETURN COUNT(n2.FTAG);

MATCH (n1:Team{name:"Liverpool"}) - [r1:Played] - (n2:Match)
WHERE (r1.home = False)
WITH n1, r1, n2, SUM(toInteger(n2.FTAG)) AS awayScore
MATCH (n1) - [r1] - (n2)
WHERE (r1.home = True)
WITH awayScore, SUM(toInteger(n2.FTHG)) AS homeScore
RETURN awayScore+homeScore;

MATCH (n1:Team{name:"Liverpool"}) - [r1:Played] - (n2:Match)
RETURN n2;

MATCH (n1:Team{name:"Liverpool"}) - [r1:Played] - (n2:Match)
RETURN n2, COUNT(n2);

MATCH (n1:Team{name:"Liverpool"}) - [r1:Played] - (n2:Match)
RETURN COUNT(n2);

MATCH (n1:Team{name:"Liverpool"}) - [r1:Played{home:True}] - (n2:Match)
RETURN COUNT(n2);

MATCH (n1:Team{name:"Liverpool"}) - [r1:Played{home:False}] - (n2:Match)
RETURN COUNT(n2);

MATCH (n1:Team{name:"Liverpool"}) - [r1:Played{home:True}] - (n2:Match)
WITH n1, COUNT(n2) as homePlayed
MATCH (n1) - [r2:Played{home:False}] - (n3:Match)
RETURN COUNT(n3) + homePlayed;

// Summing
MATCH (n1:Team{name:"Liverpool"}) - [:Played{home:True}] - (n2:Match)
RETURN SUM(n2.FTHG);

MATCH (n1:Team{name:"Liverpool"}) - [:Played{home:False}] - (n2:Match)
RETURN SUM(n2.FTAG);

MATCH (liverpool:Team{name:"Liverpool"}) - [:Played{home:True}] -> (matchHome:Match)
WITH liverpool, SUM(matchHome.FTHG) as homeGoals
MATCH (liverpool) - [:Played{home:False}] -> (matchAway:Match)
RETURN SUM(matchAway.FTAG) + homeGoals;

//4. Which teams have the most and least shots in the season?
MATCH (n1:Team) - [:Played{home:False}] -> (matchHome:Match)
RETURN n1.name, SUM(matchHome.FTAG) as Goals 
ORDER BY Goals ASC;

MATCH (n1:Team) - [:Played{home:False}] -> (matchHome:Match)
RETURN n1.name, MAX(SUM(matchHome.FTAG)), MIN(SUM(matchHome.FTAG));

MATCH (n1:Team) - [:Played{home:False}] -> (matchHome:Match)
WITH n1.name as team, SUM(matchHome.FTAG) as goals
RETURN MAX(goals), MIN(goals), team;

MATCH (n1:Team) - [:Played{home:False}] -> (matchHome:Match)
WITH n1.name as team, SUM(matchHome.FTAG) as goals
RETURN (MAX(goals), MIN(goals), team;




MATCH (n1:Team) - [:Played{home:False}] -> (matchHome:Match)
WITH [SUM(matchHome.FTAG), n1.name] AS goals
RETURN MIN(goals)[1], MAX(goals)[1];

MATCH (n1:Team) - [:Played{home:False}] -> (matchHome:Match)
WITH [SUM(matchHome.FTAG), n1.name] AS homeGoals ORDER BY homeGoals[1]
RETURN homeGoals AS homeGoals;

MATCH (n1:Team) - [:Played{home:True}] -> (matchAway:Match)
WITH [SUM(matchAway.FTHG), n1.name] AS awayGoals ORDER BY awayGoals[1]
RETURN awayGoals AS awayGoals;



MATCH (n1:Team) - [:Played{home:False}] -> (matchHome:Match)
WITH [SUM(matchHome.FTAG), n1.name] AS awayGoals
MATCH (n1:Team) - [:Played{home:True}] -> (matchAway:Match)
WITH  awayGoals , [SUM(matchAway.FTHG), n1.name] AS homeGoals ORDER BY homeGoals[1]
RETURN awayGoals, homeGoals;



MATCH (n1:Team) - [:Played{home:False}] -> (matchHome:Match)
WITH [SUM(matchHome.FTAG), n1.name] AS awayGoals
MATCH (n1:Team) - [:Played{home:True}] -> (matchAway:Match)
WITH [SUM(matchAway.FTHG), n1.name] AS homeGoals WHERE
RETURN [awayGoals[0] + homeGoals[0]];


MATCH (n1:Team) - [:Played{home:False}] -> (matchHome:Match)
WITH [SUM(matchHome.FTAG), n1.name] AS homeGoals ORDER BY homeGoals[1]
FOREACH(n IN homeGoals[0] | SET n = 10)
RETURN homeGoals;

MATCH (n1:Team) - [:Played{home:True}] -> (matchAway:Match)
WITH n1, [SUM(matchAway.FTAG), n1.name] as x
WITH collect(x) as y
RETURN unwind y;


MATCH (n1:Team) - [r1:Played] -> (n2:Match)
WITH (n1)-[r1.home = False] - (n2) AS awayMatches, (n1)-[r1.home = True] - (n2) AS homeMatche,
RETURN awayMatches;


MATCH (n1:Team) - [:Played{home:False}] -> (matchHome:Match)
WITH [SUM(matchHome.FTAG), n1.name] AS awayGoals
MATCH (n1:Team) - [:Played{home:True}] -> (matchAway:Match)
WITH  [(SUM(matchAway.FTHG) + awayGoals[0] WHERE awayGoals[1] = n1.name), n1.name] AS homeGoals
RETURN homeGoals
ORDER BY homeGoals[1];


MATCH (team:Team) - [:Played{home:False}] -> (matchAway:Match)
WITH [SUM(matchAway.FTAG), n1.name] AS awayGoals
MATCH (team:Team) - [:Played{home:True}] -> (matchHome:Match)
WHERE awayGoals[1] = team.name
WITH  [(SUM(matchHome.FTHG) + awayGoals[0]), team.name] AS totalGoals
ORDER BY totalGoals[0]
RETURN totalGoals as totalGoals;



// 5. Who refereed the most matches?
MATCH (referees:Referee) - [ref:Ref] - (:Match)
WITH referees, COUNT(ref) AS countedRef 
ORDER BY countedRef DESC LIMIT 1
RETURN referees.name, countedRef;

// 6. How many matches “Arsenal” won as the away team?
MATCH (:Team{name:"Arsenal"}) - [:Played{home: False, result: "Win"}] - (matches:Match)
RETURN COUNT(matches);

// 7. Display all the matches that “Man United” lost.
MATCH (:Team{name:"Man United"}) - [:Played{result: "Lose"}] - (matches:Match)
RETURN matches;


// 8. Display all matches that “Liverpool” won but were down in the first half.
MATCH (:Team{name:"Liverpool"}) - [playedWin:Played{result: "Win"}] - (matches:Match)
WHERE (playedWin.home = True AND matches.HTR = 'A') 
    OR  (playedWin.home = False AND matches.HTR = 'H') 
RETURN matches;


// ZAPYTAJ
OPTIONAL MATCH (liverpool:Team{name:"Liverpool"}) - [:Played{home: True, result: "Win"}] -> (matchesHome:Match{HTR: 'A'})
WITH liverpool, matchesHome
OPTIONAL MATCH (liverpool:Team{name:"Liverpool"}) - [:Played{home: False, result: "Win"}] -> (matchesAway:Match{HTR: 'H'})
RETURN matchesHome, matchesAway;


MATCH (liverpool:Team{name:"Liverpool"}) - [:Played{home: True, result: "Win"}] -> (matchesHome:Match{HTR: 'A'})
RETURN matchesHome;

MATCH (liverpool:Team{name:"Liverpool"}) - [:Played{home: False, result: "Win"}] -> (matchesAway:Match{HTR: 'H'})
RETURN matchesAway;


CREATE (:Team{name:"Manchester"}) - [:Played{home: True, result: "Win"}] -> (:Match{halfTimeResult: 'Away'});
MATCH (n1:Team{name:"Manchester"})
CREATE (n1) - [:Played{home: False, result: "Win"}] -> (:Match{halfTimeResult: 'Away'});

MATCH (n1:Team{name:"Manchester"}) - [:Played{home: True, result: "Win"}] -> (matchesHome:Match{halfTimeResult: 'Away'})
RETURN matchesHome;
MATCH (n1:Team{name:"Manchester"}) - [:Played{home: False, result: "Win"}] -> (matchesAway:Match{halfTimeResult: 'Home'})
RETURN matchesAway;

MATCH (n1:Team{name:"Manchester"}) - [:Played{home: True, result: "Win"}] -> (matchesHome:Match{halfTimeResult: 'Away'})
WITH n1, matchesHome
MATCH (n1:Team{name:"Manchester"}) - [:Played{home: False, result: "Win"}] -> (matchesAway:Match{halfTimeResult: 'Home'})
RETURN matchesHome, matchesAway;

MATCH (:Team{name:"Manchester"}) - [playedWin:Played{result: "Win"}] -> (matches:Match)
WHERE (playedWin.home = True AND matches.halfTimeResult = 'Away') 
    OR  (playedWin.home = False AND matches.halfTimeResult = 'Home') 
RETURN matches;


// Performance test option for properties set? played

// Write a query to display the final ranking of all the teams based on their total points.

// Which team has drawn the most consecutive matches?
