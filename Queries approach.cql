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
WITH [SUM(matchHome.FTAG), n1.name] AS awayGoals
MATCH (n1:Team) - [:Played{home:True}] -> (matchAway:Match)
WITH [SUM(matchAway.FTHG), n1.name] AS homeGoals, awayGoals
RETURN [awayGoals[0] + homeGoals[0]];



MATCH (team:Team) - [:Played{home:False}] -> (matchAway:Match)
WITH [SUM(matchAway.FTAG), team.name] AS awayGoals
MATCH (team:Team) - [:Played{home:True}] -> (matchHome:Match)
WHERE awayGoals[1] = team.name
WITH  [(SUM(matchHome.FTHG) + awayGoals[0]), team.name] AS totalGoals
ORDER BY totalGoals[0]
RETURN totalGoals as totalGoals;

MATCH (team:Team) - [:Played{home:False}] -> (matchAway:Match)
WITH [SUM(matchAway.FTAG), team.name] AS awayGoals
MATCH (team:Team) - [:Played{home:True}] -> (matchHome:Match)
WHERE awayGoals[1] = team.name
WITH  [(SUM(matchHome.FTHG) + awayGoals[0]), team.name] AS totalGoals
RETURN MIN(totalGoals)[1] as leastGoals, MAX(totalGoals)[1] as mostGoals;

// Checking behaviour of MAX and MIN

MATCH (team:Team{name: "Huddersfield"}) - [:Played{home:False, result:"Win"}] -> (n2:Match)
WITH team, n2 LIMIT 1
SET n2.FTAG = n2.FTAG + 12
RETURN *;

MATCH (team:Team) - [:Played{home:False}] -> (matchAway:Match)
WITH [SUM(matchAway.FTAG), team.name] AS awayGoals
MATCH (team:Team) - [:Played{home:True}] -> (matchHome:Match)
WHERE awayGoals[1] = team.name
WITH  [(SUM(matchHome.FTHG) + awayGoals[0]), team.name] AS totalGoals ORDER BY totalGoals[0]
RETURN totalGoals;

MATCH (team:Team) - [:Played{home:False}] -> (matchAway:Match)
WITH [SUM(matchAway.FTAG), team.name] AS awayGoals
MATCH (team:Team) - [:Played{home:True}] -> (matchHome:Match)
WHERE awayGoals[1] = team.name
WITH  [(SUM(matchHome.FTHG) + awayGoals[0]), team.name] AS totalGoals
RETURN [n in totalGoals WHERE n = MIN(totalGoals)] as leastGoals;
// Cant find a way to make it work when there are 2 same MIN/MAX values

MATCH (n1:Team) - [:Played{home:False}] -> (matchHome:Match)
RETURN n1.name, SUM(matchHome.AS) as Goals 
ORDER BY Goals ASC;


MATCH (team:Team) - [:Played{home:False}] -> (matchAway:Match)
WITH [SUM(matchAway.AS), team.name] AS awayGoals
MATCH (team:Team) - [:Played{home:True}] -> (matchHome:Match)
WHERE awayGoals[1] = team.name
WITH  [(SUM(matchHome.HS) + awayGoals[0]), team.name] AS totalGoals ORDER BY totalGoals[0]
RETURN totalGoals;

MATCH (team:Team) - [:Played{home:False}] -> (matchAway:Match)
WITH [SUM(matchAway.AS), team.name] AS awayGoals
MATCH (team:Team) - [:Played{home:True}] -> (matchHome:Match)
WHERE awayGoals[1] = team.name
WITH  [(SUM(matchHome.HS) + awayGoals[0]), team.name] AS totalGoals
RETURN MIN(totalGoals)[1] as leastGoals, MAX(totalGoals)[1] as mostGoals;


