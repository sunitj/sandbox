// Load Data in the database

//------- 1 --------//

// Loading the AKA files
export AKAFILE=file:///geomicro/data25/Neo4j/ProtClust/get_homologs_v2/database/all.aka

// Constraint
CREATE CONSTRAINT ON (g:Gene) ASSERT g.name IS UNIQUE;
CREATE CONSTRAINT ON (o:Organism) ASSERT o.name IS UNIQUE;

// Index
CREATE INDEX ON :Gene(ncbi_accession);

// Load
USING PERIODIC COMMIT
LOAD CSV FROM
{AKAFILE} AS line FIELDTERMINATOR '\t'

CREATE (gene:Gene {name: line[1]})
SET gene.description = line[2],
  gene.ncbi_accession = line[3],
  gene.annotation = line[4],
  gene.xref = line[5]

MERGE (org:Organism {name: line[0]})

CREATE (gene)-[:FOUND_IN]->(org)
;


//------- 2 --------//
