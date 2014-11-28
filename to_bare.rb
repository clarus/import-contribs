# Transform the repositories into bare repositories.

# Get the list of contribs.
contribs = Dir.glob("gits/*").map {|name| File.basename(name)}.sort

system("mkdir -p bares")
for contrib in contribs do
  puts contrib
  system("cp -R gits/#{contrib}/.git bares/#{contrib}.git")
  system("cd bares/#{contrib}.git && git config --bool core.bare true")
end
