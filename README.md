# Import Contribs
Scripts to import the Coq contribs to OPAM.

    ruby import_to_git.rb
    ruby rename.rb
    ruby clean_svn.rb
    ruby generate_opams.rb
    ruby to_bare.rb

The outputs are in `bares/`. They can be uploaded to the [GForge](https://gforge.inria.fr/) with:

    rsync -avz --delete bares/* username@scm.gforge.inria.fr:/git/coq-contribs/
