class Person < ApplicationRecord
  belongs_to :mother, class_name: "Person"
  belongs_to :father, class_name: "Person"
  has_one :spouse, class_name: :"Person", foreign_key: :spouse_id

  def sisters
    self.siblings.where(type: "Female")
  end

  def brothers
    self.siblings.where(type: "Male")
  end

  def siblings
    self.mother.nil? ? nil : self.mother.children.where.not(id: self.id)
  end

  def sons
    self.children.where(type: "Male")
  end

  def daughters
    self.children.where(type: "Female")
  end

  def sister_in_laws
    self.siblings.where(type: "Male").map {|s| s.spouse}
  end

  def brother_in_laws
    self.siblings.where(type: "Female").map {|s| s.spouse}
  end

  def cousins
    cousins = []
    return nil if (self.mother.nil? && self.father.nil?)
    [self.mother, self.father].map do |p|
      next if p.siblings.nil?
      cousins << p.siblings.map {|s| s.children}
    end
  end

  def parentless?
    self.father.nil? && self.mother.nil?
  end

  def paternal_aunts
    return if self.father.parentless?
    self.father.sisters + self.father.sister_in_laws
  end

  def paternal_uncles
    return if self.father.parentless?
    self.father.brothers + self.father.brother_in_laws
  end

  def maternal_aunts
    return if self.mother.parentless?
    self.mother.sisters + self.mother.sister_in_laws
  end

  def maternal_uncles
    return if self.mother.parentless?
    self.mother.brothers + self.mother.brother_in_laws
  end

  def grand_daughters
    self.grand_children.select{|c| c["type"] == "Female"}
  end

  def grand_sons
    self.grand_children.select{|c| c["type"] == "Male"}
  end

  def grand_children
    self.children.map {|c| c.children}.flatten
  end

end
