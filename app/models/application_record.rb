require 'csv'

class ApplicationRecord < ActiveRecord::Base
  # include AnnouncementCsv
  # include EventCsv
  # include ReportCsv

  self.abstract_class = true

  def self.human_enum_name(enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end

  def self.import_csv_data
    AnnouncementCsv.import_csv_data
    EventCsv.import_csv_data
    ReportCsv.import_csv_data
  end

  def self.remove_csv_data
    AnnouncementCsv.remove_csv_data
    EventCsv.remove_csv_data
    ReportCsv.remove_csv_data
  end
end
