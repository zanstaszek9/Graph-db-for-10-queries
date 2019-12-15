
// Remove all nodes
MATCH (n1:Team) - [r1:Played] - (n2:Match) - [r2:Ref] - (n3:Referee) DETACH DELETE n1, r1, n2, r2, n3;



// Remove all UNIQUE constaints
DROP CONSTRAINT ON (n1:Team) ASSERT n1.name IS UNIQUE;
DROP CONSTRAINT ON (n1:Referee) ASSERT n1.name IS UNIQUE;



DROP INDEX ON:Match(FTHG);
DROP INDEX ON:Match(FTAG);
DROP INDEX ON:Played(result);

// Sanity check
MATCH (n) - [r]-() RETURN COUNT(DISTINCT n), COUNT(DISTINCT r)