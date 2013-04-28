CREATE TABLE `Task` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `package` varchar(1024) NOT NULL,
  `subroutine` varchar(1024) NOT NULL,
  `status` tinyint unsigned NOT NULL DEFAULT 1,
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `package` (`package`),
  KEY `subroutine` (`subroutine`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
