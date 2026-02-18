-- menage.level1 source

CREATE OR REPLACE
ALGORITHM = UNDEFINED
VIEW `level1` AS
SELECT
    `l`.`level-1-id` AS `level-1-id`,
    SUBSTR(`l`.`mo_zd`, 1, 1) AS `code_region`,
    `r`.`libelle` AS `region`,
    SUBSTR(`l`.`mo_zd`, 1, 3) AS `code_departement`,
    `d`.`libelle` AS `departement`,
    SUBSTR(`l`.`mo_zd`, 1, 5) AS `code_commune`,
    `c`.`libelle` AS `commune`,
    `l`.`mo_zs` AS `mo_zs`,
    `l`.`mo_zd` AS `mo_zd`,
    `l`.`mo_id` AS `mo_id`
FROM (
        (
            `level-1` `l`
            JOIN `region` `r`
              ON CONVERT(`r`.`code` USING utf8mb4) COLLATE utf8mb4_unicode_ci
               = CONVERT(SUBSTR(`l`.`mo_zd`, 1, 1) USING utf8mb4) COLLATE utf8mb4_unicode_ci
        )
        JOIN `departement` `d`
          ON CONVERT(`d`.`code` USING utf8mb4) COLLATE utf8mb4_unicode_ci
           = CONVERT(SUBSTR(`l`.`mo_zd`, 1, 3) USING utf8mb4) COLLATE utf8mb4_unicode_ci
    )
    JOIN `commune` `c`
      ON CONVERT(`c`.`code` USING utf8mb4) COLLATE utf8mb4_unicode_ci
       = CONVERT(SUBSTR(`l`.`mo_zd`, 1, 5) USING utf8mb4) COLLATE utf8mb4_unicode_ci;


