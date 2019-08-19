require 'csv'
module AnnouncementCsv

  def self.import_csv_data
    csv_text = File.read(Rails.root.join('lib', 'import', 'announcement.csv'))
    csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')


    images = Dir[Rails.root.join('app', 'assets', 'images', '*')].each do |file|
      if file
        file_path = Rails.root.join(File.path(file))
        image = ::Refinery::Image.first_or_create(image: file_path)
      end
    end

    csv.each do |row|
      tag1_id = ::Refinery::Tags::Tag.find_by(title: row['tag1']).id
      tag2_id = ::Refinery::Tags::Tag.find_by(title: row['tag2']).id

      new_announcement = ::Refinery::Announcements::Announcement.first_or_create(title: row[0],
        body: row['body'],
        link: row['link'],
        # image_id: rand(Refinery::Image.last.id),
        image_id: 3,
        published_date: row['published_date']
      )

      ::Refinery::Taggings::Tagging.create(tag_id: tag1_id, announcement_id: new_announcement.id)
      ::Refinery::Taggings::Tagging.create(tag_id: tag2_id, announcement_id: new_announcement.id)
    end
  end

  def self.remove_csv_data
    csv_text = File.read(Rails.root.join('lib', 'import', 'announcement.csv'))
    csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
    csv.each do |row|
      ::Refinery::Announcements::Announcement.find_by(title: row['title']).destroy
    end
  end
end
