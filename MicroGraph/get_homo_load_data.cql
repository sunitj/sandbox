// AKA File
export AKAFILE=file:///geomicro/data25/Neo4j/ProtClust/get_homologs/database/all.aka

	// Constraint
	CREATE CONSTRAINT ON (g:Gene) ASSERT g.name IS UNIQUE;

	// Load
	USING PERIODIC COMMIT
	LOAD CSV FROM
	{AKAFILE} AS line FIELDTERMINATOR '\t'

	CREATE (gene:Gene {name: line[0]})
	SET gene.description = line[1]
	;

// Blast Output
export BLASTFILE=file:///geomicro/data25/Neo4j/ProtClust/get_homologs/database/all.blastp

	//Constraint
	CREATE CONSTRAINT ON (i:Interested) ASSERT i.name IS UNIQUE;

	// Load
	USING PERIODIC COMMIT
	LOAD CSV FROM
	{BLASTFILE} AS line FIELDTERMINATOR '\t'

	MATCH (gene:Gene {name: line[0]})

	MERGE (i:Interested {name: line[1]})
	SET i.description = line[15]

	CREATE (gene)-[r:HIT]->(i)
	SET r.percent = TOFLOAT(line[3]),
		r.aln_len = TOINT(line[4]),
		r.evalue = TOFLOAT(line[11]),
		r.bit_score = TOFLOAT(line[12]),
		r.coverage = TOFLOAT(line[14])
	;

// Gene Cluster Type
export TYPEFILE=file:///geomicro/data25/Neo4j/ProtClust/get_homologs/database/all.geneType

	//Constraint
	CREATE CONSTRAINT ON (l:Level) ASSERT l.name IS UNIQUE;

	// Load
	USING PERIODIC COMMIT
	LOAD CSV FROM
	{TYPEFILE} AS line FIELDTERMINATOR '\t'

	MATCH (gene:Gene {name: line[1]})

	MERGE (level:Level {name: line[0]})

	CREATE (gene)-[:TYPE]->(level)
	;

// Taxa
export TAXAFILE=file:///geomicro/data25/Neo4j/ProtClust/get_homologs/database/all.taxa

	//CONSTRAINT
	CREATE CONSTRAINT ON (t:Taxa) ASSERT t.name IS UNIQUE;

	//LOAD
	LOAD CSV FROM
	{TAXAFILE} AS line FIELDTERMINATOR '\t'

	MATCH (gene:Gene {name: line[0]})
	MERGE (taxa:Taxa {name: line[1]})

	CREATE (gene)-[:IN]->(taxa)
	;