// Improved using Query 10
MATCH (team:Team) - [:Played{home:False}] -> (matchAway:Match)
WITH [SUM(matchAway.AS), team.name] AS awayGoals
MATCH (team:Team) - [:Played{home:True}] -> (matchHome:Match)
WHERE awayGoals[1] = team.name
WITH  [(SUM(matchHome.HS) + awayGoals[0]), team.name] AS totalShots
WITH collect(totalShots) AS totalShotsCollected, max(totalShots[0]) as maxShots, min(totalShots[0]) as minShots
UNWIND totalShotsCollected AS totalShotsUnwind
WITH totalShotsUnwind, maxShots, minShots
WHERE totalShotsUnwind[0] = maxShots OR totalShotsUnwind[0] = minShots
MATCH (team:Team{name:totalShotsUnwind[1]})
RETURN team, maxShots, minShots

MATCH (team:Team) - [:Played{home:False}] -> (matchAway:Match)
WITH [SUM(matchAway.AS), team.name] AS awayGoals
MATCH (team:Team) - [:Played{home:True}] -> (matchHome:Match)
WHERE awayGoals[1] = team.name
WITH  [(SUM(matchHome.HS) + awayGoals[0]), team.name] AS totalShots
WITH totalShots, collect(totalShots) AS totalShotsCollected, max(totalShots[0]) as maxShots, min(totalShots[0]) as minShots
UNWIND totalShotsCollected AS totalShotsUnwind
WITH totalShotsUnwind, maxShots, minShots, totalShots
WHERE totalShotsUnwind[0] = maxShots OR totalShotsUnwind[0] = minShots
MATCH (team:Team{name:totalShotsUnwind[1]})
RETURN team, maxShots, minShots, totalShots


MATCH (team:Team) - [:Played{home:False}] -> (matchAway:Match)
WITH [SUM(matchAway.AS), team.name] AS awayGoals
MATCH (team:Team) - [:Played{home:True}] -> (matchHome:Match)
WHERE awayGoals[1] = team.name
WITH  [(SUM(matchHome.HS) + awayGoals[0]), team.name] AS totalShots
WITH collect(totalShots) AS totalShotsCollected, max(totalShots[0]) as maxShots, min(totalShots[0]) as minShots
UNWIND totalShotsCollected AS totalShotsUnwind
WITH totalShotsUnwind, maxShots, minShots
WHERE totalShotsUnwind[0] = maxShots OR totalShotsUnwind[0] = minShots
MATCH (team:Team{name:totalShotsUnwind[1]})
RETURN team, totalShotsUnwind[0] AS shots 

// 5. Who refereed the most matches?
MATCH (referees:Referee) - [ref:Ref] - (:Match)
WITH referees, COUNT(ref) AS countedRef 
ORDER BY countedRef DESC LIMIT 1
RETURN referees.name, countedRef;

MATCH (referees:Referee) - [ref:Ref] - (:Match)
WITH referees, COUNT(ref) AS countedRef 
ORDER BY countedRef DESC LIMIT 1
MATCH (mostRefered:Referee{name:referees.name})
RETURN mostRefered AS refName, countedRef;

MATCH (referees:Referee) - [ref:Ref] - (:Match)
WITH [COUNT(ref), referees] AS countedRef 
WITH collect(countedRef) as colRef, MAX(countedRef[0]) AS mostRef
UNWIND colRef AS countedRefU
WITH countedRefU, mostRef
WHERE countedRefU[0] = mostRef
RETURN countedRefU;

MATCH (n1:Referee{name: "M Oliver"}), (n2:Match{FTHG: 5})
WITH n1, n2 LIMIT 2
MERGE (n1) - [r1:Ref] -> (n2)
RETURN *;


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

MATCH (liverpool:Team{name:"Liverpool"}) - [:Played{home: True, result: "Win"}] -> (matchesHome:Match{HTR: 'A'})
WITH liverpool, matchesHome
MATCH (liverpool:Team{name:"Liverpool"}) - [:Played{home: False, result: "Win"}] -> (matchesAway:Match{HTR: 'H'})
RETURN matchesHome, matchesAway;

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


MATCH (t:Team) - [playedWin:Played{result: "Win"}] - (matches:Match)
WHERE (playedWin.home = True AND matches.HTR = 'A') 
    OR  (playedWin.home = False AND matches.HTR = 'H') 
RETURN t, playedWin, matches ORDER BY t.name;

