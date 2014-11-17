# Import the unique SVN repository for contribs to individual Git repositories.
# We keep all the history and branches.

# Import the SVN repository to a unique Git repository.
system("git svn clone svn://scm.gforge.inria.fr/svnroot/coq-contribs -s")

# Find the list of contribs.
contribs = Dir.glob("coq-contribs/**/description").map do |description|
  contrib = File.basename(File.dirname(description))
  folder = File.join(File.dirname(description).split("/")[1..-1])
  [contrib, folder]
end.sort

# Create the separated repositories.
system("mkdir -p gits")
for contrib, folder in contribs do
  puts contrib
  puts "cp -R coq-contribs gits/#{contrib}"
  system("cp -R coq-contribs gits/#{contrib}")
  puts
end

# Simplify the history of repositories.
system("mkdir -p gits")
for contrib, folder in contribs do
  puts contrib
  system("cd gits/#{contrib} && git filter-branch --prune-empty --subdirectory-filter #{folder} -- --all")
  for branch in `cd gits/#{contrib} && git branch -r`.split("\n") do
    branch = branch.strip
    # Make the branch a local one.
    system("cd gits/#{contrib} && git branch #{branch} remotes/#{branch}")
    system("cd gits/#{contrib} && git branch -rd #{branch}")
    # Remove this empty folder:
    if File.exists?("gits/#{contrib}/Nijmegen/CoRN/model/semilattice") then
      system("cd gits/#{contrib} && rmdir -p Nijmegen/CoRN/model/semilattice")
    end
    # Remove the branch if the contrib was not existing at this time.
    if `cd gits/#{contrib} && git ls-tree --name-only #{branch} description`.strip == "" then
      system("cd gits/#{contrib} && git branch -D #{branch}")
    end
  end
  puts
end

# Do some GC.
puts "Size before GC:"
system("du -sh gits")
for contrib, _ in contribs do
  puts contrib
  system("cd gits/#{contrib} && rm -rf .git/refs/original/*")
  system("cd gits/#{contrib} && git reflog expire --all --expire-unreachable=0")
  system("cd gits/#{contrib} && git repack -A -d")
  system("cd gits/#{contrib} && git prune")
  system("cd gits/#{contrib} && git gc")
  puts
end
puts "Size after GC:"
system("du -sh gits")
