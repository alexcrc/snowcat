CREATE TABLE `ValueHistory` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `value_id` int(10) unsigned NOT NULL,
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `value` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT "",
  PRIMARY KEY (`id`),
  UNIQUE KEY `value_id_timestamp` (`value_id`, `timestamp`),
  KEY `value_id` (`value_id`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
