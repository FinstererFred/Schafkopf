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

CREATE TABLE `spiele` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`tischID` INT(11) NOT NULL,
	`typID` INT(11) NOT NULL,
	`preis` FLOAT NULL DEFAULT NULL,
	`timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	INDEX `FK_tisch` (`tischID`),
	INDEX `FK_typ` (`typID`),
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