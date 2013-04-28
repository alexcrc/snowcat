CREATE TABLE `ResultIndex` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `last_change` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `task` varchar(255) NOT NULL,
  `item_id` int(10) NOT NULL,
  `store` varchar(255) NOT NULL default 'mongo',
  `status` tinyint(4) NOT NULL,
  `resource` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  KEY `task` (`task`),
  KEY `last_change` (`last_change`),
  KEY `store` (`store`),
  KEY `resource` (`resource`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
