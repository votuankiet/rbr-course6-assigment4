class Thing < ActiveRecord::Base
  include Protectable
  validates :name, :presence=>true

  has_many :thing_images, inverse_of: :thing, dependent: :destroy

  #find all thing id that are not linked to the input image
  scope :not_linked, ->(image) { where.not(:id=>ThingImage.select(:thing_id)
                                                          .where(:image=>image)) }
end
