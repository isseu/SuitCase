class Client < ActiveRecord::Base
  validates :rut, rut: { message: 'no es valido'}
end
