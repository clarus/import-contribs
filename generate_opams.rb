# Generate OPAM packages for the contribs. We suppose that the folder `gits/`
# contains the list of contribs.
require 'erb'

# Get the list of contribs.
contribs = Dir.glob("gits/*").map {|name| File.basename(name)}.sort

# Create the packages.
system("mkdir -p packages")
for contrib in contribs do
  puts contrib
  path = "packages/coq:contrib:#{contrib}/coq:contrib:#{contrib}.dev"
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
    file << "git: \"git://ns360531.ip-91-121-163.eu/#{contrib}.git\""
  end
end
