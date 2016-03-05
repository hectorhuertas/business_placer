class Neighborhood < ActiveRecord::Base
  belongs_to :city

  before_save :set_density

  def set_density
    self.density = population.to_f / area.to_f
  end
end
