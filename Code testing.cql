
// Creating Teams
LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
WITH row LIMIT 10
MERGE (n:Team{
    name:row.HomeTeam
})
RETURN n;

LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
WITH row LIMIT 10
MERGE (n:Team{
    name:row.AwayTeam
})
RETURN n;

MATCH (n) RETURN n;

// Deleting Teams
// MATCH (n:Team) DETACH DELETE n;


// Creating Match

LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
WITH row LIMIT 10
WITH SPLIT(row.Date, '/') AS list, row
MERGE (n:Match{
    Date:date((list[2] + '-' + list[1] + '-' + list[0])),
    FTHG:row.FTHG,
    FTAG:row.FTAG,
    FTR:row.FTR,
    HTR:row.HTR
})
RETURN n;


// Deleting Matches
// MATCH (n:Match) DETACH DELETE n;


LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
WITH row LIMIT 10
MERGE (n:Referee{
    Name:row.Referee
})
RETURN n;



LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
MATCH (n1:Referee), (n2{code:row.Referee})
WHERE n1.name = n2.Referee
MERGE (n1) -[r:Ref]->(n2)
RETURN n1, n2, r;

LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
MATCH (n1:Referee), (n2:Match)
WHERE n1.name = row.Referee AND n2.Date = row.date
MERGE (n1) -[r:Ref]->(n2)
RETURN n1, n2, r;


LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
MATCH (n1:Referee)
WHERE n1.name = row.Referee 
RETURN n1

LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
MATCH (n1:Referee{Name:row.Referee}), (n2:Match{Date:row.date})
MERGE (n1) -[r:Ref]->(n2)
RETURN n1, n2, r;

LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
MATCH (n1:Referee{Name:row.Referee})
RETURN n1

LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
WITH SPLIT(row.Date, '/') AS list, row
MATCH (n1:Match{Date:date((list[2] + '-' + list[1] + '-' + list[0]))})
RETURN n1

LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
WITH row LIMIT 10
WITH SPLIT(row.Date, '/') AS list, row
MATCH (n1:Referee{Name:row.Referee}), 
        (n2:Match{Date:date((list[2] + '-' + list[1] + '-' + list[0]))})
        
MERGE (n1) -[r:Ref]->(n2)
RETURN *;

// MATCH ()-[r:Ref]-() DETACH DELETE r;



LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
WITH row LIMIT 10
WITH SPLIT(row.Date, '/') AS list, row
MATCH (n1:Referee{Name:row.Referee}), 
        (n2:Match{
    Date:date((list[2] + '-' + list[1] + '-' + list[0])),
    FTHG:row.FTHG,
    FTAG:row.FTAG,
    FTR:row.FTR,
    HTR:row.HTR
})
        
MERGE (n1) -[r:Ref]->(n2)
RETURN *;


LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
WITH SPLIT(row.Date, '/') AS list, row
MATCH (n1:Referee{Name:row.Referee}), 
        (n2:Match{Date:date((list[2] + '-' + list[1] + '-' + list[0]))}),
        
         
WHERE row.Referee = n1.Name
//MERGE (n1) -[r:Ref]->(n2)
RETURN *;




// Delete Referee
// MATCH (n:Referee) DETACH DELETE n;


LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
WITH row LIMIT 10
WITH SPLIT(row.Date, '/') AS list, row
CREATE (n1:Match{
    Date:date((list[2] + '-' + list[1] + '-' + list[0])),
    FTHG:row.FTHG,
    FTAG:row.FTAG,
    FTR:row.FTR,
    HTR:row.HTR
})
MERGE (n2:Referee{
    Name:row.Referee
})
MERGE
(n2)-[r:Ref]->(n1)
RETURN n1, n2, r;

LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
WITH row LIMIT 10
WITH SPLIT(row.Date, '/') AS list, row
CREATE (match1:Match{
    Date:date((list[2] + '-' + list[1] + '-' + list[0])),
    FTHG:row.FTHG,
    FTAG:row.FTAG,
    FTR:row.FTR,
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
MERGE (team1)-[r2:Played{home: True, result: match1.FTHG > match1.FTAG}]->(match1)
MERGE (team2)-[r3:Played{home: False, result: match1.FTHG < match1.FTAG}]->(match1)
RETURN *;

CASE 
WHEN match1.FTHG > match1.FTAG THEN var1 = 'W'
WHEN match1.FTHG < match1.FTAG THEN var1 = 'L'
WHEN match1.FTHG = match1.FTAG THEN var1 = 'D'
ELSE var1 = 'ERROR'
CASE 
WHEN match1.FTHG < match1.FTAG THEN var2 = 'W'
WHEN match1.FTHG > match1.FTAG THEN var2 = 'L'
WHEN match1.FTHG = match1.FTAG THEN var2 = 'D'
ELSE var2 = 'ERROR'


// MATCH (n) DETACH DELETE n;


MATCH (n1:Team) - [played1:Played] ->(n3:Match) <- [played2:Played] -  (n2:Team)  
RETURN played1, played2;


MATCH (n1:Team) - [played1:Played] ->(n3:Match) <- [played2:Played] -  (n2:Team)  
RETURN played1, played2, n3;


MATCH (n1:Team) - [played1:Played] ->(n3:Match) <- [played2:Played] -  (n2:Team)  
WHERE played1.result = false AND played2.result= false
SET played1.result = "Draw"
SET played2.result = "Draw"
RETURN played1, played2;

MATCH (n1:Team) - [played1:Played] ->(n3:Match) <- [played2:Played] -  (n2:Team)  
WHERE played1.result <> "Draw" AND played2.result <> "Draw"
SET played1.result =
CASE 
    WHEN played1.result = True THEN 'Win'
    WHEN played1.result = False THEN 'Lose'
    ELSE played1.result
END
SET played2.result =
CASE 
    WHEN played2.result = True THEN 'Win'
    WHEN played2.result = False THEN 'Lose'
    ELSE played2.result
END
RETURN played1, played2;


MATCH (n1:Team) - [played1:Played] ->(n3:Match) <- [played2:Played] -  (n2:Team)  
WHERE played1.result = true 
RETURN played1, played2;



LOAD CSV WITH HEADERS FROM 
"file:///D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"
AS row
WITH row LIMIT 10
WITH SPLIT(row.Date, '/') AS list, row
CREATE (match1:Match{
    Date:date((list[2] + '-' + list[1] + '-' + list[0])),
    FTHG:row.FTHG,
    FTAG:row.FTAG,
    FTR:row.FTR,
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
RETURN *;

WHEN match1.FTHG > match1.FTAG THEN var1 = 'W'
WHEN match1.FTHG < match1.FTAG THEN var1 = 'L'
WHEN match1.FTHG = match1.FTAG THEN var1 = 'D'
ELSE var1 = 'ERROR'
CASE 
WHEN match1.FTHG < match1.FTAG THEN var2 = 'W'
WHEN match1.FTHG > match1.FTAG THEN var2 = 'L'
WHEN match1.FTHG = match1.FTAG THEN var2 = 'D'
ELSE var2 = 'ERROR'


MERGE (n:Team{
    name:row.HomeTeam
})
MERGE (n:Team{
    name:row.AwayTeam
})


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
WITH row LIMIT 15 
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

// Index creation
CREATE INDEX ON:Team(name);
CREATE INDEX ON:Match(FTHG);
CREATE INDEX ON:Match(FTAG);
CREATE INDEX ON:Played(result);

// Constraints
CREATE CONSTRAINT ON (n1:Team) ASSERT n1.name IS UNIQUE;
CREATE CONSTRAINT ON (n1:Referee) ASSERT n1.name IS UNIQUE;
// DROP CONSTRAINT ON (n1:Team) ASSERT n1.name IS UNIQUE;
// DROP CONSTRAINT ON (n1:Referee) ASSERT n1.name IS UNIQUE;

// CSV filepath:
// "D:/Pobrane/EPL_dataset_for_2019_20_assignment.csv"