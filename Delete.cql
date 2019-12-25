
// Remove all nodes
MATCH (n1:Team) - [r1:Played] - (n2:Match) - [r2:Ref] - (n3:Referee) DETACH DELETE n1, r1, n2, r2, n3;
MATCH (n) DETACH DELETE n;


// Remove all UNIQUE constaints
DROP CONSTRAINT ON (n1:Team) ASSERT n1.name IS UNIQUE;
DROP CONSTRAINT ON (n1:Referee) ASSERT n1.name IS UNIQUE;


// Remove indexes
// DROP INDEX ON:Team(name);  // Deleted earlier due to the UNIQUE constraint
DROP INDEX ON:Played(result);

// Sanity check
MATCH (n) - [r]-() RETURN n, r, COUNT(DISTINCT n), COUNT(DISTINCT r);
:schema