// Matches with threshold
MATCH (i:Interested)<-[h:HIT]-(g:Gene),(g)-[:IN]->(t:Taxa),(g)-[:TYPE]->(l:Level)
WHERE h.percent >=50
RETURN i.name AS Gene, count(distinct(t.name)) AS Num_Taxa, collect(distinct(l.name))
ORDER BY Num_Taxa DESC;

//Hits to Core Genome
MATCH (g:Gene)-[:TYPE]->(l:Level {name:"Core"}), (g)-[:HIT]->(i:Interested) RETURN g.name,collect(i.name);

//Hits to Flexible genome
MATCH (g:Gene)-[:TYPE]->(l:Level), (g)-[:HIT]->(i:Interested) WHERE l.name <> "Core" RETURN g.name,collect(i.name);
