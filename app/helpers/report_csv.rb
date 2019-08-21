require 'csv'
module ReportCsv

  def self.import_csv_data
    csv_text = File.read(Rails.root.join('lib', 'import', 'report.csv'))
    csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')

    csv.each do |row|
      tag1_id = ::Refinery::Tags::Tag.find_by(title: row['tag1']).id
      tag2_id = ::Refinery::Tags::Tag.find_by(title: row['tag2']).id
      new_report = ::Refinery::Reports::Report.create( title: row['title'],
        body: row['body'],
        date: row['date'],
        image: Refinery::Image.all.sample
      )

      ::Refinery::Taggings::Tagging.create(tag_id: tag1_id, report_id: new_report.id)
      ::Refinery::Taggings::Tagging.create(tag_id: tag2_id, report_id: new_report.id)
    end
  end

  def self.remove_csv_data
    csv_text = File.read(Rails.root.join('lib', 'import', 'report.csv'))
    csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
    csv.each do |row|
      ::Refinery::Reports::Report.find_by(title: row['title']).destroy
    end
  end
end
