# Generate OPAM packages for the contribs. We suppose that the folder `gits/`
# contains the list of contribs.
require 'erb'

# Get the list of contribs.
contribs = Dir.glob("gits/*").map {|name| File.basename(name)}.sort

versions = {
    "8.4.dev" => [">= \"8.4\" & < \"8.5\"", "v8.4"],
    "dev" => ["= \"dev\"", "trunk"]
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
      "atbr" => "LGPL 3",
      "automata" => "LGPL 2",
      "bdds" => "LGPL 2",
      "bertrand" => "LGPL 2",
      "buchberger" => "LGPL 2",
      "cantor" => "LGPL 2",
      "cats-in-zfc" => "LGPL 2",
      "checker" => "LGPL 2",
      "circuits" => "LGPL 2",
      "coalgebras" => "LGPL 3",
      "coinductive-examples" => "LGPL 2",
      "coinductive-reals" => "LGPL 2",
      "color" => "CeCILL 2",
      "concat" => "LGPL 2",
      "coqoban" => "LGPL 2",
      "corn" => "GPL 2",
      "ctltctl" => "LGPL 2",
      "dblib" => "LGPL 3",
      "demos" => "LGPL 2",
      "dictionaries" => "LGPL 2",
      "distributed-reference-counting" => "LGPL 2",
      "exact-real-arithmetic" => "LGPL 2",
      "exceptions" => "LGPL 2",
      "fairisle" => "LGPL 2",
      "firing-squad" => "LGPL 2",
      "float" => "LGPL 2",
      "fsets" => "LGPL 2",
      "functions-in-zfc" => "LGPL 2",
      "fundamental-arithmetics" => "LGPL 2",
      "graph-basics" => "LGPL 2",
      "graphs" => "LGPL 2",
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
      "izf" => "LGPL 2",
      "lambda" => "LGPL 2",
      "lambek" => "LGPL 2",
      "lc" => "LGPL 2",
      "lin-alg" => "LGPL 2",
      "math-classes" => "LGPL 2",
      "maths" => "LGPL 2",
      "matrices" => "LGPL 2",
      "micromega" => "LGPL 2",
      "mini-compiler" => "LGPL 2",
      "minic" => "LGPL 2",
      "miniml" => "LGPL 2",
      "multiplier" => "LGPL 2",
      "mutual-exclusion" => "LGPL 2",
      "paco" => "BSD 3-clause",
      "paradoxes" => "LGPL 2",
      "param-pi" => "LGPL 2",
      "pautomata" => "LGPL 2",
      "pocklington" => "LGPL 2",
      "presburger" => "LGPL 2",
      "qarith" => "LGPL 2",
      "qarith-stern-brocot" => "LGPL 2",
      "quicksort-complexity" => "Public Domain",
      "railroad-crossing" => "LGPL 2",
      "ramsey" => "LGPL 2",
      "random" => "LGPL 2",
      "rational" => "LGPL 2",
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
      "sudoku" => "LGPL 2",
      "sum-of-two-square" => "LGPL 2",
      "tait" => "LGPL 2",
      "three-gap" => "LGPL 2",
      "tree-automata" => "LGPL 2",
      "tree-diameter" => "LGPL 2",
      "weak-up-to" => "LGPL 2",
      "zfc" => "LGPL 2",
      "zsearch-trees" => "LGPL 2"
    }
    field("License") || licenses[@contrib]
  end
end

