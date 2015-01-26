# Get the list of contribs.
contribs = Dir.glob("gits/*").map {|name| File.basename(name)}.sort

# Remove the `.git/svn` folders.
for contrib in contribs do
  puts contrib
  system("rm -Rf gits/#{contrib}/.git/svn")
end

# Import the branches from `origin/*` to `*`.
for contrib in contribs do
  for branch in `cd gits/#{contrib} && git branch`.split("\n") do
    if /origin\/(.*)/.match(branch) then
      system("cd gits/#{contrib} && git branch #{$1} #{branch}")
      system("cd gits/#{contrib} && git branch -D #{branch}")
    end
  end
end
