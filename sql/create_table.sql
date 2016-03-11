CREATE TABLE `spieler` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(50) NULL DEFAULT NULL,
	`kurz` VARCHAR(3) NULL DEFAULT NULL,
	PRIMARY KEY (`id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `spieltyp` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL,
	`grundtarif` FLOAT NOT NULL,
	PRIMARY KEY (`id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `tische` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NULL DEFAULT NULL,
	`sp1` INT(11) NOT NULL,
	`sp2` INT(11) NOT NULL,
	`sp3` INT(11) NOT NULL,
	`sp4` INT(11) NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `FK_sp1` (`sp1`),
	INDEX `FK_sp2` (`sp2`),
	INDEX `FK_sp3` (`sp3`),
	INDEX `FK_sp4` (`sp4`),
	CONSTRAINT `FK_sp1` FOREIGN KEY (`sp1`) REFERENCES `spieler` (`id`),
	CONSTRAINT `FK_sp2` FOREIGN KEY (`sp2`) REFERENCES `spieler` (`id`),
	CONSTRAINT `FK_sp3` FOREIGN KEY (`sp3`) REFERENCES `spieler` (`id`),
	CONSTRAINT `FK_sp4` FOREIGN KEY (`sp4`) REFERENCES `spieler` (`id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `spiele` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`tischID` INT(11) NOT NULL,
	`typID` INT(11) NOT NULL,
	`preis` FLOAT NULL DEFAULT NULL,
	`timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	INDEX `FK_tisch` (`tischID`),
	INDEX `FK_typ` (`typID`),
	CONSTRAINT `FK_tisch` FOREIGN KEY (`tischID`) REFERENCES `tische` (`id`),
	CONSTRAINT `FK_typ` FOREIGN KEY (`typID`) REFERENCES `spieltyp` (`id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `ergebnis` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`spielID` INT(11) NOT NULL,
	`spielerID` INT(11) NOT NULL,
	`gewinner` TINYINT(1) NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	INDEX `FK_spiel` (`spielID`),
	INDEX `FK_spieler` (`spielerID`),
	CONSTRAINT `FK_spiel` FOREIGN KEY (`spielID`) REFERENCES `spiele` (`id`),
	CONSTRAINT `FK_spieler` FOREIGN KEY (`spielerID`) REFERENCES `spieler` (`id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

ALTER TABLE `tische`
	ADD COLUMN `verantwortlicher` INT(11) NOT NULL AFTER `sp4`;