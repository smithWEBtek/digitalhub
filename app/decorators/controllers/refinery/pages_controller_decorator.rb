Refinery::PagesController.class_eval do

  before_action :find_next_event, :only => [:home]

  protected

    def find_next_event
      now = DateTime.now
      now_nozone = DateTime.new(now.year, now.month, now.day, now.hour, now.minute, now.second)
      @next_event = ::Refinery::Events::Event.where("start > ?", now_nozone).order('start ASC').first
    end

end