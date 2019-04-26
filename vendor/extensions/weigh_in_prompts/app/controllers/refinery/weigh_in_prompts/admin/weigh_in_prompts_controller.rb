module Refinery
  module WeighInPrompts
    module Admin
      class WeighInPromptsController < ::Refinery::AdminController

        crudify :'refinery/weigh_in_prompts/weigh_in_prompt'

        def index
          weigh_in_prompts = ::Refinery::WeighInPrompts::WeighInPrompt.all
          all_weigh_in_prompts = weigh_in_prompts.map { |weigh_in_prompt| WeighInPromptSerializer.new(weigh_in_prompt, { :include => [:image] }).serializable_hash }
          render json: all_weigh_in_prompts
        end

        private

        # Only allow a trusted parameter "permit list" through.
        def weigh_in_prompt_params
          params.require(:weigh_in_prompt).permit(:title, :image_id, :body, :style)
        end
      end
    end
  end
end
