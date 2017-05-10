describe "Procfile grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-procfile')

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.procfile')

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.procfile'

  it "tokenizes process-types", ->
    {tokens} = grammar.tokenizeLine("key1: ")
    expect(tokens[0]).toEqual value: "key1", scopes: ["source.procfile", "variable.other.process-type.procfile"]
    expect(tokens[1]).toEqual value: ":", scopes: ["source.procfile", "punctuation.separator.dictionary.key-value.procfile"]
    expect(tokens[2]).toEqual value: " ", scopes: ["source.procfile"]

    {tokens} = grammar.tokenizeLine("key-1: ")
    expect(tokens[0]).toEqual value: "key-1", scopes: ["source.procfile", "variable.other.process-type.procfile"]

    {tokens} = grammar.tokenizeLine("1key_-34: ")
    expect(tokens[0]).toEqual value: "1key_-34: ", scopes: ["source.procfile"]

    {tokens} = grammar.tokenizeLine("ʎǝʞ:")
    expect(tokens[0]).toEqual value: "ʎǝʞ:", scopes: ["source.procfile"]

    {tokens} = grammar.tokenizeLine(" :")
    expect(tokens[0]).toEqual value: " :", scopes: ["source.procfile"]

  it "tokenizes commands", ->
    {tokens} = grammar.tokenizeLine("worker:  bundle exec rake jobs:work")
    expect(tokens[3]).toEqual value: "bundle exec rake jobs:work", scopes: ["source.procfile", "source.shell.command.procfile"]
