#reader(lib "docreader.ss" "scribble")
@require["mz.ss"]

@title[#:tag "stxcmp"]{Syntax Object Bindings}

@defproc[(bound-identifier=? [a-id syntax?][b-id syntax?]) boolean?]{

Returns @scheme[#t] if the identifier @scheme[a-id] would bind
@scheme[b-id] (or vice-versa) if the identifiers were substituted in a
suitable expression context, @scheme[#f] otherwise.}


@defproc[(free-identifier=? [a-id syntax?][b-id syntax?]) boolean?]{

Returns @scheme[#t] if @scheme[a-id] and @scheme[b-id] access the same
lexical, module, or top-level binding at @tech{phase level} 0. ``Same
module binding'' means that the identifiers refer to the same original
definition site, not necessarily the @scheme[require] or
@scheme[provide] site. Due to renaming in @scheme[require] and
@scheme[provide], the identifiers may return distinct results with
@scheme[syntax-e].}


@defproc[(free-transformer-identifier=? [a-id syntax?][b-id syntax?]) boolean?]{

Returns @scheme[#t] if @scheme[a-id] and @scheme[b-id] access the same
lexical, module, or top-level binding at @tech{phase level} 1 (see
@secref["id-model"]).}


@defproc[(free-template-identifier=? [a-id syntax?][b-id syntax?]) boolean?]{

Returns @scheme[#t] if @scheme[a-id] and @scheme[b-id] access the same
lexical or module binding at @tech{phase level} -1 (see
@secref["id-model"]).}


@defproc[(free-label-identifier=? [a-id syntax?][b-id syntax?]) boolean?]{

Returns @scheme[#t] if @scheme[a-id] and @scheme[b-id] access the same
lexical or module binding at the @tech{label phase level} (see
@secref["id-model"]).}


@defproc[(check-duplicate-identifier [ids (listof identifier?)])
         (or/c identifier? false/c)]{

Compares each identifier in @scheme[ids] with every other identifier
in the list with @scheme[bound-identifier=?]. If any comparison
returns @scheme[#t], one of the duplicate identifiers is returned (the
first one in @scheme[ids] that is a duplicate), otherwise the result
is @scheme[#f].}


@defproc[(identifier-binding [id-stx syntax?])
         (or/c (one-of 'lexical #f)
               (listof (or/c module-path-index? symbol?)
                       symbol?
                       (or/c module-path-index? symbol?)
                       symbol?
                       boolean?))]{

Returns one of three kinds of values, depending on the binding of
@scheme[id-stx] at @tech{phase level} 0:

@itemize{ 

      @item{The result is @indexed-scheme['lexical] if @scheme[id-stx]
      has a @tech{local binding}.

      @item{The result is a list of five items when @scheme[id-stx]
      has a @tech{module binding}: @scheme[(list source-mod source-id
      nominal-source-mod nominal-source-id et?)].

        @itemize{

        @item{@scheme[source-mod] is a module path index or symbol (see
        @secref["modpathidx"]) that indicates the defining module.}

        @item{@scheme[source-id] is a symbol for the identifier's name
        at its definition site in the source module. This can be
        different from the local name returned by
        @scheme[syntax->datum] for several reasons: the identifier is
        renamed on import, it is renamed on export, or it is
        implicitly renamed because the identifier (or its import) was
        generated by a macro invocation.}

        @item{@scheme[nominal-source-mod] is a module path index or
        symbol (see @secref["modpathidx"]) that indicates the
        module @scheme[require]d into the context of @scheme[id-stx]
        to provide its binding. It can be different from
        @scheme[source-mod] due to a re-export in
        @scheme[nominal-source-mod] of some imported identifier.}

        @item{@scheme[nominal-source-id] is a symbol for the
        identifier's name as exported by
        @scheme[nominal-source-mod]. It can be different from
        @scheme[source-id] due to a renaming @scheme[provide], even if
        @scheme[source-mod] and @scheme[nominal-source-mod] are the
        same.}

        @item{@scheme[et?] is @scheme[#t] if the source definition is
        for-syntax, @scheme[#f] otherwise.}

        }}}

      @item{The result is @scheme[#f] if @scheme[id-stx] 
            has a @tech{top-level binding}.}

      }}

@defproc[(identifier-transformer-binding [id-stx syntax?])
         (or/c (one-of 'lexical #f)
               (listof (or/c module-path-index? symbol?)
                       symbol?
                       (or/c module-path-index? symbol?)
                       symbol?
                       boolean?))]{

Like @scheme[identifier-binding], but that the reported information is
for the identifier's binding in @tech{phase level} 1 (see
@secref["id-model"]).

If the result is @scheme['lexical] for either of
@scheme[identifier-binding] or
@scheme[identifier-transformer-binding], then the result is always
@scheme['lexical] for both.}


@defproc[(identifier-template-binding [id-stx syntax?])
         (or/c (one-of 'lexical #f)
               (listof (or/c module-path-index? symbol?)
                       symbol?
                       (or/c module-path-index? symbol?)
                       symbol?
                       boolean?))]{

Like @scheme[identifier-binding], but that the reported information is
for the identifier's binding in @tech{phase level} -1 (see
@secref["id-model"]).

If the result is @scheme['lexical] for either of
@scheme[identifier-binding] or
@scheme[identifier-template-binding], then the result is always
@scheme['lexical] for both.}


@defproc[(identifier-label-binding [id-stx syntax?])
         (or/c false/c
               (listof (or/c module-path-index? symbol?)
                       symbol?
                       (or/c module-path-index? symbol?)
                       symbol?
                       boolean?))]{

Like @scheme[identifier-binding], but that the reported information is
for the identifier's binding in the @tech{label phase level} (see
@secref["id-model"]). 

Unlike @scheme[identifier-binding], the result cannot be
@scheme['lexical].}
