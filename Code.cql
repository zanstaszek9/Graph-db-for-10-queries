// Create Constraints
CREATE CONSTRAINT ON (n1:Team) ASSERT n1.name IS UNIQUE;
CREATE CONSTRAINT ON (n1:Referee) ASSERT n1.name IS UNIQUE;

// Creating indexes
// CREATE INDEX ON:Team(name);  // Existing due to the UNIQUE constraint
CREATE INDEX ON:Match(FTHG);
CREATE INDEX ON:Match(FTAG);
CREATE INDEX ON:Played(result);


// MERGE is not not working on complex queries; need to pasted separately
// Creating Nodes
LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
WITH row 
WITH SPLIT(row.Date, '/') AS list, row
// Using CREATE, as Merge can match the values that are existing with same properties' values
CREATE (match1:Match{
    Date:date((list[2] + '-' + list[1] + '-' + list[0])),
    FTHG:row.FTHG,
    FTAG:row.FTAG,
    HTR:row.HTR
}) 
MERGE (referee1:Referee{
    Name:row.Referee
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
RETURN COUNT(match1);


LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
WITH row 
WITH SPLIT(row.Date, '/') AS list, row
// Using CREATE, as Merge can match the values that are existing with same properties' values
CREATE (match1:Match{
    Date:date((list[2] + '-' + list[1] + '-' + list[0])),
    FTHG:row.FTHG,
    FTAG:row.FTAG,
    HTR:row.HTR
}) 
MERGE (referee1:Referee{
    Name:row.Referee
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
RETURN COUNT(match1);



// CSV filepath:
// "D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"