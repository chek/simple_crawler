class CreateWebPages < ActiveRecord::Migration[5.0]
  def change
    execute "CREATE TABLE `web_pages` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `url` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
            `content` MEDIUMBLOB DEFAULT NULL,
            `state` INT DEFAULT 0,
            `created_at` datetime DEFAULT NULL,
            `updated_at` datetime DEFAULT NULL,
            PRIMARY KEY (`id`),
            UNIQUE KEY `url_index` (`url`)
          ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8"

  end
end
