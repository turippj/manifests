require "yaml"
require "securerandom"

models = []
Dir.glob("./source/*.yml"){ |f|
  models.push(File.basename(f)[0..7])
}
puts models

newmodel = "0001" + SecureRandom.hex(2).to_str
until models.include?(newmodel) == false
  newmodel = "0001" + SecureRandom.hex(2).to_str
end

name = ARGV[0]
manifest = {
  model: newmodel,
  name: name,
}

filename = newmodel + "__" + name.gsub(/ /, '_') + ".yml"
File.open("./source/" + filename, "w") do |f|
  f.puts YAML.dump(manifest)
end
