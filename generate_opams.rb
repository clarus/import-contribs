# Generate OPAM packages for the contribs. We suppose that the folder `gits/`
# contains the list of contribs.
require 'erb'

# Get the list of contribs.
contribs = Dir.glob("gits/*").map {|name| File.basename(name)}.sort

versions = {
    "8.4.dev" => [">= \"8.4\" & < \"8.5\"", "v8.4"],
    "dev" => [">= \"8.5\"", "trunk"]
}

# Description of a contrib.
class Description
  def initialize(contrib)
    @contrib = contrib
    @description = File.read("gits/#{@contrib}/description", encoding: "BINARY")
  end

  def field(field)
    matches = @description.match(/#{field}\s*\:(.*)$/)
    if matches then
      matches[1].strip
    else
      nil
    end
  end

  def descr
    title = field("Title")
    title += "." if title[-1] != "."
    title
  end

  def license
    # The license, if missing in the `description` file.
    licenses = {
      "aac-tactics" => "LGPL 3",
      "abp" => "LGPL 2",
      "additions" => "LGPL 2",
      "ails" => "LGPL 2",
      "algebra" => "LGPL 2",
      "amm11262" => "LGPL 2",
      "angles" => "Proprietary",
      "area-method" => "Proprietary",
      "atbr" => "LGPL 3",
      "automata" => "LGPL 2",
      "axiomatic-abp" => "Proprietary",
      "bdds" => "LGPL 2",
      "bertrand" => "LGPL 2",
      "buchberger" => "LGPL 2",
      "canon-bdds" => "Proprietary",
      "cantor" => "LGPL 2",
      "cats-in-zfc" => "LGPL 2",
      "ccs" => "Proprietary",
      "checker" => "LGPL 2",
      "chinese" => "Proprietary",
      "circuits" => "LGPL 2",
      "coalgebras" => "LGPL 3",
      "coinductive-examples" => "LGPL 2",
      "coinductive-reals" => "LGPL 2",
      "constructive-geometry" => "Proprietary",
      "containers" => "Proprietary",
      "continuations" => "Proprietary",
      "color" => "CeCILL 2",
      "concat" => "LGPL 2",
      "coq-in-coq" => "LGPL 2",
      "coqoban" => "LGPL 2",
      "corn" => "GPL 2",
      "counting" => "Proprietary",
      "cours-de-coq" => "Proprietary",
      "ctltctl" => "LGPL 2",
      "dblib" => "LGPL 3",
      "demos" => "LGPL 2",
      "dictionaries" => "LGPL 2",
      "distributed-reference-counting" => "LGPL 2",
      "domain-theory" => "Proprietary",
      "ergo" => "Proprietary",
      "exact-real-arithmetic" => "LGPL 2",
      "exceptions" => "LGPL 2",
      "fairisle" => "LGPL 2",
      "fermat4" => "Proprietary",
      "firing-squad" => "LGPL 2",
      "float" => "LGPL 2",
      "fsets" => "LGPL 2",
      "founify" => "Proprietary",
      "fssec-model" => "Proprietary",
      "functions-in-zfc" => "LGPL 2",
      "fundamental-arithmetics" => "LGPL 2",
      "gc" => "Proprietary",
      "goedel" => "Proprietary",
      "graph-basics" => "LGPL 2",
      "graphs" => "LGPL 2",
      "group-theory" => "Proprietary",
      "groups" => "LGPL 2",
      "hardware" => "LGPL 2",
      "hedges" => "LGPL 2",
      "high-school-geometry" => "LGPL 2",
      "higman-cf" => "LGPL 2",
      "higman-nw" => "LGPL 2",
      "higman-s" => "LGPL 2",
      "historical-examples" => "LGPL 2",
      "huffman" => "LGPL 2",
      "icharate" => "LGPL 2",
      "idxassoc" => "BSD with advertising clause",
      "ieee754" => "LGPL 2",
      "int-map" => "LGPL 2",
      "ipc" => "Proprietary",
      "izf" => "LGPL 2",
      "jprover" => "GPL 2",
      "karatsuba" => "Proprietary",
      "kildall" => "Proprietary",
      "lambda" => "LGPL 2",
      "lambek" => "LGPL 2",
      "lazy-pcf" => "Proprietary",
      "lc" => "LGPL 2",
      "legacy-field" => "LGPL 2",
      "legacy-ring" => "LGPL 2",
      "lin-alg" => "LGPL 2",
      "ltl" => "Proprietary",
      "maple-mode" => "Proprietary",
      "math-classes" => "LGPL 2",
      "maths" => "LGPL 2",
      "matrices" => "LGPL 2",
      "micromega" => "LGPL 2",
      "mini-compiler" => "LGPL 2",
      "minic" => "LGPL 2",
      "miniml" => "LGPL 2",
      "multiplier" => "LGPL 2",
      "mutual-exclusion" => "LGPL 2",
      "nfix" => "Proprietary",
      "otway-rees" => "Proprietary",
      "paco" => "BSD 3-clause",
      "paradoxes" => "LGPL 2",
      "param-pi" => "LGPL 2",
      "pautomata" => "LGPL 2",
      "persistent-union-find" => "Proprietary",
      "pi-calc" => "Proprietary",
      "pocklington" => "LGPL 2",
      "presburger" => "LGPL 2",
      "prfx" => "Proprietary",
      "pts" => "Proprietary",
      "projective-geometry" => "Proprietary",
      "qarith" => "LGPL 2",
      "qarith-stern-brocot" => "LGPL 2",
      "quicksort-complexity" => "Public Domain",
      "railroad-crossing" => "LGPL 2",
      "ramsey" => "LGPL 2",
      "random" => "LGPL 2",
      "rational" => "LGPL 2",
      "recursive-definition" => "LGPL 2",
      "relation-algebra" => "LGPL 3",
      "relation-extraction" => "GPL 3",
      "rem" => "LGPL 2",
      "rsa" => "LGPL 2",
      "schroeder" => "LGPL 2",
      "search-trees" => "LGPL 2",
      "shuffle" => "LGPL 2",
      "smc" => "LGPL 2",
      "square-matrices" => "LGPL 2",
      "stalmarck" => "LGPL 2",
      "streams" => "LGPL 2",
      "string" => "LGPL 2",
      "subst" => "Proprietary",
      "sudoku" => "LGPL 2",
      "sum-of-two-square" => "LGPL 2",
      "tait" => "LGPL 2",
      "tarski-geometry" => "Proprietary",
      "tortoise-hare-algorithm" => "Proprietary",
      "three-gap" => "LGPL 2",
      "tree-automata" => "LGPL 2",
      "tree-diameter" => "LGPL 2",
      "weak-up-to" => "LGPL 2",
      "zchinese" => "Proprietary",
      "zf" => "Proprietary",
      "zfc" => "LGPL 2",
      "zsearch-trees" => "LGPL 2"
    }
    field("License") || licenses[@contrib]
  end

  def build
    case @contrib
    when "compcert"
'build: [
  ["./configure" "ia32-linux"]
  [make "-j%{jobs}%"]
]'
    else
