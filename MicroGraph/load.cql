// Load Data in the database

//------- Genes --------//
export AKAFILE=file:///geomicro/data25/Neo4j/ProtClust/get_homologs_v2/database/all.aka

// Constraints
CREATE CONSTRAINT ON (g:Gene) ASSERT g.name IS UNIQUE;
CREATE CONSTRAINT ON (o:Organism) ASSERT o.name IS UNIQUE;

// Index
CREATE INDEX ON :Gene(ncbi_accession);

// Load
USING PERIODIC COMMIT
LOAD CSV FROM
{AKAFILE} AS line FIELDTERMINATOR '\t'
WITH line, SPLIT(line[3], "__") AS ncbi
CREATE (gene:Gene {name: line[1]})
SET gene.description = line[2],
  gene.ncbi_accession = ncbi[0],
  gene.annotation = line[4],
  gene.xref = line[5]

MERGE (org:Organism {name: line[0]})
ON MATCH SET
  org.counter=coalesce(org.counter, 0) + 1

CREATE (gene)-[:FOUND_IN]->(org)
;


//------- Clusters --------//
export TYPEFILE=file:///geomicro/data25/Neo4j/ProtClust/get_homologs_v2/database/all.gene.types

// Constraints
CREATE CONSTRAINT ON (t:Type) ASSERT t.name IS UNIQUE;
CREATE CONSTRAINT ON (c:Cluster) ASSERT c.name IS UNIQUE;

// Load
USING PERIODIC COMMIT
LOAD CSV FROM
{TYPEFILE} AS line FIELDTERMINATOR '\t'

MATCH (gene:Gene {name: line[2]})

MERGE (type:Type {name: line[0]})
ON MATCH SET
  type.counter=coalesce(type.counter, 1) + 1

MERGE (clust: Cluster {name: line[1]})
ON MATCH SET
  clust.counter=coalesce(clust.counter, 1) + 1

MERGE (gene)-[i:IN_CLUST]->(clust)
ON MATCH SET
  i.counter=coalesce(i.counter, 1) + 1

MERGE (clust)-[o:OF_TYPE]->(type)
ON MATCH SET
  o.counter=coalesce(o.counter, 1) + 1
;

// Unlink core from softcore
MATCH (t1:Type {name:"core"})<-[r1]-(c:Cluster)-[r2]->(t2:Type {name:"softcore"})
DELETE r2
RETURN count(c.name);

//------- Annotations --------//

//------- Experiments --------//
