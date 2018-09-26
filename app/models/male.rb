class Male < Person
  has_many :children, class_name: "Person", foreign_key: :father_id
end
