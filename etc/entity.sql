CREATE TABLE `Entity` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(8192) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`(767)),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
