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
    @description = File.read("gits/#{contrib}/description", encoding: "BINARY")
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
    field("License")
  end
end

# Installation folders, fixed by hand.
install_folders = {
  "aac-tactics" => "aac-tactics",
  "abp" => "abp",
  "additions" => "additions",
  "ails" => "ails",
  "algebra" => "algebra",
  "amm11262" => "amm11262",
  "angles" => "angles",
  "area-method" => "area-method",
  "atbr" => "ATBR",
  "automata" => "automata",
  "axiomatic-abp" => "axiomatic-abp",
  "bdds" => "bdds",
  "bertrand" => "bertrand",
  "buchberger" => "buchberger",
  "canon-bdds" => "canon-bdds",
  "cantor" => "Cantor",
  "cats-in-zfc" => "cats-in-zfc",
  "ccs" => "ccs",
  "cfgv" => "CFGV",
  "checker" => "checker",
  "chinese" => "chinese",
  "circuits" => "circuits",
  "classical-realizability" => "classical-realizability",
  "coalgebras" => "Coalgebras",
  "coinductive-examples" => "coinductive-examples",
  "coinductive-reals" => "coinductive-reals",
  "color" => "color",
  "compcert" => "compcert",
  "concat" => "concat",
  "constructive-geometry" => "constructive-geometry",
  "containers" => "containers",
  "continuations" => "continuations",
  "coq-in-coq" => "coq-in-coq",
  "coqoban" => "coqoban",
  "corn" => "corn",
  "counting" => "counting",
  "cours-de-coq" => "cours-de-coq",
  "ctltctl" => "ctltctl",
  "dblib" => "dblib",
  "demos" => "demos",
  "descente-infinie" => "DescenteInfinie",
  "dictionaries" => "dictionaries",
  "distributed-reference-counting" => "distributed-reference-counting",
  "domain-theory" => "domain-theory",
  "ergo" => "ergo",
  "euclidean-geometry" => "euclidean-geometry",
  "euler-formula" => "EulerFormula",
  "exact-real-arithmetic" => "exact-real-arithmetic",
  "exceptions" => "exceptions",
  "fairisle" => "fairisle",
  "fermat4" => "fermat4",
  "finger-tree" => "finger-tree",
  "firing-squad" => "firing-squad",
  "float" => "float",
  "founify" => "founify",
  "free-groups" => "free-groups",
  "fsets" => "fsets",
  "fssec-model" => "fssec-model",
  "functions-in-zfc" => "functions-in-zfc",
  "fundamental-arithmetics" => "FundamentalArithmetics",
  "gc" => "gc",
  "generic-environments" => "GenericEnvironments",
  "goedel" => "goedel",
  "graph-basics" => "graph-basics",
  "graphs" => "graphs",
  "group-theory" => "group-theory",
  "groups" => "groups",
  "hardware" => "hardware",
  "hedges" => "hedges",
  "high-school-geometry" => "high-school-geometry",
  "higman-cf" => "higman-cf",
  "higman-nw" => "higman-nw",
  "higman-s" => "higman-s",
  "historical-examples" => "historical-examples",
  "hoare-tut" => "HoareTut",
  "huffman" => "huffman",
  "icharate" => "icharate",
  "idxassoc" => "idxassoc",
  "ieee754" => "ieee754",
  "int-map" => "int-map",
  "ipc" => "ipc",
  "izf" => "izf",
  "jordan-curve-theorem" => "JordanCurveTheorem",
  "jprover" => "jprover",
  "karatsuba" => "karatsuba",
  "kildall" => "kildall",
  "lambda" => "lambda",
  "lambek" => "lambek",
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
  "maths" => "maths",
  "matrices" => "matrices",
  "micromega" => "micromega",
  "mini-compiler" => "mini-compiler",
  "minic" => "minic",
  "miniml" => "miniml",
  "mod-red" => "mod-red",
  "multiplier" => "multiplier",
  "mutual-exclusion" => "mutual-exclusion",
  "nfix" => "nfix",
  "orb-stab" => "orb-stab",
  "otway-rees" => "otway-rees",
  "paco" => "paco",
  "paradoxes" => "paradoxes",
  "param-pi" => "param-pi",
  "pautomata" => "pautomata",
  "persistent-union-find" => "persistent-union-find",
  "pi-calc" => "pi-calc",
  "pocklington" => "pocklington",
  "presburger" => "presburger",
  "prfx" => "prfx",
  "projective-geometry" => "projective-geometry",
  "pts" => "pts",
  "ptsatr" => "PTSATR",
  "ptsf" => "ptsf",
  "qarith" => "qarith",
  "qarith-stern-brocot" => "qarith-stern-brocot",
  "quicksort-complexity" => "quicksort-complexity",
  "railroad-crossing" => "railroad-crossing",
  "ramsey" => "ramsey",
  "random" => "random",
  "rational" => "rational",
  "recursive-definition" => "recursive-definition",
  "reflexive-first-order" => "ReflexiveFirstOrder",
  "regexp" => "RegExp",
  "relation-algebra" => "relation-algebra",
  "relation-extraction" => "relation-extraction",
  "rem" => "rem",
  "rsa" => "rsa",
  "ruler-compass-geometry" => "RulerCompassGeometry",
  "schroeder" => "schroeder",
  "search-trees" => "search-trees",
  "semantics" => "semantics",
  "shuffle" => "shuffle",
  "smc" => "smc",
  "square-matrices" => "square-matrices",
  "ssreflect" => "ssreflect",
  "stalmarck" => "stalmarck",
  "streams" => "streams",
  "string" => "string",
  "subst" => "subst",
  "sudoku" => "sudoku",
  "sum-of-two-square" => "sum-of-two-square",
  "tait" => "tait",
  "tarski-geometry" => "tarski-geometry",
  "three-gap" => "three-gap",
  "topology" => "topology",
  "tortoise-hare-algorithm" => "tortoise-hare-algorithm",
  "tree-automata" => "tree-automata",
  "tree-diameter" => "tree-diameter",
  "weak-up-to" => "WeakUpTo",
  "zchinese" => "zchinese",
  "zf" => "zf",
  "zfc" => "zfc",
  "zorns-lemma" => "zorns-lemma",
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
      file << renderer.result()
    end
    # `url`
    File.open("#{path}/url", "w") do |file|
      file << "git: \"git://clarus.io/#{contrib}\##{branch}\""
    end
  end
end
