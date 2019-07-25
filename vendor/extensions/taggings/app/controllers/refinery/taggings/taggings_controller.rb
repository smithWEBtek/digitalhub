module Refinery
  module Taggings
    class TaggingsController < ::ApplicationController

      before_action :find_all_taggings
      before_action :find_page

      def index
        filters = [params[:content_type] || "everything", params[:topic_area] || "all topic areas"]
        topic_area_narrative = 'default topic narrative'
        topic_area_narrative = Refinery::Tags::Tag.all.find_by(title: filters[1]).narrative if filters[1] != "all topic areas"
        filtered_taggings = Refinery::Taggings::Tagging.filter_taggings(filters)
        filtered_taggings_json = filtered_taggings.map {|t| TaggingSerializer.new(t).serializable_hash }

        respond_to do |f|
          f.html { present(@page) }
          f.json { render json: {taggings: filtered_taggings_json, topic_area_narrative: topic_area_narrative }}
        end
      end

      def show
        @tagging = ::Refinery::Taggings::Tagging.find(params[:id])
        tagging_json = TaggingSerializer.new(@tagging).serializable_hash
        respond_to do |f|
          f.html { present(@page) }
          f.json { render json: tagging_json}
        end
      end

    protected

      def find_all_taggings
        @taggings = Tagging.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(link_url: "/taggings").first
      end

    end
  end
end