signature COMP_BASIS =
  sig
    type CompBasis (* CompBasis is a product of environments for the Compile part
                    * of the Kit *)

    type TyName and lvar and con and excon

    type TCEnv          (* lambda type check environment *)
    type EqEnv          (* Environment for elimination of polymorphic equality *)
    type OEnv           (* optimizer env *)
    type mulenv         (* for multiplicity inference *)
    type mularefmap     (* for multiplicity inference *)
    type rse            (* region static environment *)
    type drop_env       (* lvar(fix) -> bool list *) 
    type psi_env        (* lvar -> phsize list  minimal actual ph. sizes for FIX bound lvars *)

    val empty : CompBasis
    val initial : CompBasis
    val plus : CompBasis * CompBasis -> CompBasis
    val eq : CompBasis * CompBasis -> bool
    val enrich : CompBasis * CompBasis -> bool
    val match : CompBasis * CompBasis -> CompBasis
    val restrict : CompBasis * (lvar list * TyName list * con list * excon list) -> 
      CompBasis * lvar list * con list * excon list
    val mk_CompBasis: {TCEnv:TCEnv,EqEnv:EqEnv,OEnv:OEnv,rse:rse,mulenv:mulenv,
		       mularefmap:mularefmap,drop_env:drop_env,psi_env:psi_env} -> CompBasis
    val de_CompBasis: CompBasis -> {TCEnv:TCEnv,EqEnv:EqEnv,OEnv:OEnv,rse:rse,mulenv:mulenv,
				    mularefmap:mularefmap,drop_env:drop_env,psi_env:psi_env}
    type StringTree
    val layout_CompBasis: CompBasis -> StringTree
  end
