# Remove the `.git/svn` folders.

# Get the list of contribs.
contribs = Dir.glob("gits/*").map {|name| File.basename(name)}.sort

for contrib in contribs do
  puts contrib
  system("rm -Rf gits/#{contrib}/.git/svn")
end
