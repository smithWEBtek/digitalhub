require 'csv'
module EventCsv

  def self.import_csv_data
    csv_text = File.read(Rails.root.join('lib', 'import', 'event.csv'))
    csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')

    images = Dir[Rails.root.join('app', 'assets', 'images', '*')].each do |file|
      if file
        file_path = Rails.root.join(File.path(file))
        image = ::Refinery::Image.create(image: file_path)
      end
    end

    csv.each do |row|
      tag1_id = ::Refinery::Tags::Tag.find_by(title: row['tag1']).id
      tag2_id = ::Refinery::Tags::Tag.find_by(title: row['tag2']).id
      new_event = ::Refinery::Events::Event.create(title: row['title'],
        description: row['description'],
        start: Date.parse(row['start']),
        end: Date.parse(row['end']),
        event_type: row['event_type'],
        address: row['address'],
        city: row['city'],
        state: row['state'],
        zipcode: row['zipcode'],
        registration_link: row['registration_link'],
        location_name: row['location_name'],
        image: Refinery::Image.all.sample
      )

      ::Refinery::Taggings::Tagging.create(tag_id: tag1_id, event_id: new_event.id)
      ::Refinery::Taggings::Tagging.create(tag_id: tag2_id, event_id: new_event.id)
    end
  end

  def self.remove_csv_data
    csv_text = File.read(Rails.root.join('lib', 'import', 'event.csv'))
    csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
    csv.each do |row|
      ::Refinery::Events::Event.find_by(title: row['title']).destroy
    end
  end
end