CREATE TABLE `tlevel1` (
  `level-1-id` int NOT NULL,
  `code_region` varchar(1) DEFAULT NULL,
  `region` varchar(50) NOT NULL,
  `code_departement` varchar(3) DEFAULT NULL,
  `departement` varchar(150) NOT NULL,
  `code_commune` varchar(5) DEFAULT NULL,
  `commune` varchar(150) NOT NULL,
  `mo_zs` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `mo_zd` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `mo_id` int DEFAULT NULL,
  PRIMARY KEY (`level-1-id`),
  UNIQUE KEY `mo_zs` (`mo_zs`,`mo_zd`,`mo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;




INSERT INTO `tlevel1`
SELECT * FROM `level1`;
-- menage.vagriculture source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `vagriculture` AS
select
    `l`.`code_region` AS `code_region`,
    `l`.`region` AS `region`,
    `l`.`code_departement` AS `code_departement`,
    `l`.`departement` AS `departement`,
    `l`.`code_commune` AS `code_commune`,
    `l`.`commune` AS `commune`,
    `l`.`mo_zs` AS `mo_zs`,
    `l`.`mo_zd` AS `mo_zd`,
    `l`.`mo_id` AS `mo_id`,
    `a`.`agriculture-id` AS `agriculture-id`,
    `a`.`level-1-id` AS `level-1-id`,
    `a`.`occ` AS `occ`,
    `a`.`ag00` AS `ag00`,
    `a`.`ag0l` AS `ag0l`,
    `a`.`ag02a` AS `ag02a`,
    `a`.`ag02b` AS `ag02b`,
    `a`.`ag02_m` AS `ag02_m`,
    `a`.`ag02c` AS `ag02c`,
    `a`.`ag02d` AS `ag02d`,
    `a`.`ag02e` AS `ag02e`,
    `a`.`ag02f` AS `ag02f`,
    `a`.`ag02ga` AS `ag02e1`,
    `a`.`ag02gb` AS `ag02e2`,
    `a`.`ag02h` AS `ag02h`
from
    (`tlevel1` `l`
join `agriculture` `a`)
where
    (`l`.`level-1-id` = `a`.`level-1-id`);


-- menage.vcaracteristique source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `vcaracteristique` AS
select
    `l`.`code_region` AS `code_region`,
    `l`.`region` AS `region`,
    `l`.`code_departement` AS `code_departement`,
    `l`.`departement` AS `departement`,
    `l`.`code_commune` AS `code_commune`,
    `l`.`commune` AS `commune`,
    `l`.`mo_zs` AS `mo_zs`,
    `l`.`mo_zd` AS `mo_zd`,
    `l`.`mo_id` AS `mo_id`,
    `a`.`caracteristique-id` AS `caracteristique-id`,
    `a`.`level-1-id` AS `level-1-id`,
    `a`.`occ` AS `occ`,
    `a`.`c00` AS `c00`,
    `a`.`c01n` AS `c01n`,
    `a`.`c01p` AS `c01p`,
    `a`.`c01` AS `c01`,
    `a`.`c02` AS `c02`,
    `a`.`c03` AS `c03`,
    `a`.`c04` AS `c04`,
    `a`.`c05` AS `c05`,
    `a`.`c05_jj` AS `c05_jj`,
    `a`.`c05_mm` AS `c05_mm`,
    `a`.`c05_aaaa` AS `c05_aaaa`,
    `a`.`c06` AS `c06`,
    `a`.`c07p` AS `c07p`,
    `a`.`c07r` AS `c07r`,
    `a`.`c07d` AS `c07d`,
    `a`.`c07c` AS `c07c`,
    `a`.`c08a` AS `c08a`,
    `a`.`c08b` AS `c08b`,
    `a`.`c09` AS `c09`,
    `a`.`c10` AS `c10`,
    `a`.`c10_a` AS `c10_a`,
    `a`.`c11` AS `c11`,
    `a`.`c11a` AS `c11a`,
    `a`.`c12` AS `c12`,
 `a`.`c12pra` AS `c12pra`,
 `a`.`c12rra` AS `c12rra`,
 `a`.`c12dra` AS `c12dra`,
 `a`.`c12cra` AS `c12cra`,
 `a`.`c12mra` AS `c12mra`,
 `a`.`c12mra_a` AS `c12mra_a`,
 `a`.`c12lpra` AS `c12lpra`,
`a`.`c13p` AS `c13p`,
`a`.`c13r` AS `c13r`,
`a`.`c13d` AS `c13d`,
`a`.`c13c` AS `c13c`,
`a`.`c13m` AS `c13m`,
`a`.`c13m_a` AS `c13m_a`,
`a`.`c13lp` AS `c13lp`,
    `a`.`c14p` AS `c14p`,
 `a`.`c14r` AS `c14r`,
 `a`.`c14d` AS `c14d`,
 `a`.`c14c` AS `c14c`,
 `a`.`c14m` AS `c14m`,
 `a`.`c14m_a` AS `c14m_a`,
 `a`.`c14lp` AS `c14lp`,
 `a`.`c14me` AS `c14me`,
 `a`.`c14ae` AS `c14ae`,

      `a`.`c16` AS `c16`,
       `a`.`c17` AS `c17`,
    `a`.`c18a` AS `c18a`,
    `a`.`c18b` AS `c18b`,
 `a`.`c18c` AS `c18c`,
 `a`.`c18d` AS `c18d`,
 `a`.`c18e` AS `c18e`,
 `a`.`c18f` AS `c18f`,
 `a`.`c18g` AS `c18g`,
 `a`.`c18h` AS `c18h`,

    `a`.`c19a` AS `c19a`,
`a`.`c19b` AS `c19b`,
`a`.`c19b_a` AS `c19b_a`,
`a`.`c19c` AS `c19c`,
`a`.`c19d` AS `c19d`,
`a`.`c19e` AS `c19e`,
`a`.`c19ec` AS `c19ec`,
`a`.`c19f` AS `c19f`,

    `a`.`c20` AS `c20`,
`a`.`c20a` AS `c20a`,
    `a`.`c21` AS `c21`,
    `a`.`c21a` AS `c21a`,
  `a`.`c21b` AS `c21b`,
    `a`.`c22` AS `c22`,
    `a`.`c23` AS `c23`,
    `a`.`c24` AS `c24`,
    `a`.`c24a` AS `c24a`,
      `a`.`c25` AS `c25`,
    `a`.`c25a` AS `c25a`,
    `a`.`c26` AS `c26`,
    `a`.`c26a` AS `c26a`,
    `a`.`c26b` AS `c26b`,
    `a`.`c27t` AS `c27t`,
    `a`.`c27m` AS `c27m`,
    `a`.`c27f` AS `c27f`,
    `a`.`c28t` AS `c28t`,
 `a`.`c28m` AS `c28m`,
 `a`.`c28f` AS `c28f`,
    `a`.`c29` AS `c29`,
`a`.`c29a` AS `c29a`,
`a`.`c29a_jj` AS `c29a_jj`,
`a`.`c29a_mm` AS `c29a_mm`,
`a`.`c29a_aaaa` AS `c29a_aaaa`,
`a`.`c29b` AS `c29b`,
`a`.`c29c` AS `c29c`,
`a`.`c30t` AS `c30t`,
`a`.`c30m` AS `c30m`,
`a`.`c30f` AS `c30f`,
`a`.`c31t` AS `c31t`,
`a`.`c31m` AS `c31m`,
`a`.`c31f` AS `c31f`,
`a`.`c32` AS `c32`,
`a`.`c33` AS `c33`,
`a`.`ind_status` AS `ind_status`,
    `a`.`membre_controle` AS `membre_controle`,
    `a`.`is_deleted` AS `is_deleted`,

`a`.`temp_nais` AS `temp_nais`,
`a`.`temp_migration` AS `temp_migration`,
`a`.`temp_migration_1` AS `temp_migration_1`,
`a`.`temp_survi` AS `temp_survi`,
`a`.`temp_handicap` AS `temp_handicap`,
`a`.`temp_activite` AS `temp_activite`,
`a`.`temp_education` AS `temp_education`,
`a`.`temp_etat_matrimonial` AS `temp_etat_matrimonial`,
`a`.`temp_fecondite` AS `temp_fecondite`,
`a`.`temp_tic` AS `temp_tic`,
    `t`.`libelle` AS `tranche_age`,
    (case
        when (`a`.`c06` between 19 and 45) then 1
        else 0
    end) AS `age_19_45`
from
    ((`tlevel1` `l`
join `caracteristique` `a`)
left join `tranche_age` `t` on
    ((`a`.`c06` between `t`.`min_value` and `t`.`max_value`)))
where
    (`l`.`level-1-id` = `a`.`level-1-id`);

-- menage.vdeces source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `vdeces` AS
select
    `l`.`code_region` AS `code_region`,
    `l`.`region` AS `region`,
    `l`.`code_departement` AS `code_departement`,
    `l`.`departement` AS `departement`,
    `l`.`code_commune` AS `code_commune`,
    `l`.`commune` AS `commune`,
    `l`.`mo_zs` AS `mo_zs`,
    `l`.`mo_zd` AS `mo_zd`,
    `l`.`mo_id` AS `mo_id`,
    `a`.`deces-id` AS `deces-id`,
    `a`.`level-1-id` AS `level-1-id`,
    `a`.`occ` AS `occ`,
    `a`.`d02` AS `d02`,
`a`.`d02a` AS `d02a`,
    `a`.`d03` AS `d03`,
    `a`.`d04` AS `d04`,
    `a`.`d05` AS `d05`,
`a`.`d06` AS `d06`,
`a`.`d06_a` AS `d06_a`
from
    (`tlevel1` `l`
join `deces` `a`)
where
    (`l`.`level-1-id` = `a`.`level-1-id`);

-- menage.velevage source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `velevage` AS
select
    `l`.`code_region` AS `code_region`,
    `l`.`region` AS `region`,
    `l`.`code_departement` AS `code_departement`,
    `l`.`departement` AS `departement`,
    `l`.`code_commune` AS `code_commune`,
    `l`.`commune` AS `commune`,
    `l`.`mo_zs` AS `mo_zs`,
    `l`.`mo_zd` AS `mo_zd`,
    `l`.`mo_id` AS `mo_id`,
    `a`.`elevage-id` AS `elevage-id`,
    `a`.`level-1-id` AS `level-1-id`,
    `a`.`occ` AS `occ`,
    `a`.`ag03e` AS `ag03e`,
    `a`.`ag03l` AS `ag03l`,
    `a`.`ag03a` AS `ag03a`,
    `a`.`ag03b` AS `ag03b`
from
    (`tlevel1` `l`
join `elevage` `a`)
where
    (`l`.`level-1-id` = `a`.`level-1-id`);



-- menage.vstats source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `vstats` AS
select
    `l`.`code_region` AS `code_region`,
    `l`.`region` AS `region`,
    `l`.`code_departement` AS `code_departement`,
    `l`.`departement` AS `departement`,
    `l`.`code_commune` AS `code_commune`,
    `l`.`commune` AS `commune`,
    `l`.`mo_zs` AS `mo_zs`,
    `l`.`mo_zd` AS `mo_zd`,
    `l`.`mo_id` AS `mo_id`,
    `a`.`stats-id` AS `stats-id`,
    `a`.`level-1-id` AS `level-1-id`,
    `a`.`nb_residents` AS `nb_residents`,
    `a`.`nb_resident_presents` AS `nb_resident_presents`,
    `a`.`nb_rp_h` AS `nb_rp_h`,
    `a`.`nb_rp_f` AS `nb_rp_f`,
`a`.`nb_rp` AS `nb_rp`,
`a`.`nb_rph` AS `nb_rph`,
`a`.`nb_ra` AS `nb_ra`,
`a`.`nb_rah` AS `nb_rah`,
`a`.`nb_raf` AS `nb_raf`,
`a`.`nb_v` AS `nb_v`,
`a`.`nb_vh` AS `nb_vh`,
`a`.`nb_vf` AS `nb_vf`,
`a`.`nb_rv` AS `nb_rv`
from
    (`tlevel1` `l`
join `stats` `a`)
where
    (`l`.`level-1-id` = `a`.`level-1-id`);


-- menage.vemigration source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `vemigration` AS
select
    `l`.`code_region` AS `code_region`,
    `l`.`region` AS `region`,
    `l`.`code_departement` AS `code_departement`,
    `l`.`departement` AS `departement`,
    `l`.`code_commune` AS `code_commune`,
    `l`.`commune` AS `commune`,
    `l`.`mo_zs` AS `mo_zs`,
    `l`.`mo_zd` AS `mo_zd`,
    `l`.`mo_id` AS `mo_id`,
    `a`.`emigration-id` AS `emigration-id`,
    `a`.`level-1-id` AS `level-1-id`,
    `a`.`occ` AS `occ`,
    `a`.`em02` AS `em02`,
    `a`.`em03n` AS `em03n`,
    `a`.`em03p` AS `em03p`,
    `a`.`em04` AS `em04`,
    `a`.`em05` AS `em05`,
    `a`.`em06m` AS `em06m`,
    `a`.`em06a` AS `em06a`,
    `a`.`em07` AS `em07`,
    `a`.`em08` AS `em08`,
    `a`.`em09` AS `em09`,
    `a`.`em09a` AS `em09a`,
    `a`.`em10` AS `em10`,
    `a`.`em11` AS `em11`,
    `a`.`em12` AS `em12`
from
    (`tlevel1` `l`
join `emigration` `a`)
where
    (`l`.`level-1-id` = `a`.`level-1-id`);



-- menage.vhabitat source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `vhabitat` AS
select
    `l`.`code_region` AS `code_region`,
    `l`.`region` AS `region`,
    `l`.`code_departement` AS `code_departement`,
    `l`.`departement` AS `departement`,
    `l`.`code_commune` AS `code_commune`,
    `l`.`commune` AS `commune`,
    `l`.`mo_zs` AS `mo_zs`,
    `l`.`mo_zd` AS `mo_zd`,
    `l`.`mo_id` AS `mo_id`,
    `a`.`habitat-id` AS `habitat-id`,
    `a`.`level-1-id` AS `level-1-id`,
    `a`.`h01` AS `h01`,
    `a`.`h01a` AS `h01a`,
    `a`.`h02` AS `h02`,
    `a`.`h03` AS `h03`,
    `a`.`h03a` AS `h03a`,
    `a`.`h04` AS `h04`,
    `a`.`h04a` AS `h04a`,
    `a`.`h05` AS `h05`,
    `a`.`h05a` AS `h05a`,
    `a`.`h06a` AS `h06a`,
    `a`.`h06b` AS `h06b`,
    `a`.`h07` AS `h07`,
    `a`.`h07a` AS `h07a`,
    `a`.`h07m` AS `h07m`,
    `a`.`h08` AS `h08`,
    `a`.`h08a` AS `h08a`,
    `a`.`h09` AS `h09`,
    `a`.`h09a` AS `h09a`,
    `a`.`h10` AS `h10`,
    `a`.`h10a` AS `h10a`,
    `a`.`h11` AS `h11`,
    `a`.`h11a` AS `h11a`,
    `a`.`h12` AS `h12`,
    `a`.`h12a` AS `h12a`,
    `a`.`h13` AS `h13`,
    `a`.`h13a` AS `h13a`,
    `a`.`h14(1)` AS `h14(1)`,
   `a`.`h14(2)` AS `h14(2)`,
`a`.`h14(3)` AS `h14(3)`,
`a`.`h14(4)` AS `h14(4)`,
`a`.`h14(5)` AS `h14(5)`,
`a`.`h14(6)` AS `h14(6)`,
`a`.`h14(7)` AS `h14(7)`,
`a`.`h14(8)` AS `h14(8)`,
`a`.`h14(9)` AS `h14(9)`,
`a`.`h14(10)` AS `h14(10)`,
`a`.`h14(11)` AS `h14(11)`,
`a`.`h14(12)` AS `h14(12)`,
`a`.`h14(13)` AS `h14(13)`,
`a`.`h14(14)` AS `h14(14)`,
`a`.`h14(15)` AS `h14(15)`,
`a`.`h14(16)` AS `h14(16)`,
`a`.`h14(17)` AS `h14(17)`,
`a`.`h14(18)` AS `h14(18)`,
`a`.`h14(19)` AS `h14(19)`,
`a`.`h14(20)` AS `h14(20)`,
`a`.`h14(21)` AS `h14(21)`,
`a`.`h14(22)` AS `h14(22)`,
`a`.`h14(23)` AS `h14(23)`,
`a`.`h14(24)` AS `h14(24)`,
`a`.`h14(25)` AS `h14(25)`,
`a`.`h14(26)` AS `h14(26)`,
`a`.`h14(27)` AS `h14(27)`,
`a`.`h14(28)` AS `h14(28)`,
`a`.`h14(29)` AS `h14(29)`,
`a`.`h14(30)` AS `h14(30)`,
`a`.`h14(31)` AS `h14(31)`,
`a`.`h14(32)` AS `h14(32)`,
`a`.`h14(33)` AS `h14(33)`,
`a`.`h14(34)` AS `h14(34)`,
`a`.`h14(35)` AS `h14(35)`,
`a`.`h14(36)` AS `h14(36)`,
    `a`.`h1426` AS `h1426`
from
    (`tlevel1` `l`
join `habitat` `a`)
where
    (`l`.`level-1-id` = `a`.`level-1-id`);


-- menage.vmenage source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `vmenage` AS
select
    `l`.`code_region` AS `code_region`,
    `l`.`region` AS `region`,
    `l`.`code_departement` AS `code_departement`,
    `l`.`departement` AS `departement`,
    `l`.`code_commune` AS `code_commune`,
    `l`.`commune` AS `commune`,
    `l`.`mo_zs` AS `mo_zs`,
    `l`.`mo_zd` AS `mo_zd`,
    `l`.`mo_id` AS `mo_id`,
    `a`.`menage-id` AS `menage-id`,
    `a`.`level-1-id` AS `level-1-id`,
    `a`.`id01` AS `id01`,
    `a`.`id02` AS `id02`,
    `a`.`id03` AS `id03`,
    `a`.`id05` AS `id05`,
    `a`.`id06` AS `id06`,
    `a`.`id07` AS `id07`,
     `a`.`id10` AS `id10`,
       `a`.`xm01` AS `xm01`,
        `a`.`xm04` AS `xm04`,
        `a`.`xm06` AS `xm06`,
    `a`.`xm08` AS `xm08`,
`a`.`xm08lo` AS `xm08lo`,
`a`.`xm08la` AS `xm08la`,
    `a`.`xm09` AS `xm09`,
    `a`.`xm10` AS `xm10`,
 `a`.`xm11` AS `xm11`,
 `a`.`xm11_jj` AS `xm11_jj`,
 `a`.`xm11_mm` AS `xm11_mm`,
 `a`.`xm11_aaaa` AS `xm11_aaaa`,

    `a`.`xm12` AS `xm12`,
    `a`.`xm12H` AS `xm12H`,
    `a`.`xm12M` AS `xm12M`,

 `a`.`xm13` AS `xm13`,
 `a`.`xm13_jj` AS `xm13_jj`,
 `a`.`xm13_mm` AS `xm13_mm`,
 `a`.`xm13_aaaa` AS `xm13_aaaa`,

     `a`.`xm14` AS `xm14`,
    `a`.`xm14H` AS `xm14H`,
    `a`.`xm14M` AS `xm14M`,

    `a`.`xm50` AS `xm50`,
    `a`.`xm20` AS `xm20`,
    `a`.`xm30` AS `xm30`,
    `a`.`xm40` AS `xm40`,
    `a`.`xm60` AS `xm60`,
    `a`.`xm41` AS `xm41`,
    `a`.`d00` AS `d00`,
    `a`.`d01` AS `d01`,
    `a`.`ag01` AS `ag01`,
    `a`.`ag01b` AS `ag01b`,
    `a`.`em00` AS `em00`,
    `a`.`em01` AS `em01`,
    `a`.`intro_membre` AS `intro_membre`,
 `a`.`meta_rep` AS `meta_rep`,
    `a`.`meta_start` AS `meta_start`,
    `a`.`meta_end` AS `meta_end`,
    `a`.`meta_last_modify_date` AS `meta_last_modify_date`,
`a`.`meta_duration` AS `meta_duration`,
`a`.`meta_calc_duration` AS `meta_calc_duration`,
`a`.`meta_intro` AS `meta_intro`,
`a`.`ag02i` AS `ag02i`,
`a`.`ag02j` AS `ag02j`,
`a`.`tel_repondant` AS `tel_repondant`
from
    (`tlevel1` `l`
join `menage` `a`)
where
    (`l`.`level-1-id` = `a`.`level-1-id`);

