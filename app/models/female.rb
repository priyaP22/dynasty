class Female < Person
  has_many :children, class_name: "Person", foreign_key: :mother_id
end
