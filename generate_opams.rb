# Generate OPAM packages for the contribs. We suppose that the folder `gits/`
# contains the list of contribs.
require 'erb'

# Get the list of contribs.
contribs = Dir.glob("gits/*").map {|name| File.basename(name)}.sort

versions = {
  "8.4.dev" => [">= \"8.4\" & < \"8.5\"", "v8.4"],
  "dev" => ["= \"dev\"", "trunk"]
}

# Create the packages.
system("mkdir -p packages")
for contrib in contribs do
  puts contrib
  for version, info in versions do
    coq, branch = info
    path = "packages/coq:contrib:#{contrib}/coq:contrib:#{contrib}.#{version}"
    system("mkdir -p #{path}")
    # `descr`
    description = File.read("gits/#{contrib}/description", encoding: "BINARY")
    descr = description.match(/Title\s*\:(.*)$/)[1].strip
    descr += "." if descr[-1] != "."
    File.open("#{path}/descr", "w") do |file|
      file << descr
    end
    # `opam`
    renderer = ERB.new(File.read("opam.erb", encoding: "UTF-8"))
    File.open("#{path}/opam", "w") do |file|
      file << renderer.result()
    end
    # `url`
    File.open("#{path}/url", "w") do |file|
      file << "git: \"git://clarus.io/#{contrib}\##{branch}\""
    end
  end
end
