class WeighInPromptSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :image_id, :body, :style, :position

  has_one :image
end
