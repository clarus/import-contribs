# Rename the contribs with the unified naming convention.

# The table of the new names, fixed by hand.
names = {
  "AACTactics" => "aac-tactics",
  "ABP" => "abp",
  "AILS" => "ails",
  "AMM11262" => "amm11262",
  "ATBR" => "atbr",
  "Additions" => "additions",
  "Algebra" => "algebra",
  "Angles" => "angles",
  "AreaMethod" => "area-method",
  "Automata" => "automata",
  "AxiomaticABP" => "axiomatic-abp",
  "BDDs" => "bdds",
  "Bertrand" => "bertrand",
  "Buchberger" => "buchberger",
  "CCS" => "ccs",
  "CFGV" => "cfgv",
  "CTLTCTL" => "ctltctl",
  "CanonBDDs" => "canon-bdds",
  "Cantor" => "cantor",
  "CatsInZFC" => "cats-in-zfc",
  "Checker" => "checker",
  "Chinese" => "chinese",
  "Circuits" => "circuits",
  "ClassicalRealizability" => "classical-realizability",
  "CoLoR" => "color",
  "CoRN" => "corn",
  "Coalgebras" => "coalgebras",
  "CoinductiveExamples" => "coinductive-examples",
  "CoinductiveReals" => "coinductive-reals",
  "CompCert" => "compcert",
  "ConCaT" => "concat",
  "ConstructiveGeometry" => "constructive-geometry",
  "Containers" => "containers",
  "Continuations" => "continuations",
  "CoqInCoq" => "coq-in-coq",
  "Coqoban" => "coqoban",
  "Counting" => "counting",
  "CoursDeCoq" => "cours-de-coq",
  "Dblib" => "dblib",
  "Demos" => "demos",
  "DescenteInfinie" => "descente-infinie",
  "Dictionaries" => "dictionaries",
  "DistributedReferenceCounting" => "distributed-reference-counting",
  "DomainTheory" => "domain-theory",
  "Ergo" => "ergo",
  "EuclideanGeometry" => "euclidean-geometry",
  "EulerFormula" => "euler-formula",
  "ExactRealArithmetic" => "exact-real-arithmetic",
  "Exceptions" => "exceptions",
  "FOUnify" => "founify",
  "FSSecModel" => "fssec-model",
  "FSets" => "fsets",
  "Fairisle" => "fairisle",
  "Fermat4" => "fermat4",
  "FingerTree" => "finger-tree",
  "FiringSquad" => "firing-squad",
  "Float" => "float",
  "FreeGroups" => "free-groups",
  "FunctionsInZFC" => "functions-in-zfc",
  "FundamentalArithmetics" => "fundamental-arithmetics",
  "GC" => "gc",
  "GenericEnvironments" => "generic-environments",
  "Goedel" => "goedel",
  "GraphBasics" => "graph-basics",
  "Graphs" => "graphs",
  "GroupTheory" => "group-theory",
  "Groups" => "groups",
  "Hardware" => "hardware",
  "Hedges" => "hedges",
  "HighSchoolGeometry" => "high-school-geometry",
  "HigmanCF" => "higman-cf",
  "HigmanNW" => "higman-nw",
  "HigmanS" => "higman-s",
  "HistoricalExamples" => "historical-examples",
  "HoareTut" => "hoare-tut",
  "Huffman" => "huffman",
  "IEEE754" => "ieee754",
  "IPC" => "ipc",
  "IZF" => "izf",
  "Icharate" => "icharate",
  "IdxAssoc" => "idxassoc",
  "IntMap" => "int-map",
  "JProver" => "jprover",
  "JordanCurveTheorem" => "jordan-curve-theorem",
  "Karatsuba" => "karatsuba",
  "Kildall" => "kildall",
  "LTL" => "ltl",
  "Lambda" => "lambda",
  "Lambek" => "lambek",
  "LegacyField" => "legacy-field",
  "LegacyRing" => "legacy-ring",
  "LemmaOverloading" => "lemma-over-loading",
  "LesniewskiMereology" => "lesniewski-mereology",
  "LinAlg" => "lin-alg",
  "MapleMode" => "maple-mode",
  "Markov" => "markov",
  "MathClasses" => "math-classes",
  "Maths" => "maths",
  "Matrices" => "matrices",
  "Micromega" => "micromega",
  "MiniC" => "minic",
  "MiniCompiler" => "mini-compiler",
  "MiniML" => "miniml",
  "ModRed" => "mod-red",
  "Multiplier" => "multiplier",
  "MutualExclusion" => "mutual-exclusion",
  "Nfix" => "nfix",
  "OrbStab" => "orb-stab",
  "OtwayRees" => "otway-rees",
  "PAutomata" => "pautomata",
  "PTS" => "pts",
  "PTSATR" => "ptsatr",
  "PTSF" => "ptsf",
  "Paco" => "paco",
  "Paradoxes" => "paradoxes",
  "ParamPi" => "param-pi",
  "PersistentUnionFind" => "persistent-union-find",
  "PiCalc" => "pi-calc",
  "Pocklington" => "pocklington",
  "Presburger" => "presburger",
  "Prfx" => "prfx",
  "ProjectiveGeometry" => "projective-geometry",
  "QArith" => "qarith",
  "QArithSternBrocot" => "qarith-stern-brocot",
  "QuicksortComplexity" => "quicksort-complexity",
  "RSA" => "rsa",
  "RailroadCrossing" => "railroad-crossing",
  "Ramsey" => "ramsey",
  "Random" => "random",
  "Rational" => "rational",
  "RecursiveDefinition" => "recursive-definition",
  "ReflexiveFirstOrder" => "reflexive-first-order",
  "RegExp" => "regexp",
  "RelationAlgebra" => "relation-algebra",
  "RelationExtraction" => "relation-extraction",
  "Rem" => "rem",
  "RulerCompassGeometry" => "ruler-compass-geometry",
  "SMC" => "smc",
  "Schroeder" => "schroeder",
  "SearchTrees" => "search-trees",
  "Semantics" => "semantics",
  "Shuffle" => "shuffle",
  "SquareMatrices" => "square-matrices",
  "Ssreflect" => "ssreflect",
  "Stalmarck" => "stalmarck",
  "Streams" => "streams",
  "String" => "string",
  "Subst" => "subst",
  "Sudoku" => "sudoku",
  "SumOfTwoSquare" => "sum-of-two-square",
  "Tait" => "tait",
  "TarskiGeometry" => "tarski-geometry",
  "ThreeGap" => "three-gap",
  "Topology" => "topology",
  "TortoiseHareAlgorithm" => "tortoise-hare-algorithm",
  "TreeAutomata" => "tree-automata",
  "TreeDiameter" => "tree-diameter",
  "WeakUpTo" => "weak-up-to",
  "ZChinese" => "zchinese",
  "ZF" => "zf",
  "ZFC" => "zfc",
  "ZSearchTrees" => "zsearch-trees",
  "ZornsLemma" => "zorns-lemma",
  "lazyPCF" => "lazy-pcf",
  "lc" => "lc"
}

# Get the list of contribs.
contribs = Dir.glob("gits/*").map {|name| File.basename(name)}.sort

# Rename the repositories.
for contrib in contribs do
  name = names[contrib]
  if name && contrib != name then
    puts "#{contrib} -> #{name}"
    system("mv gits/#{contrib} gits/#{name}")
  end
end
