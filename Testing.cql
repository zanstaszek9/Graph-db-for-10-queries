// Sanity Testing - shouold return 380
MATCH (matches:Match)
RETURN COUNT(matches);

// Testing Query 1
    // Adding another Team node
    CREATE (n1:Team{name:"Testing", testing:true})
    RETURN n1;

    // Query should 21 records/nodes
    MATCH (n1:Team)
    RETURN n1 AS Team;

    // Delete test elements
    MATCH (n1:Team{name:"Testing", testing:true})
    DETACH DELETE n1;


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
WITH [SUM(matchAway.AS), team.name] AS awayGoals
MATCH (team:Team) - [:Played{home:True}] -> (matchHome:Match)
WHERE awayGoals[1] = team.name 
WITH  [(SUM(matchHome.HS) + awayGoals[0]), team.name] AS totalShots 
// Collecting and Unwinding to use max and min as variables 
WITH collect(totalShots) AS totalShotsCollected, 
    MAX(totalShots[0]) AS maxShots, MIN(totalShots[0]) AS minShots
UNWIND totalShotsCollected AS totalShotsUnwind 
// Getting team names with least and most number of shots to match nodes 
WITH totalShotsUnwind, maxShots, minShots
WHERE totalShotsUnwind[0] = maxShots OR totalShotsUnwind[0] = minShots
MATCH (team:Team{name:totalShotsUnwind[1]})
RETURN team AS Team, totalShotsUnwind[0] AS Shots 
ORDER BY Shots DESC;


// Testing Query 5
    // Adding ref relationship to make two Referee nodes with same number of relationships
    // Add 2 ref
    MATCH (n1:Referee{name: "M Oliver"}), (n2:Match{FTHG: 5})
    WITH n1, n2 LIMIT 2
    MERGE (n1) - [r1:Ref{testing: true}] -> (n2)
    RETURN *;

    // Query should return two nodes: "M Oliver", "A Taylor"
    MATCH (referees:Referee) - [ref:Ref] - (:Match)
    WITH [COUNT(ref), referees] AS countedRef 
    WITH collect(countedRef) as colRef, MAX(countedRef[0]) AS mostRef
    UNWIND colRef AS countedRefU
    WITH countedRefU, mostRef
    WHERE countedRefU[0] = mostRef
    RETURN countedRefU[1] AS Referee, countedRefU[0] AS referedMatches;

    // Deleteing test elements
    MATCH (n1:Referee{name: "M Oliver"}) -[r1:Ref{testing: true}] -> (n2:Match{FTHG: 5})
    DETACH DELETE r1;


