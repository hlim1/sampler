-- MySQL dump 10.8
--
-- Host: localhost    Database: sampler
-- ------------------------------------------------------
-- Server version	4.1.7-standard

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE="NO_AUTO_VALUE_ON_ZERO" */;

--
-- Table structure for table `build`
--

DROP TABLE IF EXISTS `build`;
CREATE TABLE `build` (
  `build_id` int(10) unsigned NOT NULL auto_increment,
  `application_name` varchar(50) NOT NULL default '',
  `application_version` varchar(50) NOT NULL default '',
  `application_release` varchar(50) NOT NULL default '',
  `build_distribution` varchar(50) NOT NULL default '',
  `build_date` datetime NOT NULL default '0000-00-00 00:00:00',
  `build_suppress` varchar(255) default NULL,
  PRIMARY KEY  (`build_id`),
  UNIQUE KEY `application_name` (`application_name`,`application_version`,`application_release`,`build_distribution`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `instrumentation`
--

DROP TABLE IF EXISTS `instrumentation`;
CREATE TABLE `instrumentation` (
  `instrumentation_type` enum('branches','returns','scalar-pairs') NOT NULL default 'branches',
  `predicates_per_site` tinyint(3) unsigned NOT NULL default '0',
  PRIMARY KEY  (`instrumentation_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `run`
--

DROP TABLE IF EXISTS `run`;
CREATE TABLE `run` (
  `run_id` varchar(24) NOT NULL default '',
  `build_id` int(10) unsigned NOT NULL default '0',
  `version` varchar(255) default '',
  `sparsity` int(10) unsigned NOT NULL default '0',
  `exit_signal` tinyint(3) unsigned NOT NULL default '0',
  `exit_status` tinyint(3) unsigned NOT NULL default '0',
  `date` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`run_id`),
  KEY `build_id` (`build_id`),
  KEY `run_id` (`run_id`,`build_id`),
  KEY `exit_signal` (`exit_signal`),
  CONSTRAINT `0_2172` FOREIGN KEY (`build_id`) REFERENCES `build` (`build_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `run_suppress`
--

DROP TABLE IF EXISTS `run_suppress`;
CREATE TABLE `run_suppress` (
  `run_id` varchar(24) NOT NULL default '',
  `reason` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`run_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