OPTIONAL MATCH (t:Team) - [r1:Played{home: True, result: "Win"}] -> (matchesHome:Match{HTR: 'A'})
WITH t, r1, matchesHome
OPTIONAL MATCH (t:Team) - [r2:Played{home: False, result: "Win"}] -> (matchesAway:Match{HTR: 'H'})
RETURN t, r1, r2, matchesHome, matchesAway
ORDER BY t.name;


OPTIONAL MATCH (t:Team) - [r1:Played{home: True, result: "Win"}] -> (matchesHome:Match{HTR: 'A'})
WITH t, r1, matchesHome
OPTIONAL MATCH (t2:Team) - [r2:Played{home: False, result: "Win"}] -> (matchesAway:Match{HTR: 'H'})
RETURN t, t2, r1, r2, matchesHome, matchesAway
ORDER BY t.name;

OPTIONAL MATCH (t:Team) - [r1:Played{home: True, result: "Win"}] -> (matchesHome:Match{HTR: 'A'})
WITH t, r1, matchesHome
OPTIONAL MATCH (t:Team) - [r2:Played{home: False, result: "Win"}] -> (matchesAway:Match{HTR: 'H'})
RETURN t, r1, r2, matchesHome, matchesAway
ORDER BY t.name;

OPTIONAL MATCH (t:Team) - [:Played{home: True, result: "Win"}] -> (matchesHome:Match{HTR: 'A'})
WITH t, matchesHome
OPTIONAL MATCH (t2:Team) - [:Played{home: False, result: "Win"}] -> (matchesAway:Match{HTR: 'H'})
RETURN matchesHome, matchesAway;

OPTIONAL MATCH (:Team) - [:Played{home: True, result: "Win"}] -> (matchesHome:Match{HTR: 'A'})
WITH matchesHome 
OPTIONAL MATCH (:Team) - [:Played{home: False, result: "Win"}] -> (matchesAway:Match{HTR: 'H'})
WITH matchesHome + matchesAway;

OPTIONAL MATCH (:Team) - [:Played{home: True, result: "Win"}] -> (matchesHome:Match{HTR: 'A'})
WITH collect(matchesHome) as col 
OPTIONAL MATCH (:Team) - [:Played{home: False, result: "Win"}] -> (matchesAway:Match{HTR: 'H'})
RETURN col, matchesAway;

OPTIONAL MATCH (:Team{name:"Liverpool"}) - [:Played{home: True, result: "Win"}] -> (matchesHome:Match{HTR: 'A'})
RETURN matchesHome AS Matches
UNION 
OPTIONAL MATCH (:Team{name:"Liverpool"}) - [:Played{home: False, result: "Win"}] -> (matchesAway:Match{HTR: 'H'})
RETURN matchesAway AS Matches;


MATCH (:Team{name:"Bournemouth"}) - [playedWin:Played{result: "Win"}] - (matches:Match)
WHERE (playedWin.home = True AND matches.HTR = 'A') 
    OR  (playedWin.home = False AND matches.HTR = 'H') 
RETURN matches;

MATCH (t:Team{name:"Bournemouth"}) - [playedWin:Played{result: "Win"}] - (matches:Match)
WHERE (playedWin.home = True AND matches.HTR = 'A') 
    OR  (playedWin.home = False AND matches.HTR = 'H') 
RETURN *;


OPTIONAL MATCH (liverpool:Team{name:"Bournemouth"}) - 
[:Played{home: True, result: "Win"}] -> (matchesHome:Match{HTR: 'A'})
WITH liverpool, matchesHome
OPTIONAL MATCH (liverpool2:Team{name:"Bournemouth"}) - 
[:Played{home: False, result: "Win"}] -> (matchesAway:Match{HTR: 'H'})
RETURN matchesHome, matchesAway;


// Performance test option for properties set? played

// 9. Write a query to display the final ranking of all the teams based on their total points.
// NEEDS A CORRECTION! CHECK MAIL
MATCH (team:Team) - [:Played{home:False}] -> (matchAway:Match)
WITH [SUM(matchAway.FTAG), team.name] AS awayGoals
MATCH (team:Team) - [:Played{home:True}] -> (matchHome:Match)
WHERE awayGoals[1] = team.name
WITH  [(SUM(matchHome.FTHG) + awayGoals[0]), team.name] AS totalGoals ORDER BY totalGoals[0]
RETURN totalGoals[1] as Team, totalGoals[0] as Points;


