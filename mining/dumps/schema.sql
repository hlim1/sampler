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
  instrumentation_type enum('branches','returns','scalar-pairs') NOT NULL default 'branches',
  build_date datetime NOT NULL default '0000-00-00 00:00:00',
  suppress varchar(255) default NULL,
  PRIMARY KEY  (build_id),
  UNIQUE KEY application_name (application_name,application_version,application_release),
  KEY instrumentation_type (instrumentation_type),
  CONSTRAINT `0_2119` FOREIGN KEY (`instrumentation_type`) REFERENCES `instrumentation` (`instrumentation_type`)
) TYPE=InnoDB;

--
-- Table structure for table `build_module`
--

DROP TABLE IF EXISTS build_module;
CREATE TABLE build_module (
  build_id int(10) unsigned NOT NULL default '0',
  module_name varchar(255) NOT NULL default '',
  unit_signature varchar(32) NOT NULL default '',
  UNIQUE KEY build_id (build_id,unit_signature,module_name),
  CONSTRAINT `0_2121` FOREIGN KEY (`build_id`) REFERENCES `build` (`build_id`)
) TYPE=InnoDB;

--
-- Table structure for table `build_site`
--

DROP TABLE IF EXISTS build_site;
CREATE TABLE build_site (
  build_id int(10) unsigned NOT NULL default '0',
  unit_signature varchar(32) NOT NULL default '',
  site_order int(10) unsigned NOT NULL default '0',
  source_name varchar(255) NOT NULL default '',
  line_number int(10) unsigned NOT NULL default '0',
  function varchar(255) NOT NULL default '',
  cfg int(10) unsigned default NULL,
  operand_0 varchar(255) NOT NULL default '',
  operand_1 varchar(255) default NULL,
  PRIMARY KEY  (build_id,unit_signature,site_order),
  KEY unit_signature (unit_signature,site_order),
  CONSTRAINT `0_2123` FOREIGN KEY (`build_id`, `unit_signature`) REFERENCES `build_module` (`build_id`, `unit_signature`)
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
  empty tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (run_id),
  KEY build_id (build_id),
  KEY run_id (run_id,build_id),
  KEY exit_signal (exit_signal),
  CONSTRAINT `0_2125` FOREIGN KEY (`build_id`) REFERENCES `build` (`build_id`)
) TYPE=InnoDB;

--
-- Table structure for table `run_sample`
--

DROP TABLE IF EXISTS run_sample;
CREATE TABLE run_sample (
  run_id char(24) NOT NULL default '',
  unit_signature char(32) NOT NULL default '',
  site_order int(10) unsigned NOT NULL default '0',
  predicate tinyint(3) unsigned NOT NULL default '0',
  count int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (run_id,unit_signature,site_order,predicate),
  CONSTRAINT `0_2127` FOREIGN KEY (`run_id`) REFERENCES `run` (`run_id`)
) TYPE=InnoDB;

