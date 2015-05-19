require 'award'
require 'pry'

class Item
  attr_accessor :quality, :expires_in

  def initialize(quality, expires_in)
    @quality = quality
    @expires_in = expires_in
    @initial_expires_in = @expires_in
    @initial_quality = @quality
  end

  def adjust_award
  end
end

#So named because 'Normal' conflicted with a superclass
class ExtraNormal < Item

  def adjust_award
    #I was thinking of making a second inheritance just go get rid of this
    #repeated line below, but I think that would make things a lot less clear
    @expires_in = @initial_expires_in - 1

    return if @initial_quality == 0
    @quality = @initial_quality - 1
    @quality -= 1 if @initial_expires_in <= 0
  end
end

class BlueFirst < Item

  def adjust_award
    @expires_in = @initial_expires_in - 1

    return if @initial_quality > 49 
    @quality = @initial_quality + 1
    @quality += 1 if @initial_expires_in <= 0
    @quality = 50 if @initial_expires_in == 0 && @initial_quality == 49
  end
end

class BlueCompare < Item

  def adjust_award
    @expires_in = @initial_expires_in - 1

    return @quality = 0 if @initial_expires_in <= 0
    return if @initial_quality > 49
    @quality = @initial_quality + 1

    if @initial_expires_in < 6
      @quality += 2
    elsif @initial_expires_in < 11
      @quality += 1  
    end
  end
end

class BlueStar < Item
  def adjust_award
    @expires_in = @initial_expires_in - 1

    @quality = @initial_quality - 2
    @quality = @quality - 2 if @initial_expires_in <= 0
    @quality = 0 if @quality < 0
  end
end

DEFAULT_CLASS = Item
SPECIALIZED_CLASSES = {
  'NORMAL ITEM' => ExtraNormal, 'Blue First' => BlueFirst,
   'Blue Compare' => BlueCompare, 'Blue Star' => BlueStar
}

def init (award)
  (SPECIALIZED_CLASSES[award.name] || DEFAULT_CLASS).new(award.quality, award.expires_in)
end

#I kind of wanted to chuck Awards into a class of their own, but I've never worked
#with Ruby's Structs before, and I didn't know if class-ing it would give
#any unintended side-affects on the hypothetical website.
def update_quality(awards)
  awards.each do |award|
    t = init(award)
    t.adjust_award
    award.quality = t.quality
    award.expires_in = t.expires_in
  end
end