MATCH (team:Team) - [played:Played{}] -()
WITH team, COUNT(played.result = "Win") as matchesWon, COUNT(played.result = "Draw") as matchesDrawn
RETURN team.name, matchesWon, matchesDrawn;


MATCH (team:Team) - [played:Played{result: "Win"}] - (matchesWon:Match)
WITH team, matchesWon
OPTIONAL MATCH (team:Team) - [played:Played{result: "Draw"}] - (matchesDrawn:Match)
WITH team, COUNT(matchesWon) as countWon, COUNT(matchesDrawn) as countDrawn
RETURN team.name, countWon, countDrawn;

MATCH (team:Team) - [:Played{result: "Win"}] - (matchesWon:Match)
WITH team, matchesWon
OPTIONAL MATCH (team) - [:Played{result: "Draw"}] - (matchesDrawn:Match)
RETURN team.name, COUNT(DISTINCT matchesWon) as countWon, COUNT(DISTINCT matchesDrawn) as countDrawn;

MATCH (team:Team) - [:Played{result: "Win"}] - (matchesWon:Match)
WITH team, matchesWon
OPTIONAL MATCH (team) - [:Played{result: "Draw"}] - (matchesDrawn:Match)
RETURN team.name, COUNT(DISTINCT matchesWon) *3 + COUNT(DISTINCT matchesDrawn) as ranking;

MATCH (team:Team) - [:Played{result: "Win"}] - (matchesWon:Match)
WITH team, matchesWon
OPTIONAL MATCH (team) - [:Played{result: "Draw"}] - (matchesDrawn:Match)
WITH team, (COUNT(DISTINCT matchesWon)) as countWon, (COUNT(DISTINCT matchesDrawn)) as countDrawn
RETURN team.name as Team, (countWon)*3 + (countDrawn) as TotalPoints
ORDER BY TotalPoints DESC;


// 10. Which team has drawn the most consecutive matches?
MATCH (n1:Team{name:"Arsenal"}) - [r1:Played] -> (n2:Match)
WITH collect(r1.result) as x
RETURN n1,x;

MATCH (n1:Team{name:"Arsenal"}) - [r1:Played] -> (n2:Match)
WITH n1.name as team, collect(r1.result) as x, collect(n2.date) as date
RETURN team, x, date;


MATCH (n1:Team{name:"Arsenal"}) - [r1:Played] -> (n2:Match)
WITH n1.name as team, collect(r1.result) as x, collect(n2.date) as date ORDER BY date
RETURN team, x, date;

MATCH (n1:Team{name:"Arsenal"}) - [r1:Played] -> (n2:Match)
RETURN n1.name, r1.result, n2.date
ORDER BY n2.date;

MATCH (n1:Team{name:"Arsenal"}) - [r1:Played] -> (n2:Match)
WITH n1.name as x, r1.result as y, n2.date as z
ORDER BY n2.date
RETURN distinct x, collect(y), collect(z)


MATCH (n1:Team{name:"Arsenal"}) - [r1:Played] -> (n2:Match)
WITH n1.name as x, r1.result as y, n2.date as z
ORDER BY n2.date
RETURN distinct x, collect(y)


