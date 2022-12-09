CREATE TABLE IF NOT EXISTS `vms_snowmans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator` varchar(255) DEFAULT NULL,
  `coords` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;