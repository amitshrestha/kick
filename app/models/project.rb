class Project < ActiveRecord::Base
  attr_accessible :abstract, :budget, :description, :title

  def self.expensive
    self.where('budget > ?', 100)
  end

end
