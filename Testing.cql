// Sanity Testing - shouold return 380
MATCH (matches:Match)
RETURN COUNT(matches);



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


