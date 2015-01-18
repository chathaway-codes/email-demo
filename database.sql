create database maildb;
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP ON maildb.* TO 'mail'@'localhost' IDENTIFIED by 'mailPASSWORD'; 
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP ON maildb.* TO 'mail'@'%' IDENTIFIED by 'mailPASSWORD'; 

use maildb;

CREATE TABLE `aliases`
  (
     `pkid`        SMALLINT(3) NOT NULL auto_increment,
     `mail`        VARCHAR(120) NOT NULL DEFAULT '',
     `destination` VARCHAR(120) NOT NULL DEFAULT '',
     `enabled`     TINYINT(1) NOT NULL DEFAULT '1',
     PRIMARY KEY (`pkid`),
     UNIQUE KEY `mail` (`mail`)
  );

CREATE TABLE `domains`
  (
     `pkid`      SMALLINT(6) NOT NULL auto_increment,
     `domain`    VARCHAR(120) NOT NULL DEFAULT '',
     `transport` VARCHAR(120) NOT NULL DEFAULT 'virtual:',
     `enabled`   TINYINT(1) NOT NULL DEFAULT '1',
     PRIMARY KEY (`pkid`)
  );

CREATE TABLE `users`
  (
     `id`              VARCHAR(128) NOT NULL DEFAULT '',
     `name`            VARCHAR(128) NOT NULL DEFAULT '',
     `uid`             SMALLINT(5) UNSIGNED NOT NULL DEFAULT '5000',
     `gid`             SMALLINT(5) UNSIGNED NOT NULL DEFAULT '5000',
     `home`            VARCHAR(255) NOT NULL DEFAULT '/var/spool/mail/virtual',
     `maildir`         VARCHAR(255) NOT NULL DEFAULT 'blah/',
     `enabled`         TINYINT(1) NOT NULL DEFAULT '1',
     `change_password` TINYINT(1) NOT NULL DEFAULT '1',
     `clear`           VARCHAR(128) NOT NULL DEFAULT 'ChangeMe',
     `crypt`           VARCHAR(128) NOT NULL DEFAULT 'sdtrusfX0Jj66',
     `quota`           VARCHAR(255) NOT NULL DEFAULT '',
     PRIMARY KEY (`id`),
     UNIQUE KEY `id` (`id`)
  ); 


INSERT INTO domains
            (domain)
VALUES      ('localhost'),
            ('localhost.localdomain');

INSERT INTO aliases
            (mail,
             destination)
VALUES      ('postmaster@localhost',
             'root@localhost'),
            ('sysadmin@localhost',
             'root@localhost'),
            ('webmaster@localhost',
             'root@localhost'),
            ('abuse@localhost',
             'root@localhost'),
            ('root@localhost',
             'root@localhost');

INSERT INTO users
            (id,
             name,
             maildir,
             crypt)
VALUES      ('root@localhost',
             'root',
             'root/',
             Encrypt('apassword', Concat('$5$', Md5(Rand()))) ); 

INSERT INTO users (id, name, maildir, crypt) VALUES
	('eve@localhost', 'eve', 'eve/', encrypt('password', CONCAT('$5$', MD5(RAND() ) ) ) ),
	('rob@localhost', 'rob', 'rob/', encrypt('password', CONCAT('$5$', MD5(RAND() ) ) ) );

