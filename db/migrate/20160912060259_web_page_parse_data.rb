class WebPageParseData < ActiveRecord::Migration[5.0]
  def change
    execute "CREATE TABLE `web_page_parsed_tags` (
            `web_page_id` int(11),
            `tag` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
            `content` text DEFAULT NULL,
            `created_at` datetime DEFAULT NULL,
            `updated_at` datetime DEFAULT NULL
          ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8"
  end
end
