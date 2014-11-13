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

# Make individual repositories.
system("mkdir -p gits")
for contrib, folder in contribs do
  puts contrib
  system("cp -R coq-contribs gits/#{contrib}")
  system("cd gits/#{contrib} && git filter-branch --prune-empty --subdirectory-filter #{folder} -- --all")
  # Remove this empty folder:
  system("cd gits/#{contrib} && rmdir -p Nijmegen/CoRN/model/semilattice")
  puts
end

# Do some GC.
puts "Size before GC:"
system("du -sh gits")
for contrib, folder in contribs do
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

# Create the bare repositories.
system("mkdir -p bares")
for contrib, _ in contribs do
  puts contrib
  system("cd gits && git clone --bare #{contrib} ../bares/#{contrib}.git")
  puts
end
