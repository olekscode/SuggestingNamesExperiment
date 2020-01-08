Class {
	#name : #SuggestingNamesExperiment,
	#superclass : #Object,
	#instVars : [
		'methodsTable',
		'tfidf'
	],
	#category : #SuggestingNamesExperiment
}

{ #category : #public }
SuggestingNamesExperiment >> calculateTfidfScoreForEachWordInMethods [
	| tfidfScores |
	
	tfidfScores := (methodsTable column: 'words') collect: [ :wordsOfAMethod |
		(wordsOfAMethod asSet collect: [ :word |
			word -> (tfidf scoreOf: word in: wordsOfAMethod) ]) asDataSeries ].
	
	"Remove column if it already exists"
	(methodsTable columnNames includes: 'tfidfScores') ifTrue: [ 
		methodsTable removeColumn: 'tfidfScores' ].
	
	methodsTable addColumn: tfidfScores named: 'tfidfScores'
]

{ #category : #'private - filtering data' }
SuggestingNamesExperiment >> filterColumns [
	methodsTable := methodsTable columns: #(id project class selector words).
	
]

{ #category : #public }
SuggestingNamesExperiment >> filterData [
	self filterRows.
	self filterColumns.
]

{ #category : #'private - filtering data' }
SuggestingNamesExperiment >> filterRows [
	methodsTable := methodsTable select: [ :row |
		(self isNotEmpty: row) and: (self isNotAccessor: row) ].
]

{ #category : #'private - filtering data' }
SuggestingNamesExperiment >> isNotAccessor: rowOfMethodsTable [
	| tokenTypesWithoutComments exceptions |
	
	"((rowOfMethodsTable at: 'protocol') = 'accessing')
		ifFalse: [ ^ true ]."
	
	tokenTypesWithoutComments := (rowOfMethodsTable at: 'tokenTypes')
		reject: [ :tokenType | tokenType = 'COM' ].
				
	exceptions := #(
		(RET VAR DOT)
		(VAR ASS ARG DOT)
		(RET STR DOT)
		(RET NUM DOT)
		(RET SYM DOT)
		(RET CHR DOT)
		(RET ARR DOT)
		(RET TRU DOT)
		(RET FLS DOT)
		(RET NIL DOT)
		(RET CLS DOT)
		(RET SLF DOT)
		(RET CVR DOT)).
				
	^ (exceptions includes: tokenTypesWithoutComments asArray) not.
]

{ #category : #'private - filtering data' }
SuggestingNamesExperiment >> isNotEmpty: rowOfMethodsTable [
	^ (rowOfMethodsTable at: 'words') isNotEmpty
		and: (rowOfMethodsTable at: 'tokenTypes') isNotEmpty.
]

{ #category : #public }
SuggestingNamesExperiment >> loadData [
	| wordsTable tokensTable |
	
	methodsTable := self loadMethodsTable.
	wordsTable := self loadWordsTable.
	tokensTable := self loadTokensTable.
	
	methodsTable addColumn: (wordsTable column: 'words').
	methodsTable addColumn: (tokensTable column: 'tokenTypes').
	
	self splitWords.
	self splitTokenTypes.
]

{ #category : #'private - loading data' }
SuggestingNamesExperiment >> loadMethodsTable [
	^ DataFrame readFromCsv: self pathToMethodsTableFile.
]

{ #category : #'private - loading data' }
SuggestingNamesExperiment >> loadTokensTable [
	^ DataFrame readFromCsv: self pathToTokensTableFile.
]

{ #category : #'private - loading data' }
SuggestingNamesExperiment >> loadWordsTable [
	^ DataFrame readFromCsv: self pathToWordsTableFile.
]

{ #category : #accessing }
SuggestingNamesExperiment >> methodsTable [
	^ methodsTable
]

{ #category : #'private - loading data' }
SuggestingNamesExperiment >> pathToDataDirectory [
	^ '/Users/oleks/Documents/Research/2019-sourcecodedata/data' asFileReference
]

{ #category : #'private - loading data' }
SuggestingNamesExperiment >> pathToMethodsTableFile [
	^ self pathToDataDirectory / 'methods.csv'.
]

{ #category : #'private - loading data' }
SuggestingNamesExperiment >> pathToTokensTableFile [
	^ self pathToDataDirectory / 'tokens.csv'.
]

{ #category : #'private - loading data' }
SuggestingNamesExperiment >> pathToWordsTableFile [
	^ self pathToDataDirectory / 'words.csv'.
]

{ #category : #'private - loading data' }
SuggestingNamesExperiment >> splitTokenTypes [
	methodsTable toColumn: 'tokenTypes' applyElementwise: [ :tokenTypes |
		tokenTypes
			ifNil: [ OrderedCollection new ]
			ifNotNil: [ ' ' split: tokenTypes ] ].
]

{ #category : #'private - loading data' }
SuggestingNamesExperiment >> splitWords [
	methodsTable toColumn: 'words' applyElementwise: [ :words |
		words
			ifNil: [ OrderedCollection new ]
			ifNotNil: [ ' ' split: words ] ].
]

{ #category : #public }
SuggestingNamesExperiment >> trainTfidf [
	| documents |
	documents := (methodsTable column: 'words') asOrderedCollection.
	
	tfidf := PGTermFrequencyInverseDocumentFrequency new.
	tfidf trainOn: documents.
]
