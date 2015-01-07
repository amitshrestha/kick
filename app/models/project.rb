class Project < ActiveRecord::Base
  attr_accessible :abstract, :budget, :description, :title
end
