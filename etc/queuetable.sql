CREATE TABLE `TaskQueue` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `last_change` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `task` varchar(255) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `target` varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
  `timestamp_issued` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `timestamp_finalized` timestamp NULL DEFAULT NULL,
  `result_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `result_id` (`result_id`),
  KEY `status` (`status`),
  KEY `target` (`target`),
  KEY `timestamp_issued` (`timestamp_issued`),
  KEY `timestamp_finalized` (`timestamp_finalized`),
  KEY `last_change` (`last_change`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