'build: [
  ["coq_makefile" "-f" "Make" "-o" "Makefile"]
  [make "-j%{jobs}%"]
  [make "install"]
]'
    end
  end

  def remove
    # Installation folders, fixed by hand.
    install_folders = {
      "aac-tactics" => "aac-tactics",
      "abp" => "ABP",
      "additions" => "Additions",
      "ails" => "AILS",
      "algebra" => "Algebra",
      "amm11262" => "AMM11262",
      "angles" => "Angles",
      "area-method" => "AreaMethod",
      "atbr" => "ATBR",
      "automata" => "Automata",
      "axiomatic-abp" => "AxiomaticABP",
      "bdds" => "bdds",
      "bertrand" => "Bertrand",
      "buchberger" => "Buchberger",
      "canon-bdds" => "canon-bdds",
      "cantor" => "Cantor",
      "cats-in-zfc" => "CatsInZFC",
      "ccs" => "CCS",
      "cfgv" => "CFGV",
      "checker" => "Checker",
      "chinese" => "chinese",
      "circuits" => "Circuits",
      "classical-realizability" => "ClassicalRealizability",
      "coalgebras" => "Coalgebras",
      "coinductive-examples" => "CoinductiveExamples",
      "coinductive-reals" => "coinductive-reals",
      "color" => "color",
      "concat" => "ConCaT",
      "constructive-geometry" => "ConstructiveGeometry",
      "containers" => "Containers",
      "continuations" => "Continuations",
      "coq-in-coq" => "CoqInCoq",
      "coqoban" => "Coqoban",
      "corn" => "corn",
      "counting" => "Counting",
      "cours-de-coq" => "CoursDeCoq",
      "ctltctl" => "CTLTCTL",
      "dblib" => "dblib",
      "demos" => "Demos",
      "descente-infinie" => "DescenteInfinie",
      "dictionaries" => "Dictionaries",
      "distributed-reference-counting" => "DistributedReferenceCounting",
      "domain-theory" => "DomainTheory",
      "ergo" => "ergo",
      "euclidean-geometry" => "EuclideanGeometry",
      "euler-formula" => "EulerFormula",
      "exact-real-arithmetic" => "ExactRealArithmetic",
      "exceptions" => "exceptions",
      "fairisle" => "Fairisle",
      "fermat4" => "Fermat4",
      "finger-tree" => "finger-tree",
      "firing-squad" => "firing-squad",
      "float" => "Float",
      "founify" => "founify",
      "free-groups" => "FreeGroups",
      "fsets" => "FSets",
      "fssec-model" => "FSSecModel",
      "functions-in-zfc" => "FunctionsInZFC",
      "fundamental-arithmetics" => "FundamentalArithmetics",
      "gc" => "GC",
      "generic-environments" => "GenericEnvironments",
      "goedel" => "goedel",
      "graph-basics" => "GraphBasics",
      "graphs" => "graphs",
      "group-theory" => "GroupTheory",
      "groups" => "Groups",
      "hardware" => "hardware",
      "hedges" => "Hedges",
      "high-school-geometry" => "HighSchoolGeometry",
      "higman-cf" => "higman-cf",
      "higman-nw" => "HigmanNW",
      "higman-s" => "HigmanS",
      "historical-examples" => "HistoricalExamples",
      "hoare-tut" => "HoareTut",
      "huffman" => "Huffman",
      "icharate" => "Icharate",
      "idxassoc" => "IdxAssoc",
      "ieee754" => "IEEE754",
      "int-map" => "IntMap",
      "ipc" => "IPC",
      "izf" => "IZF",
      "jordan-curve-theorem" => "JordanCurveTheorem",
      "jprover" => "jprover",
      "karatsuba" => "Karatsuba",
      "kildall" => "Kildall",
      "lambda" => "Lambda",
      "lambek" => "Lambek",
      "lazy-pcf" => "lazyPCF",
      "lc" => "lc",
      "legacy-field" => "LegacyField",
      "legacy-ring" => "LegacyRing",
      "lemma-over-loading" => "lemma-over-loading",
      "lesniewski-mereology" => "LesniewskiMereology",
      "lin-alg" => "lin-alg",
      "ltl" => "LTL",
      "maple-mode" => "MapleMode",
      "markov" => "markov",
      "math-classes" => "MathClasses",
      "maths" => "Maths",
      "matrices" => "Matrices",
      "micromega" => "micromega",
      "mini-compiler" => "MiniCompiler",
      "minic" => "MiniC",
      "miniml" => "MiniML",
      "mod-red" => "ModRed",
      "multiplier" => "multiplier",
      "mutual-exclusion" => "MutualExclusion",
      "nfix" => "Nfix",
      "orb-stab" => "orb-stab",
      "otway-rees" => "OtwayRees",
      "paco" => "Paco",
      "paradoxes" => "Paradoxes",
      "param-pi" => "ParamPi",
      "pautomata" => "PAutomata",
      "persistent-union-find" => "PersistentUnionFind",
      "pi-calc" => "PiCalc",
      "pocklington" => "Pocklington",
      "presburger" => "presburger",
      "prfx" => "Prfx",
      "projective-geometry" => "ProjectiveGeometry",
      "pts" => "PTS",
      "ptsatr" => "PTSATR",
      "ptsf" => "ptsf",
      "qarith" => "QArith",
      "qarith-stern-brocot" => "QArithSternBrocot",
      "quicksort-complexity" => "quicksort-complexity",
      "railroad-crossing" => "RailroadCrossing",
      "ramsey" => "Ramsey",
      "random" => "Random",
      "rational" => "Rational",
      "recursive-definition" => "RecursiveDefinition",
      "reflexive-first-order" => "ReflexiveFirstOrder",
      "regexp" => "RegExp",
      "relation-algebra" => "RelationAlgebra",
      "relation-extraction" => "relation-extraction",
      "rem" => "Rem",
      "rsa" => "RSA",
      "ruler-compass-geometry" => "RulerCompassGeometry",
      "schroeder" => "Schroeder",
      "search-trees" => "search-trees",
      "semantics" => "semantics",
      "shuffle" => "Shuffle",
      "smc" => "smc",
      "square-matrices" => "SquareMatrices",
      "ssreflect" => "Ssreflect",
      "stalmarck" => "stalmarck",
      "streams" => "Streams",
      "string" => "String",
      "subst" => "Subst",
      "sudoku" => "Sudoku",
      "sum-of-two-square" => "SumOfTwoSquare",
      "tait" => "Tait",
      "tarski-geometry" => "TarskiGeometry",
      "three-gap" => "ThreeGap",
      "topology" => "topology",
      "tortoise-hare-algorithm" => "TortoiseHareAlgorithm",
      "tree-automata" => "tree-automata",
      "tree-diameter" => "TreeDiameter",
      "weak-up-to" => "WeakUpTo",
      "zchinese" => "ZChinese",
      "zf" => "ZF",
      "zfc" => "ZFC",
      "zorns-lemma" => "ZornsLemma",
      "zsearch-trees" => "zsearch-trees"
    }
    if install_folders[@contrib] then
      "remove: [\"rm\" \"-R\" \"%{lib}%/coq/user-contrib/#{install_folders[@contrib]}\"]"
    else
      ""
    end
  end

  # A list of additional files.
  def files
    case @contrib
    when "compcert"
      {
        "coq:contrib:compcert.install" =>
'bin: [
  "ccomp"
]
lib: [
  "runtime/libcompcert.a"
]
' }
    else
      {}
    end
  end
end

# Create the packages.
system("mkdir -p packages")
for contrib in contribs do
  puts contrib
  description = Description.new(contrib)
  for version, info in versions do
    coq, branch = info
    # Check that the branch exists.
    exists =
      `cd gits/#{contrib} && git branch`.split("\n").any? do |real_branch|
        real_branch.strip == branch
      end
    if exists then
      path = "packages/coq:contrib:#{contrib}/coq:contrib:#{contrib}.#{version}"
      system("mkdir -p #{path}")
      # `descr`
      File.open("#{path}/descr", "w") do |file|
        file << description.descr
      end
      # `opam`
      renderer = ERB.new(File.read("opam.erb", encoding: "UTF-8"))
      File.open("#{path}/opam", "w") do |file|
        file << renderer.result().gsub(/\n\s*\n/, "\n")
      end
      # `url`
      File.open("#{path}/url", "w") do |file|
        file << "git: \"https://gforge.inria.fr/git/coq-contribs/#{contrib}.git\##{branch}\""
      end
      # `files`
      for name, content in description.files do
        system("mkdir -p #{path}/files")
        File.open("#{path}/files/#{name}", "w") do |file|
          file << content
        end
      end
    end
  end
end
