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

{ #category : #private }
SuggestingNamesExperiment >> constructMethodsTableFromMetadata: methodsMetadataTable andWords: wordsTable [
	| methodsTable |
	methodsTable := methodsMetadataTable columns: #(id project class selector).
	methodsTable addColumn: (wordsTable column: 'words').
	^ methodsTable
	
]

{ #category : #public }
SuggestingNamesExperiment >> loadData [
	| methodsMetadataTable wordsTable |
	
	methodsMetadataTable := self loadMethodsMetadataTable.
	wordsTable := self loadWordsTable.
	methodsTable := self constructMethodsTableFromMetadata: methodsMetadataTable andWords: wordsTable.
	
	self splitWords.
]

{ #category : #private }
SuggestingNamesExperiment >> loadMethodsMetadataTable [
	^ DataFrame readFromCsv: self pathToMethodsMetadataTableFile.
]

{ #category : #private }
SuggestingNamesExperiment >> loadWordsTable [
	^ DataFrame readFromCsv: self pathToWordsTableFile.
]

{ #category : #private }
SuggestingNamesExperiment >> pathToDataDirectory [
	^ '/Users/oleks/Documents/Research/2019-sourcecodedata/data' asFileReference
]

{ #category : #private }
SuggestingNamesExperiment >> pathToMethodsMetadataTableFile [
	^ self pathToDataDirectory / 'methods.csv'.
]

{ #category : #private }
SuggestingNamesExperiment >> pathToWordsTableFile [
	^ self pathToDataDirectory / 'words.csv'.
]

{ #category : #private }
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
