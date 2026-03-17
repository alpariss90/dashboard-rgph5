SELECT '📊 debut insertion des donnees dans tlevel1...' AS status;
truncate `tlevel1`;
INSERT INTO `tlevel1`
SELECT * FROM `level1`;
SELECT '📊 debut insertion des donnees dans tlevel1...' AS status;


truncate `tagriculture`;
INSERT INTO `tagriculture` SELECT * FROM `vagriculture`;

truncate `tcaracteristique`;
INSERT INTO `tcaracteristique` SELECT * FROM `vcaracteristique`;

truncate `tdeces`;
INSERT INTO `tdeces` SELECT * FROM `vdeces`;

truncate `televage`;
INSERT INTO `televage` SELECT * FROM `velevage`;
truncate `temigration` ;
INSERT INTO `temigration` SELECT * FROM `vemigration`;

truncate `thabitat`;
INSERT INTO `thabitat` SELECT * FROM `vhabitat`;

truncate `tmenage`;
INSERT INTO `tmenage` SELECT * FROM `vmenage`;


truncate `tstats`;
INSERT INTO `tstats` SELECT * FROM `vstats`;