MATCH (n1:Team{name:"Arsenal"}) - [r1:Played] -> (n2:Match)
WITH n1.name as x, r1.result as y, n2.date as z
ORDER BY n2.date
WITH z AS list
RETURN [i IN range(0, size(list)-1)
    WHERE i = "Draft"


;




MATCH (n1:Team) - [r1:Played] -> (n2:Match)
WITH n1.name as x, r1.result as y, n2.date as z
ORDER BY n2.date
RETURN distinct x, collect(y)
ORDER BY x



// https://stackoverflow.com/questions/47671393/neo4j-cypher-return-most-consecutive-passes
MATCH (n1:Team) - [r1:Played] -> (n2:Match)
WITH distinct n1.name as x, r1.result as y, n2.date as z
ORDER BY n2.date
WITH x, collect(y) as p
WITH x, reduce(acc = [], i IN range(0, size(p) - 1) | 
    CASE p[i] = p[i-1]
      WHEN true THEN [j IN range(0, size(acc) - 1) |
          CASE j = size(acc) - 1
            WHEN true THEN acc[j] + [p[i]]
            ELSE acc[j]
          END
        ]
      ELSE acc + [[p[i]]]
    END
  ) AS streaks // (1)
RETURN x, streaks
ORDER BY x;

MATCH (n1:Team) - [r1:Played] -> (n2:Match)
WITH distinct n1.name as x, r1.result as y, n2.date as z
ORDER BY n2.date
WITH x, collect(y) as p
WITH x, reduce(acc = [], i IN range(0, size(p) - 1) | 
    CASE p[i] = p[i-1]
      WHEN true THEN [j IN range(0, size(acc) - 1) |
          CASE j = size(acc) - 1
            WHEN true THEN acc[j] + [p[i]]
            ELSE acc[j]
          END
        ]
      ELSE acc + [[p[i]]]
    END
  ) AS streaks // (1)
UNWIND streaks AS streak
WITH x, streak
WHERE streak[0] = 'Draw'
RETURN x, max(size(streak)) AS consecutivePasses
ORDER BY x


MATCH (n1:Team) - [r1:Played] -> (n2:Match)
WITH distinct n1.name as x, r1.result as y, n2.date as z
ORDER BY n2.date
WITH x, collect(y) as p
WITH x, reduce(acc = [], i IN range(0, size(p) - 1) | 
    CASE p[i] = p[i-1]
      WHEN true THEN [j IN range(0, size(acc) - 1) |
          CASE j = size(acc) - 1
            WHEN true THEN acc[j] + [p[i]]
            ELSE acc[j]
          END
        ]
      ELSE acc + [[p[i]]]
    END
  ) AS streaks // (1)
UNWIND streaks AS streak
WITH x, streak
WHERE streak[0] = 'Draw'
WITH x, max(size(streak)) AS consecutivePasses
RETURN x, consecutivePasses
ORDER BY consecutivePasses DESC


MATCH (n1:Team) - [r1:Played] -> (n2:Match)
WITH distinct n1.name as x, r1.result as y, n2.date as z
ORDER BY n2.date
WITH x, collect(y) as p
WITH x, reduce(acc = [], i IN range(0, size(p) - 1) | 
    CASE p[i] = p[i-1]
      WHEN true THEN [j IN range(0, size(acc) - 1) |
          CASE j = size(acc) - 1
            WHEN true THEN acc[j] + [p[i]]
            ELSE acc[j]
          END
        ]
      ELSE acc + [[p[i]]]
    END
  ) AS streaks // (1)
UNWIND streaks AS streak
WITH x, streak
WHERE streak[0] = 'Draw'
WITH x, max(size(streak)) AS consecutivePasses
RETURN x, consecutivePasses

// Trying to return only teams with max drawns; collect
MATCH (n1:Team) - [r1:Played] -> (n2:Match)
WITH distinct n1.name as x, r1.result as y, n2.date as z
ORDER BY n2.date
WITH x, collect(y) as p
WITH x, reduce(acc = [], i IN range(0, size(p) - 1) | 
    CASE p[i] = p[i-1]
      WHEN true THEN [j IN range(0, size(acc) - 1) |
          CASE j = size(acc) - 1
            WHEN true THEN acc[j] + [p[i]]
            ELSE acc[j]
          END
        ]
      ELSE acc + [[p[i]]]
    END
  ) AS streaks // (1)
UNWIND streaks AS streak
WITH x, streak
WHERE streak[0] = 'Draw'
WITH x, max(size(streak)) AS consecutivePasses
ORDER BY consecutivePasses DESC
WITH [consecutivePasses, x] AS array
WITH collect(array) AS arC, max(array[0]) as maxV
UNWIND arC AS rArr
WHERE rArr[0] = maxV
RETURN rArr



MATCH (n1:Team) - [r1:Played] -> (n2:Match)
WITH distinct n1.name as x, r1.result as y, n2.date as z
ORDER BY n2.date
WITH x, collect(y) as p
WITH x, reduce(acc = [], i IN range(0, size(p) - 1) | 
    CASE p[i] = p[i-1]
      WHEN true THEN [j IN range(0, size(acc) - 1) |
          CASE j = size(acc) - 1
            WHEN true THEN acc[j] + [p[i]]
            ELSE acc[j]
          END
        ]
      ELSE acc + [[p[i]]]
    END
  ) AS streaks // (1)
UNWIND streaks AS streak
WITH x, streak
WHERE streak[0] = 'Draw'
WITH x, max(size(streak)) AS consecutivePasses
ORDER BY consecutivePasses DESC
RETURN consecutivePasses[0]




MATCH (n1:Team) - [r1:Played] -> (n2:Match)
WITH distinct n1.name as x, r1.result as y, n2.date as z
ORDER BY n2.date
WITH x, collect(y) as p
WITH x, reduce(acc = [], i IN range(0, size(p) - 1) | 
    CASE p[i] = p[i-1]
      WHEN true THEN [j IN range(0, size(acc) - 1) |
          CASE j = size(acc) - 1
            WHEN true THEN acc[j] + [p[i]]
            ELSE acc[j]
          END
        ]
      ELSE acc + [[p[i]]]
    END
  ) AS streaks // (1)
UNWIND streaks AS streak
WITH x, streak
WHERE streak[0] = 'Draw'
WITH x, max(size(streak)) AS consecutivePasses
ORDER BY consecutivePasses DESC
WITH [consecutivePasses, x] AS array
WITH array, MAX(array) as point
RETURN array, point



MATCH (n1:Team) - [r1:Played] -> (n2:Match)
WITH distinct n1.name as x, r1.result as y, n2.date as z
ORDER BY n2.date
WITH x, collect(y) as p
WITH x, reduce(acc = [], i IN range(0, size(p) - 1) | 
    CASE p[i] = p[i-1]
      WHEN true THEN [j IN range(0, size(acc) - 1) |
          CASE j = size(acc) - 1
            WHEN true THEN acc[j] + [p[i]]
            ELSE acc[j]
          END
        ]
      ELSE acc + [[p[i]]]
    END
  ) AS streaks // (1)
UNWIND streaks AS streak
WITH x, streak
WHERE streak[0] = 'Draw'
WITH x, max(size(streak)) AS consecutivePasses
ORDER BY consecutivePasses DESC
WITH [consecutivePasses, x] AS array
WITH collect(array) AS arC, max(array[0]) as maxV
RETURN arC, maxV

MATCH (n1:Team) - [r1:Played] -> (n2:Match)
WITH distinct n1.name as x, r1.result as y, n2.date as z
ORDER BY n2.date
WITH x, collect(y) as p
WITH x, reduce(acc = [], i IN range(0, size(p) - 1) | 
    CASE p[i] = p[i-1]
      WHEN true THEN [j IN range(0, size(acc) - 1) |
          CASE j = size(acc) - 1
            WHEN true THEN acc[j] + [p[i]]
            ELSE acc[j]
          END
        ]
      ELSE acc + [[p[i]]]
    END
  ) AS streaks // (1)
UNWIND streaks AS streak
WITH x, streak
WHERE streak[0] = 'Draw'
WITH x, max(size(streak)) AS consecutivePasses
ORDER BY consecutivePasses DESC
WITH [consecutivePasses, x] AS array
WITH collect(array) AS arC, max(array[0]) as maxV
UNWIND arC as ar
WITH ar, maxV
WHERE ar[0] = maxV
RETURN ar

MATCH (n1:Team) - [r1:Played] -> (n2:Match)
WITH distinct n1.name as x, r1.result as y, n2.date as z
ORDER BY n2.date
WITH x, collect(y) as p
WITH x, reduce(acc = [], i IN range(0, size(p) - 1) | 
    CASE p[i] = p[i-1]
      WHEN true THEN [j IN range(0, size(acc) - 1) |
          CASE j = size(acc) - 1
            WHEN true THEN acc[j] + [p[i]]
            ELSE acc[j]
          END
        ]
      ELSE acc + [[p[i]]]
    END
  ) AS streaks // (1)
UNWIND streaks AS streak
WITH x, streak
WHERE streak[0] = 'Draw'
WITH x, max(size(streak)) AS consecutivePasses
ORDER BY consecutivePasses DESC
WITH [consecutivePasses, x] AS array
WITH collect(array) AS arC, max(array[0]) as maxV
UNWIND arC as ar
WITH ar, maxV
WHERE ar[0] = maxV
RETURN ar[1]


MATCH (n1:Team) - [r1:Played] -> (n2:Match)
WITH distinct n1.name as x, r1.result as y, n2.date as z
ORDER BY n2.date
WITH x, collect(y) as p
WITH x, reduce(acc = [], i IN range(0, size(p) - 1) | 
    CASE p[i] = p[i-1]
      WHEN true THEN [j IN range(0, size(acc) - 1) |
          CASE j = size(acc) - 1
            WHEN true THEN acc[j] + [p[i]]
            ELSE acc[j]
          END
        ]
      ELSE acc + [[p[i]]]
    END
  ) AS streaks // (1)
UNWIND streaks AS streak
WITH x, streak
WHERE streak[0] = 'Draw'
WITH x, max(size(streak)) AS consecutivePasses
ORDER BY consecutivePasses DESC
WITH [consecutivePasses, x] AS array
WITH collect(array) AS arC, max(array[0]) as maxV
UNWIND arC as ar
WITH ar, maxV
WHERE ar[0] = maxV
MATCH (l:Team{name:ar[1]})
RETURN l, maxV

MATCH (n1:Team) - [r1:Played] -> (n2:Match)
WITH distinct n1.name as x, r1.result as y, n2.date as z
ORDER BY n2.date
WITH x, collect(y) as p
WITH x, reduce(acc = [], i IN range(0, size(p) - 1) | 
    CASE p[i] = p[i-1]
      WHEN true THEN [j IN range(0, size(acc) - 1) |
          CASE j = size(acc) - 1
            WHEN true THEN acc[j] + [p[i]]
            ELSE acc[j]
          END
        ]
      ELSE acc + [[p[i]]]
    END
  ) AS streaks // (1)
UNWIND streaks AS streak
WITH x, streak
WHERE streak[0] = 'Draw'
WITH x, max(size(streak)) AS consecutivePasses
ORDER BY consecutivePasses DESC
WITH [consecutivePasses, x] AS array
WITH collect(array) AS arC, max(array[0]) as maxV
UNWIND arC as ar
WITH ar, maxV
WHERE ar[0] = maxV
MATCH (l:Team{name:ar[1]})
RETURN l, maxV


MATCH (teams:Team) - [played:Played] -> (matches:Match)
WITH distinct teams.name as teamsNames, played.result as y, matches.date as z
ORDER BY matches.date
WITH teamsNames, collect(y) as teamsNamesCollected
WITH teamsNames, reduce(temporary = [], i IN range(0, size(teamsNamesCollected) - 1) | 
    CASE teamsNamesCollected[i] = teamsNamesCollected[i-1]
      WHEN true THEN [j IN range(0, size(temporary) - 1) |
          CASE j = size(temporary) - 1
            WHEN true THEN temporary[j] + [teamsNamesCollected[i]]
            ELSE temporary[j]
          END
        ]
      ELSE temporary + [[teamsNamesCollected[i]]]
    END
  ) AS streaks // (1)
UNWIND streaks AS streak
WITH teamsNames, streak
WHERE streak[0] = 'Draw'
WITH teamsNames, max(size(streak)) AS consecutiveDraws
ORDER BY consecutiveDraws DESC
WITH [consecutiveDraws, teamsNames] AS consecutiveDrawsArr
WITH collect(consecutiveDrawsArr) AS consecutiveDraws, max(consecutiveDrawsArr[0]) AS maxDrawAmounts
UNWIND consecutiveDraws AS consecutiveDrawsArrUnwind
WITH consecutiveDrawsArrUnwind, maxDrawAmounts
WHERE consecutiveDrawsArrUnwind[0] = maxDrawAmounts
MATCH (winners:Team{name:consecutiveDrawsArrUnwind[1]})
RETURN winners, maxDrawAmounts