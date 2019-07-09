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
  f.puts "i18n: [en, ja, ja_kana]"
  f.puts "model: 0x" + newmodel
  f.puts "name: &name \"" + name + "\""
  f.puts "name_i18n:\n  en: *name\n  ja: \"\"\n  ja_kana: \"\""
  f.puts "description: &description \"\""
  f.puts "description_i18n:\n  en: *description\n  ja: \"\"\n  ja_kana: \"\""
  f.puts "interface: []"
  f.puts "port:"
  f.puts "  number:"
  f.puts "    type: \"\""
  f.puts "    name: \"\""
  f.puts "    name_i18n:\n      en: *name\n      ja: \"\"\n      ja_kana: \"\""
  f.puts "    description: &description \"\""
  f.puts "    description_i18n:\n      en: *description\n      ja: \"\"\n      ja_kana: \"\""
end
