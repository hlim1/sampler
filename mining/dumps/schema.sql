-- MySQL dump 9.10
--
-- Host: localhost    Database: sampler
-- ------------------------------------------------------
-- Server version	4.0.17-standard

--
-- Table structure for table `instrumentation`
--

DROP TABLE IF EXISTS instrumentation;
CREATE TABLE instrumentation (
  instrumentation_type enum('branches','returns','scalar-pairs') NOT NULL default 'branches',
  predicates_per_site tinyint(3) unsigned NOT NULL default '0',
  PRIMARY KEY  (instrumentation_type)
) TYPE=InnoDB;

--
-- Table structure for table `build`
--

DROP TABLE IF EXISTS build;
CREATE TABLE build (
  build_id int(10) unsigned NOT NULL auto_increment,
  application_name varchar(50) NOT NULL default '',
  application_version varchar(50) NOT NULL default '',
  application_release varchar(50) NOT NULL default '',
  build_date datetime NOT NULL default '0000-00-00 00:00:00',
  build_suppress varchar(255) default NULL,
  PRIMARY KEY  (build_id),
  UNIQUE KEY application_name (application_name,application_version,application_release)
) TYPE=InnoDB;

--
-- Table structure for table `run`
--

DROP TABLE IF EXISTS run;
CREATE TABLE run (
  run_id varchar(24) NOT NULL default '',
  build_id int(10) unsigned NOT NULL default '0',
  version varchar(255) default '',
  sparsity int(10) unsigned NOT NULL default '0',
  exit_signal tinyint(3) unsigned NOT NULL default '0',
  exit_status tinyint(3) unsigned NOT NULL default '0',
  date datetime NOT NULL default '0000-00-00 00:00:00',
  run_suppress varchar(255) default NULL,
  PRIMARY KEY  (run_id),
  KEY build_id (build_id),
  KEY run_id (run_id,build_id),
  KEY exit_signal (exit_signal),
  CONSTRAINT `0_2172` FOREIGN KEY (`build_id`) REFERENCES `build` (`build_id`)
) TYPE=InnoDB;

