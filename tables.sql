-- DATABASE NAME : rails_nextjs

CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `lastname` varchar(255) DEFAULT NULL,
  `firstname` varchar(255) DEFAULT NULL,
  `emailadd` varchar(255) DEFAULT NULL,
  `mobileno` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT 'USER',
  `secretkey` text,
  `picture` longblob,
  `isactivated` int DEFAULT '0',
  `isblocked` int DEFAULT '0',
  `mailtoken` int DEFAULT '0',
  `qrcodeurl` text,
  `datecreated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `dateupdated` timestamp NULL DEFAULT NULL,
  `otp_secret_key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_lastname_and_firstname` (`lastname`,`firstname`),
  UNIQUE KEY `index_users_on_emailadd` (`emailadd`),
  UNIQUE KEY `index_users_on_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;