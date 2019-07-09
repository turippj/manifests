require "yaml"
require "json"

path = "./manifests"
Dir.mkdir(path) unless Dir.exist?(path)

Dir.glob("./source/*.yml") do |item|
  manifest = YAML.load_file(item)
  basename = File.basename(item,".*")
  puts basename
  manifest["model"] = manifest["model"].to_s(16)
  manifest["i18n"].each{ |lang|
    manifest_i18n = Marshal.load(Marshal.dump(manifest))
    manifest_i18n.delete("i18n")
    manifest_i18n.delete("name_i18n")
    manifest_i18n.delete("description_i18n")
    manifest_i18n.delete("port")
    manifest_i18n["name"] = manifest["name_i18n"][lang]
    manifest_i18n["description"] = manifest["description_i18n"][lang]
    i = 0
    manifest_i18n["port"] = []
    manifest["port"].each { |port, value|
      content = Marshal.load(Marshal.dump(value))
      manifest_i18n["port"][i] = {}
      manifest_i18n["port"][i]["number"] = port
      manifest_i18n["port"][i].merge!(content)
      manifest_i18n["port"][i]["name"] = content["name_i18n"][lang]
      manifest_i18n["port"][i]["description"] = content["description_i18n"][lang]
      manifest_i18n["port"][i].delete("name_i18n")
      manifest_i18n["port"][i].delete("description_i18n")
      i = i + 1
    }
    path = "./manifests/" + lang
    Dir.mkdir(path) unless Dir.exist?(path)
    File.open("./manifests/" + lang + "/" + basename + "_" + lang + ".json", "w") do |f|
      f.puts JSON.pretty_generate(manifest_i18n)
    end
  }

  manifest_full = Marshal.load(Marshal.dump(manifest))
  manifest_full.delete("port")
  i = 0
  manifest_full["port"] = []
  manifest["port"].each{ |port, value|
    content = Marshal.load(Marshal.dump(value))
    manifest_full["port"][i] = {}
    manifest_full["port"][i]["number"] = port
    manifest_full["port"][i].merge!(content)
    i = i + 1
  }
  File.open("./manifests/" + File.basename(item,".*") + ".json", "w") do |f|
    f.puts JSON.pretty_generate(manifest_full)
  end

  path = "./manifests/compress"
  Dir.mkdir(path) unless Dir.exist?(path)
  manifest_compless = manifest_full
  manifest_compless.delete("i18n")
  manifest_compless.delete("name_i18n")
  manifest_compless.delete("description_i18n")
  manifest_compless["port"].each{ |content|
    content.delete("name_i18n")
    content.delete("description_i18n")
  }
  File.open("./manifests/compress/" + File.basename(item,".*") + ".json", "w") do |f|
    f.puts JSON.generate(manifest_full)
  end
end
