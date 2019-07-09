require "yaml"
require "json"

path = "./manifests"
Dir.mkdir(path) unless Dir.exist?(path)

Dir.glob("./source/*.yml") do |item|
  manifest = YAML.load_file(item)
  basename = File.basename(item,".*")
  puts basename
  manifest["i18n"].each { |lang|
    manifest_i18n = Marshal.load(Marshal.dump(manifest))
    manifest_i18n["name"] = manifest_i18n["name_i18n"][lang]
    manifest_i18n["description"] = manifest_i18n["description_i18n"][lang]
    manifest_i18n["port"].each { |port, value|
      manifest_i18n["port"][port]["name"] = manifest_i18n["port"][port]["name_i18n"][lang]
      manifest_i18n["port"][port]["name"] = manifest_i18n["port"][port]["description_i18n"][lang]
      manifest_i18n["port"][port].delete("name_i18n")
      manifest_i18n["port"][port].delete("description_i18n")
    }
    manifest_i18n.delete("i18n")
    manifest_i18n.delete("name_i18n")
    manifest_i18n.delete("description_i18n")
    path = "./manifests/" + lang
    Dir.mkdir(path) unless Dir.exist?(path)
    File.open("./manifests/" + lang + "/" + basename + "_" + lang + ".json", "w") do |f|
      f.puts JSON.pretty_generate(manifest_i18n)
    end
  }
  manifest.delete("i18n")
  manifest.delete("name_i18n")
  manifest.delete("description_i18n")
  manifest["port"].each { |port, value|
    manifest["port"][port].delete("name_i18n")
    manifest["port"][port].delete("description_i18n")
  }
  File.open("./manifests/" + File.basename(item,".*") + ".json", "w") do |f|
    f.puts JSON.pretty_generate(manifest)
  end
end
