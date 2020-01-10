Class {
	#name : #NGDatasetBuilder,
	#superclass : #Object,
	#category : #SuggestingNamesExperiment
}

{ #category : #public }
NGDatasetBuilder >> buildDataset [
	| methodsTable wordsTable tokensTable |
	
	methodsTable := self loadMethodsTable.
	wordsTable := self loadWordsTable.
	tokensTable := self loadTokensTable.
	
	methodsTable addColumn: (wordsTable column: 'words').
	methodsTable addColumn: (tokensTable column: 'tokenTypes').
	
	self splitWordsIn: methodsTable.
	self splitTokenTypesIn: methodsTable.
	
	^ methodsTable
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> loadMethodsTable [
	^ DataFrame readFromCsv: self pathToMethodsTableFile.
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> loadTokensTable [
	^ DataFrame readFromCsv: self pathToTokensTableFile.
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> loadWordsTable [
	^ DataFrame readFromCsv: self pathToWordsTableFile.
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> pathToDataDirectory [
	^ '/Users/oleks/Documents/Research/2019-sourcecodedata/data' asFileReference
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> pathToMethodsTableFile [
	^ self pathToDataDirectory / 'methods.csv'.
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> pathToTokensTableFile [
	^ self pathToDataDirectory / 'tokens.csv'.
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> pathToWordsTableFile [
	^ self pathToDataDirectory / 'words.csv'.
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> splitTokenTypesIn: methodsTable [
	methodsTable toColumn: 'tokenTypes' applyElementwise: [ :tokenTypes |
		tokenTypes
			ifNil: [ OrderedCollection new ]
			ifNotNil: [ ' ' split: tokenTypes ] ].
]

{ #category : #'private - loading data' }
NGDatasetBuilder >> splitWordsIn: methodsTable [
	methodsTable toColumn: 'words' applyElementwise: [ :words |
		words
			ifNil: [ OrderedCollection new ]
			ifNotNil: [ ' ' split: words ] ].
]