# Installation folders, fixed by hand.
install_folders = {
  "aac-tactics" => "aac-tactics",
  "abp" => "ABP",
  "additions" => "Additions",
  "ails" => "AILS",
  "algebra" => "Algebra",
  "amm11262" => "AMM11262",
  "angles" => "angles",
  "area-method" => "area-method",
  "atbr" => "ATBR",
  "automata" => "Automata",
  "axiomatic-abp" => "axiomatic-abp",
  "bdds" => "bdds",
  "bertrand" => "Bertrand",
  "buchberger" => "Buchberger",
  "canon-bdds" => "canon-bdds",
  "cantor" => "Cantor",
  "cats-in-zfc" => "CatsInZFC",
  "ccs" => "ccs",
  "cfgv" => "CFGV",
  "checker" => "Checker",
  "chinese" => "chinese",
  "circuits" => "Circuits",
  "classical-realizability" => "ClassicalRealizability",
  "coalgebras" => "Coalgebras",
  "coinductive-examples" => "CoinductiveExamples",
  "coinductive-reals" => "coinductive-reals",
  "color" => "color",
  "compcert" => "compcert",
  "concat" => "ConCaT",
  "constructive-geometry" => "constructive-geometry",
  "containers" => "containers",
  "continuations" => "continuations",
  "coq-in-coq" => "coq-in-coq",
  "coqoban" => "Coqoban",
  "corn" => "corn",
  "counting" => "counting",
  "cours-de-coq" => "cours-de-coq",
  "ctltctl" => "CTLTCTL",
  "dblib" => "dblib",
  "demos" => "Demos",
  "descente-infinie" => "DescenteInfinie",
  "dictionaries" => "Dictionaries",
  "distributed-reference-counting" => "DistributedReferenceCounting",
  "domain-theory" => "domain-theory",
  "ergo" => "ergo",
  "euclidean-geometry" => "EuclideanGeometry",
  "euler-formula" => "EulerFormula",
  "exact-real-arithmetic" => "ExactRealArithmetic",
  "exceptions" => "exceptions",
  "fairisle" => "Fairisle",
  "fermat4" => "fermat4",
  "finger-tree" => "finger-tree",
  "firing-squad" => "firing-squad",
  "float" => "Float",
  "founify" => "founify",
  "free-groups" => "FreeGroups",
  "fsets" => "FSets",
  "fssec-model" => "fssec-model",
  "functions-in-zfc" => "FunctionsInZFC",
  "fundamental-arithmetics" => "FundamentalArithmetics",
  "gc" => "gc",
  "generic-environments" => "GenericEnvironments",
  "goedel" => "goedel",
  "graph-basics" => "GraphBasics",
  "graphs" => "graphs",
  "group-theory" => "group-theory",
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
  "int-map" => "int-map",
  "ipc" => "ipc",
  "izf" => "IZF",
  "jordan-curve-theorem" => "JordanCurveTheorem",
  "jprover" => "jprover",
  "karatsuba" => "karatsuba",
  "kildall" => "kildall",
  "lambda" => "Lambda",
  "lambek" => "Lambek",
  "lazy-pcf" => "lazy-pcf",
  "lc" => "lc",
  "legacy-field" => "legacy-field",
  "legacy-ring" => "legacy-ring",
  "lemma-over-loading" => "lemma-over-loading",
  "lesniewski-mereology" => "LesniewskiMereology",
  "lin-alg" => "lin-alg",
  "ltl" => "ltl",
  "maple-mode" => "maple-mode",
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
  "nfix" => "nfix",
  "orb-stab" => "orb-stab",
  "otway-rees" => "otway-rees",
  "paco" => "paco",
  "paradoxes" => "Paradoxes",
  "param-pi" => "ParamPi",
  "pautomata" => "PAutomata",
  "persistent-union-find" => "persistent-union-find",
  "pi-calc" => "pi-calc",
  "pocklington" => "Pocklington",
  "presburger" => "presburger",
  "prfx" => "prfx",
  "projective-geometry" => "projective-geometry",
  "pts" => "pts",
  "ptsatr" => "PTSATR",
  "ptsf" => "ptsf",
  "qarith" => "QArith",
  "qarith-stern-brocot" => "QArithSternBrocot",
  "quicksort-complexity" => "quicksort-complexity",
  "railroad-crossing" => "RailroadCrossing",
  "ramsey" => "Ramsey",
  "random" => "Random",
  "rational" => "Rational",
  "recursive-definition" => "recursive-definition",
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
  "subst" => "subst",
  "sudoku" => "Sudoku",
  "sum-of-two-square" => "SumOfTwoSquare",
  "tait" => "Tait",
  "tarski-geometry" => "tarski-geometry",
  "three-gap" => "ThreeGap",
  "topology" => "topology",
  "tortoise-hare-algorithm" => "tortoise-hare-algorithm",
  "tree-automata" => "tree-automata",
  "tree-diameter" => "TreeDiameter",
  "weak-up-to" => "WeakUpTo",
  "zchinese" => "zchinese",
  "zf" => "zf",
  "zfc" => "ZFC",
  "zorns-lemma" => "ZornsLemma",
  "zsearch-trees" => "zsearch-trees"
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
    description = Description.new(contrib)
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
      file << "git: \"git://clarus.io/#{contrib}\##{branch}\""
    end
  end
end
