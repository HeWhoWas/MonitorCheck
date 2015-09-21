#Imports the check files and returns an array of classes that were imported
def import_checks
  existing_classes = ObjectSpace.each_object(Class).to_a
  Dir["#{File.dirname(__FILE__)}/checks/*.rb"].each {|file| require file } #Requires all the check files.
  new_classes = ObjectSpace.each_object(Class).to_a - existing_classes
  new_classes.each do | clazz |
    if clazz.name.start_with?("Base")
      new_classes = new_classes - [clazz]
    end
  end
  new_classes.find_all(&:name)
end

