// Create Constraints
CREATE CONSTRAINT ON (n1:Team) ASSERT n1.name IS UNIQUE;
CREATE CONSTRAINT ON (n1:Referee) ASSERT n1.name IS UNIQUE;

// Creating indexes
// CREATE INDEX ON:Team(name);  // Existing due to the UNIQUE constraint
CREATE INDEX ON:Played(result);
CREATE INDEX ON:Played(home);
CREATE INDEX ON:Match(date);    // Test the performance!



// MERGE is not not working on complex queries; need to pasted separately
// Creating Nodes
LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
WITH row 
WITH SPLIT(row.Date, '/') AS list, row
// Using CREATE, as Merge can match the values that are existing with same properties values
CREATE (match1:Match{
    date:date((list[2] + '-' + list[1] + '-' + list[0])),
    FTHG:toInteger(row.FTHG),   // Full Time Home (team) Goals
    FTAG:toInteger(row.FTAG),   // Full Time Away (team) Goals
    HTR:row.HTR,                // Half Time Result: H-home, A-away, D-draw
    HS: toInteger(row.HS),      // Home team total shots
    AS: toInteger(row.AS)       // Away team total shots

}) 
MERGE (referee1:Referee{
    name:row.Referee
})
MERGE (team1:Team{
    name:row.HomeTeam
})
MERGE (team2:Team{
    name:row.AwayTeam
})
MERGE (referee1)-[r1:Ref]->(match1)
MERGE (team1)-[r2:Played{home: True}]->(match1)
MERGE (team2)-[r3:Played{home: False}]->(match1)
SET r2.result =
CASE 
    WHEN match1.FTHG > match1.FTAG THEN 'Win'
    WHEN match1.FTHG < match1.FTAG THEN 'Lose'
    WHEN match1.FTHG = match1.FTAG THEN 'Draw'
END
SET r3.result =
CASE 
    WHEN match1.FTHG < match1.FTAG THEN 'Win'
    WHEN match1.FTHG > match1.FTAG THEN 'Lose'
    WHEN match1.FTHG = match1.FTAG THEN 'Draw'
END 
// Returning COUNT for sanity check for amount of rows imported,
// and to prevent lags or freeze due rendering graphical model of database
// Count(match1) should return 380.
RETURN COUNT(match1);



// CSV filepath:
// "D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
